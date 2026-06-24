import 'dart:developer';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plantie/modules/Detection/cubit/states.dart';
import 'package:plantie/models/user/user_model.dart';
import 'package:plantie/shared/network/local/upload_queue_service.dart';
import '../../../models/disease_info.dart';
import '../../../models/history_item.dart';
import '../../../shared/utils/disease_label_parser.dart';
import '../../../shared/network/local/history_db.dart';
import '../../../shared/network/local/image_storage_helper.dart';

class DetectionCubit extends Cubit<DetectionStates> {
  DetectionCubit() : super(DetectionInitialState()) {
    _loadHistory();
  }

  static DetectionCubit get(context) => BlocProvider.of(context);

  File? _currentImage;
  String? _currentResult;
  String? _orginalResult;
  List<HistoryItem> history = [];
  int? _currentQueueId;

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

  void setNonPlantResult(File image, String displayTitle, double confidence) {
    print('🟢 [Cubit] setNonPlantResult called');
    print('   - image: ${image.path}');
    print('   - title: $displayTitle');
    print('   - confidence: $confidence');
    print('   - _isProcessing before: $_isProcessing');

    _isProcessing = false;
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
      // ✅ Null safety: ensure user exists before queueing
      final user = CurrentUser.user;
      if (user == null) {
        log('⚠️ CurrentUser is null, cannot queue detection');
        // Still save locally? We can save without user ID, but then upload won't work.
        // For safety, we store with 'unknown' but that will fail RLS.
        // Better to show error.
        emit(HistoryErrorState('User not logged in. Cannot save detection.'));
        return;
      }

      File permanentImage = image;
      if (!await image.exists()) {
        throw Exception('Original image file not found at ${image.path}');
      }

      final documentsDir = await getApplicationDocumentsDirectory();
      if (!image.path.startsWith(documentsDir.path)) {
        log('Image not in permanent storage, copying now...');
        final savedImage = await ImageStorageHelper.saveImagePermanently(image);
        permanentImage = savedImage;
      } else {
        if (!await permanentImage.exists()) {
          throw Exception('Permanent image file not found at ${permanentImage.path}');
        }
      }

      final finalImagePath = permanentImage.path;

      final newItem = HistoryItem(
        id: 0,
        diseaseKey: result,
        imagePath: finalImagePath,
        date: DateTime.now(),
      );

      final id = await HistoryDBHelper().insertHistory({
        'diseaseKey': result,
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

      final confidence = detectionConfidence ?? 0.95;
      final plantTypeKey = plantKey ?? 'unknown';
      final userId = user.id; // now non-null

      final queueId = await uploadQueueService.addDetectionToQueue(
        imagePath: finalImagePath,
        predictedClass: result,
        confidenceScore: confidence,
        plantType: plantTypeKey,
        supabaseUserId: userId,
      );

      _currentQueueId = queueId;

      log('✅ Detection queued for upload with user ID: $userId (Queue ID: $queueId)');
    } catch (e) {
      emit(HistoryErrorState('Failed to save detection: $e'));
    }
  }

  Future<void> deleteHistoryItem(int id, String imagePath) async {
    try {
      final db = await HistoryDBHelper().database;
      await db.delete(
        'history',
        where: 'id = ?',
        whereArgs: [id],
      );
      await ImageStorageHelper.deleteImageFile(imagePath);
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