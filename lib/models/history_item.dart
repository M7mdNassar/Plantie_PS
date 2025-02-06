class HistoryItem {
  final int id;
  final String title;
  final String treatment;
  final String imagePath;
  final DateTime date;

  HistoryItem({
    required this.id,
    required this.title,
    required this.treatment,
    required this.imagePath,
    required this.date,
  });

  HistoryItem copyWith({
    int? id,
    String? title,
    String? treatment,
    String? imagePath,
    DateTime? date,
  }) {
    return HistoryItem(
      id: id ?? this.id,
      title: title ?? this.title,
      treatment: treatment ?? this.treatment,
      imagePath: imagePath ?? this.imagePath,
      date: date ?? this.date,
    );
  }
}
