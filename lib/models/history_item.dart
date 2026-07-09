import 'disease_info.dart';
import '../shared/utils/disease_label_parser.dart';

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

  // ─── Basic properties ───────────────────────────────────────

  /// The raw disease key (e.g., "Apple___Apple_scab")
  String get title => diseaseKey;

  /// Treatment (same for all languages – usually a product name)
  String get treatment => DiseaseInfo.getData(diseaseKey)?.treatment ?? '';

  /// Check if this is a healthy plant
  bool get isHealthy => diseaseKey.toLowerCase().contains('healthy');

  // ─── Localized getters ──────────────────────────────────────

  /// Get localized disease name based on language code ('en' or 'ar')
  String getLocalizedName(String languageCode) {
    return DiseaseInfo.getLocalizedName(diseaseKey, languageCode);
  }

  /// Get localized expert advice based on language code
  String getLocalizedTips(String languageCode) {
    return DiseaseInfo.getTips(diseaseKey, languageCode);
  }

  // ─── Plant name helpers ─────────────────────────────────────

  /// Extract plant key from disease key (e.g., "Apple")
  String? get plantKey => DiseaseLabelParser.extractPlantKey(diseaseKey);

  /// Get localized plant display name
  String getPlantDisplayName(String languageCode) {
    return PlantNameHelper.getLocalizedName(plantKey, languageCode);
  }

  // ─── Legacy compatibility (deprecated) ─────────────────────

  /// @deprecated Use getLocalizedName() instead
  @Deprecated('Use getLocalizedName() instead')
  String get displayName => getLocalizedName('en');

  /// @deprecated Use getLocalizedTips() instead
  @Deprecated('Use getLocalizedTips() instead')
  String get tips => DiseaseInfo.getData(diseaseKey)?.tipsEn ?? '';

  /// @deprecated Use getPlantDisplayName() instead
  @Deprecated('Use getPlantDisplayName() instead')
  String get plantDisplayName =>
      DiseaseLabelParser.formatPlantDisplayName(plantKey);

  // ─── Copy with ──────────────────────────────────────────────

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