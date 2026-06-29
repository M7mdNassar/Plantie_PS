import 'dart:developer';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plantie/modules/Detection/cubit/states.dart';
import 'package:plantie/models/user/user_model.dart';
import '../../../models/history_item.dart';
import '../../../shared/network/local/detection_upload_service.dart';
import '../../../shared/utils/disease_label_parser.dart';
import '../../../shared/network/local/history_db.dart';
import '../../../shared/network/local/image_storage_helper.dart';

class DetectionCubit extends Cubit<DetectionStates> {
  DetectionCubit() : super(DetectionInitialState()) {
    _loadHistory();
  }

  static DetectionCubit get(context) => BlocProvider.of(context);

  File? _currentImage;
  String? _currentResult; // stores disease KEY, not localized name
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

  void setDetectionResult(File image, String diseaseKey) {
    _isProcessing = false;
    _currentImage = image;
    _currentResult = diseaseKey; // store key, not display name
    emit(DetectionResultState());
  }

  void setNonPlantResult(File image, String displayTitle, double confidence) {
    print('🟢 [Cubit] setNonPlantResult called');
    print('   - image: ${image.path}');
    print('   - title: $displayTitle');
    print('   - confidence: $confidence');

    _isProcessing = false;
    _currentImage = image;
    _currentResult = displayTitle; // for non-plant, we store the display message
    _orginalResult = null;
    detectionRejected = true;
    detectionConfidence = confidence;
    detectionUncertain = false;

    emit(DetectionResultState());
  }

  void startDetectionLoading(File image) {
    print('🔵 [Cubit] startDetectionLoading called');
    if (_isProcessing) {
      print('⚠️ Already processing, ignoring');
      return;
    }
    _isProcessing = true;
    _currentImage = image;
    clearDetectionFlags();
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
      final user = CurrentUser.user;
      if (user == null) {
        log('⚠️ CurrentUser is null, cannot queue detection');
        emit(HistoryErrorState('User not logged in. Cannot save detection.'));
        return;
      }

      // ✅ Image is already permanent (saved by ImagePickerHandler)
      final finalImagePath = image.path;

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

      // Store the disease key, not the display name
      setDetectionResult(image, result);

      final confidence = detectionConfidence ?? 0.95;
      final plantTypeKey = plantKey ?? 'unknown';
      final userId = user.id;

      // ✅ addDetectionToQueue now returns Future<int?>, so assignment is valid
      final queueId = await detectionUploadService.addDetectionToQueue(
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