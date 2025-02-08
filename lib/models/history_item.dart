import 'disease_info.dart';

class HistoryItem {
  final int id;
  final String diseaseKey;
  final String imagePath;
  final DateTime date;

  HistoryItem({
    required this.id,
    required this.diseaseKey,
    required this.imagePath,
    required this.date,
  });

  String get title => DiseaseInfo.data[diseaseKey]?.name ?? diseaseKey;
  String get treatment => DiseaseInfo.data[diseaseKey]?.treatment ?? '';
  String get tips => DiseaseInfo.data[diseaseKey]?.tips ?? '';

  HistoryItem copyWith({
    int? id,
    String? diseaseKey,
    String? imagePath,
    DateTime? date,
  }) {
    return HistoryItem(
      id: id ?? this.id,
      diseaseKey: diseaseKey ?? this.diseaseKey,
      imagePath: imagePath ?? this.imagePath,
      date: date ?? this.date,
    );
  }
}