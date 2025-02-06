import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/modules/Detection/cubit/states.dart';
import '../../../models/history_item.dart';
import '../../../shared/network/local/history_db.dart';

class DetectionCubit extends Cubit<DetectionStates> {
  DetectionCubit() : super(DetectionInitialState()) {
    _loadHistory(); // Load once when cubit is created
  }

  static DetectionCubit get(context) => BlocProvider.of(context);

  File? _currentImage;
  String? _currentResult;
  List<HistoryItem> history = [];

  File? get currentImage => _currentImage;

  String? get currentResult => _currentResult;

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
                title: item['title'],
                treatment: item['treatment'],
                imagePath: item['imagePath'],
                date: DateTime.parse(item['date']),
              ))
          .toList();
      emit(HistoryLoadedState());
    } catch (e) {
      emit(HistoryErrorState(e.toString()));
    }
  }

  Future<void> addDetectionToHistory(File image, String result) async {
    try {
      final newItem = HistoryItem(
        id: 0,
        // Temporary ID, will be replaced by database ID
        title: result,
        treatment: 'none',
        imagePath: image.path,
        date: DateTime.now(),
      );

      // Insert to database and get real ID
      final id = await HistoryDBHelper().insertHistory({
        'title': newItem.title,
        'treatment': newItem.treatment,
        'imagePath': newItem.imagePath,
        'date': newItem.date.toIso8601String(),
      });

      // Update local list with database-generated ID
      history.insert(0, newItem.copyWith(id: id));
      emit(HistoryUpdatedState());
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

      // Delete image file
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }

      // Update local list
      history.removeWhere((item) => item.id == id);
      emit(HistoryUpdatedState());
    } catch (e) {
      emit(HistoryErrorState(e.toString()));
    }
  }
}
