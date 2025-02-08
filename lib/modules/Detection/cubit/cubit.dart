import 'dart:developer';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/modules/Detection/cubit/states.dart';
import '../../../models/disease_info.dart';
import '../../../models/history_item.dart';
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

  File? get currentImage => _currentImage;

  String? get currentResult => _currentResult;
  String? get orginalResult => _orginalResult;


  void setDetectionResult(File image, String result) {
    _currentImage = image;
    _currentResult = result;
    emit(DetectionResultState());
  }

  void addToHistory(HistoryItem item) {
    history.insert(0, item);
    emit(HistoryUpdatedState());
  }

  Future<void> _loadHistory() async {
    emit(HistoryLoadingState());
    try {
      final dbHistory = await HistoryDBHelper().getHistory();
      history = dbHistory
          .map((item) => HistoryItem(
        id: item['id'],
        diseaseKey: item['diseaseKey'],
        imagePath: item['imagePath'],
        date: DateTime.parse(item['date']),
      ))
          .toList();

      // Verify images exist
      for (final item in history) {
        final file = File(item.imagePath);
        if (!await file.exists()) {
          log('Missing image for history item ${item.id} at ${item.imagePath}');
        }
      }

      emit(HistoryLoadedState());
    } catch (e) {
      emit(HistoryErrorState(e.toString()));
    }
  }

  Future<void> addDetectionToHistory(File image, String result) async {
    try {
      final newItem = HistoryItem(
        id: 0,
        diseaseKey: result, // Store disease key instead of title
        imagePath: image.path,
        date: DateTime.now(),
      );

      // Insert to database
      final id = await HistoryDBHelper().insertHistory({
        'diseaseKey': result, // Changed from title
        'imagePath': image.path,
        'date': DateTime.now().toIso8601String(),
      });

      history.insert(0, newItem.copyWith(id: id));
      emit(HistoryUpdatedState());

      _orginalResult = result;
      // Set detection result using DiseaseInfo
      final diseaseName = DiseaseInfo.data[result]?.name ?? result;
      setDetectionResult(image, diseaseName);
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
}
