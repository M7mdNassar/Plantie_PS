import 'dart:developer';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plantie/modules/Detection/cubit/states.dart';
import 'package:plantie/models/user/user_model.dart';
import 'package:plantie/shared/services/upload_queue_service.dart';
import '../../../models/disease_info.dart';
import '../../../models/history_item.dart';
import '../../../shared/utils/disease_label_parser.dart';
import '../../../shared/network/local/history_db.dart';
import '../../../shared/network/local/image_storage_helper.dart';

class DetectionCubit extends Cubit<DetectionStates> {
  DetectionCubit() : super(DetectionInitialState()) {
    _loadHistory(); // Load once when cubit is created
  }

  static DetectionCubit get(context) => BlocProvider.of(context);

  File? _currentImage;
  String? _currentResult;
  String? _orginalResult;
  List<HistoryItem> history = [];
  int? _currentQueueId; // Track the queue ID for the current detection

  File? get currentImage => _currentImage;

  String? get currentResult => _currentResult;
  String? get orginalResult => _orginalResult;
  int? get currentQueueId => _currentQueueId;

  double? detectionConfidence;
  bool detectionUncertain = false;
  bool detectionRejected = false;
  String? currentPlantName;

  bool _isProcessing = false;


  void clearDetectionFlags() {
    detectionConfidence = null;
    detectionUncertain = false;
    detectionRejected = false;
    currentPlantName = null;
    _currentQueueId = null;
  }

  void setDetectionResult(File image, String result) {
    _isProcessing = false;
    _currentImage = image;
    _currentResult = result;
    emit(DetectionResultState());
  }

  // void setNonPlantResult(File image, String displayTitle, double confidence) {
  //   _isProcessing = false;
  //   _currentImage = image;
  //   _currentResult = displayTitle;
  //   _orginalResult = null;
  //   detectionRejected = true;
  //   detectionConfidence = confidence;
  //   detectionUncertain = false;
  //   emit(DetectionResultState());
  // }

  void setNonPlantResult(File image, String displayTitle, double confidence) {
    print('🟢 [Cubit] setNonPlantResult called');
    print('   - image: ${image.path}');
    print('   - title: $displayTitle');
    print('   - confidence: $confidence');
    print('   - _isProcessing before: $_isProcessing');

    _isProcessing = false;  // ✅ Critical: reset processing flag
    _currentImage = image;
    _currentResult = displayTitle;
    _orginalResult = null;
    detectionRejected = true;
    detectionConfidence = confidence;
    detectionUncertain = false;

    print('🟢 [Cubit] Emitting DetectionResultState');
    emit(DetectionResultState());
    print('🟢 [Cubit] DetectionResultState emitted');
  }


  // void startDetectionLoading(File image) {
  //   if (_isProcessing) return;
  //   _isProcessing = true;
  //   _currentImage = image;
  //   clearDetectionFlags();
  //   emit(DetectionLoadingState());
  // }

  void startDetectionLoading(File image) {
    print('🔵 [Cubit] startDetectionLoading called');
    print('   - image: ${image.path}');
    print('   - _isProcessing: $_isProcessing');
    if (_isProcessing) {
      print('⚠️ Already processing, ignoring');
      return;
    }
    _isProcessing = true;
    _currentImage = image;
    clearDetectionFlags();
    print('🔵 [Cubit] Emitting DetectionLoadingState');
    emit(DetectionLoadingState());
  }


  void addToHistory(HistoryItem item) {
    history.insert(0, item);
    emit(HistoryUpdatedState());
  }

  Future<void> _loadHistory() async {
    emit(HistoryLoadingState());
    try {
      final dbHistory = await HistoryDBHelper().getHistory();
      final loadedItems = <HistoryItem>[];

      // Verify images exist and only add valid history items
      for (final item in dbHistory) {
        final historyItem = HistoryItem(
          id: item['id'],
          diseaseKey: item['diseaseKey'],
          imagePath: item['imagePath'],
          date: DateTime.parse(item['date']),
        );

        final file = File(historyItem.imagePath);
        if (await file.exists()) {
          loadedItems.add(historyItem);
        } else {
          log('Skipping history item ${historyItem.id} - image not found at ${historyItem.imagePath}');
        }
      }

      history = loadedItems;
      emit(HistoryLoadedState());
    } catch (e) {
      log('Error loading history: $e');
      emit(HistoryErrorState(e.toString()));
    }
  }

  Future<void> addDetectionToHistory(File image, String result) async {
    try {
      // Ensure image is saved permanently
      File permanentImage = image;

      // Check if file exists, if not try to save it
      if (!await image.exists()) {
        throw Exception('Original image file not found at ${image.path}');
      }

      // If the image is not in the documents directory, save it permanently
      final documentsDir = await getApplicationDocumentsDirectory();
      if (!image.path.startsWith(documentsDir.path)) {
        log('Image not in permanent storage, copying now...');
        final savedImage = await ImageStorageHelper.saveImagePermanently(image);
        permanentImage = savedImage;
      } else {
        // Verify the permanent image still exists
        if (!await permanentImage.exists()) {
          throw Exception(
              'Permanent image file not found at ${permanentImage.path}');
        }
      }

      final finalImagePath = permanentImage.path;

      final newItem = HistoryItem(
        id: 0,
        diseaseKey: result, // Store disease key instead of title
        imagePath: finalImagePath,
        date: DateTime.now(),
      );

      // Insert to database
      final id = await HistoryDBHelper().insertHistory({
        'diseaseKey': result, // Changed from title
        'imagePath': finalImagePath,
        'date': DateTime.now().toIso8601String(),
      });

      history.insert(0, newItem.copyWith(id: id));
      emit(HistoryUpdatedState());

      _orginalResult = result;
      final plantKey = DiseaseLabelParser.extractPlantKey(result);
      currentPlantName = plantKey != null
          ? DiseaseLabelParser.formatPlantDisplayName(plantKey)
          : null;
      final diseaseName = DiseaseInfo.data[result]?.name ?? result;
      setDetectionResult(permanentImage, diseaseName);

      // ==================== ADD TO UPLOAD QUEUE ====================
      // Queue the detection for uploading to cloud
      // Extract confidence from result if available (NEEDS_MANUAL: confidence extraction logic)
      final confidence = detectionConfidence ?? 0.95;
      final plantTypeKey = plantKey ?? 'unknown';
      final userId = CurrentUser.user?.id ?? 'unknown';

      final queueId = await uploadQueueService.addDetectionToQueue(
        imagePath: finalImagePath,
        predictedClass: result,
        confidenceScore: confidence,
        plantType: plantTypeKey,
        supabaseUserId: userId,
      );

      // Store queue ID for feedback widget to link corrections
      _currentQueueId = queueId;

      log('✅ Detection queued for upload with user ID: $userId (Queue ID: $queueId)');
    } catch (e) {
      emit(HistoryErrorState('Failed to save detection: $e'));
    }
  }

  Future<void> deleteHistoryItem(int id, String imagePath) async {
    try {
      // Delete from database
      final db = await HistoryDBHelper().database;
      await db.delete(
        'history',
        where: 'id = ?',
        whereArgs: [id],
      );

      // Delete image file from permanent storage
      await ImageStorageHelper.deleteImageFile(imagePath);

      // Update local list
      history.removeWhere((item) => item.id == id);
      emit(HistoryUpdatedState());
    } catch (e) {
      emit(HistoryErrorState(e.toString()));
    }
  }

  void emitErrorState(String message) {
    _isProcessing = false;
    clearDetectionFlags();
    emit(DetectionErrorState(message));
  }
}
