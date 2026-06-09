/// Parses model class keys such as `Apple___Apple_scab` or `olive_healthy`.
class DiseaseLabelParser {
  DiseaseLabelParser._();

  static const String _triple = '___';

  /// Labels that use `plant_condition` without triple underscores.
  static const Set<String> _singlePrefixPlants = {'olive'};

  /// Plant key from a disease label, e.g. `Apple___Apple_scab` → `Apple`.
  static String? extractPlantKey(String? label) {
    if (label == null || label.isEmpty) return null;

    final tripleIndex = label.indexOf(_triple);
    if (tripleIndex > 0) {
      return label.substring(0, tripleIndex);
    }

    for (final plant in _singlePrefixPlants) {
      if (label == plant || label.startsWith('${plant}_')) {
        return plant;
      }
    }
    return null;
  }

  /// Condition segment after the plant, e.g. `Apple___Apple_scab` → `Apple_scab`.
  static String? extractConditionKey(String? label) {
    if (label == null || label.isEmpty) return null;

    final tripleIndex = label.indexOf(_triple);
    if (tripleIndex > 0 && tripleIndex + _triple.length < label.length) {
      return label.substring(tripleIndex + _triple.length);
    }

    final plant = extractPlantKey(label);
    if (plant != null && label.length > plant.length + 1) {
      return label.substring(plant.length + 1);
    }
    return null;
  }

  /// Human-readable plant name: `Pepper_bell` → `Pepper Bell`.
  static String formatPlantDisplayName(String? plantKey) {
    if (plantKey == null || plantKey.isEmpty) return '';
    return plantKey
        .split('_')
        .where((p) => p.isNotEmpty)
        .map(_capitalizeWord)
        .join(' ');
  }

  static String _capitalizeWord(String word) {
    if (word.length == 1) return word.toUpperCase();
    return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
  }
}
