class Plant {
  final int id;
  final String emoji;
  final String npk;
  final Map<String, String> name;
  final Map<String, String> scientificName;
  final Map<String, String> category;
  final Map<String, String> description;
  final Map<String, String> plantingTime;
  final Map<String, String> fertilizer;
  final StorageInfo storageInfo;
  final NutritionRecommendations nutritionRecommendations;
  final List<MarketingTip> marketingTips;
  final List<Disease> diseaseAndPestControl;
  final String imageName;

  Plant({
    required this.id,
    required this.emoji,
    required this.npk,
    required this.name,
    required this.scientificName,
    required this.category,
    required this.description,
    required this.plantingTime,
    required this.fertilizer,
    required this.storageInfo,
    required this.nutritionRecommendations,
    required this.marketingTips,
    required this.diseaseAndPestControl,
    required this.imageName,
  });

  // Helper to safely get localized value
  static String getLocalized(Map<String, String>? map, String locale) {
    if (map == null) return '';
    return map[locale] ?? map['en'] ?? '';
  }

  String getName(String locale) => getLocalized(name, locale);
  String getCategory(String locale) => getLocalized(category, locale);
  String getDescription(String locale) => getLocalized(description, locale);
  String getPlantingTime(String locale) => getLocalized(plantingTime, locale);
  String getFertilizer(String locale) => getLocalized(fertilizer, locale);

  factory Plant.fromJson(Map<String, dynamic> json) {
    // Safe map extraction helper
    Map<String, String> _safeMap(dynamic value) {
      if (value == null) return {};
      if (value is Map) {
        return Map<String, String>.from(value.map((k, v) => MapEntry(k.toString(), v?.toString() ?? '')));
      }
      return {};
    }

    return Plant(
      id: json['id'] as int? ?? 0,
      emoji: json['emoji'] as String? ?? '🌿',
      npk: json['npk'] as String? ?? '0-0-0',
      name: _safeMap(json['name']),
      scientificName: _safeMap(json['scientificName']),
      category: _safeMap(json['category']),
      description: _safeMap(json['description']),
      plantingTime: _safeMap(json['plantingTime']),
      fertilizer: _safeMap(json['fertilizer']),
      storageInfo: StorageInfo.fromJson(json['storageInfo'] ?? {}),
      nutritionRecommendations: NutritionRecommendations.fromJson(json['nutritionRecommendations'] ?? {}),
      marketingTips: (json['marketingTips'] as List?)
          ?.map((e) => MarketingTip.fromJson(e))
          .toList() ?? [],
      diseaseAndPestControl: (json['diseaseAndPestControl']?['commonDiseases'] as List?)
          ?.map((e) => Disease.fromJson(e))
          .toList() ?? [],
      imageName: json['imageName'] as String? ?? '',
    );
  }
}

class StorageInfo {
  final Map<String, String> temperature;
  final Map<String, String> humidity;

  StorageInfo({required this.temperature, required this.humidity});

  factory StorageInfo.fromJson(Map<String, dynamic> json) {
    Map<String, String> _safeMap(dynamic value) {
      if (value == null) return {};
      if (value is Map) {
        return Map<String, String>.from(value.map((k, v) => MapEntry(k.toString(), v?.toString() ?? '')));
      }
      return {};
    }
    return StorageInfo(
      temperature: _safeMap(json['temperature']),
      humidity: _safeMap(json['humidity']),
    );
  }
}

class NutritionRecommendations {
  final Map<String, String> nitrogen;
  final Map<String, String> phosphorus;
  final Map<String, String> potassium;

  NutritionRecommendations({required this.nitrogen, required this.phosphorus, required this.potassium});

  factory NutritionRecommendations.fromJson(Map<String, dynamic> json) {
    Map<String, String> _safeMap(dynamic value) {
      if (value == null) return {};
      if (value is Map) {
        return Map<String, String>.from(value.map((k, v) => MapEntry(k.toString(), v?.toString() ?? '')));
      }
      return {};
    }
    return NutritionRecommendations(
      nitrogen: _safeMap(json['nitrogen']),
      phosphorus: _safeMap(json['phosphorus']),
      potassium: _safeMap(json['potassium']),
    );
  }
}

class MarketingTip {
  final Map<String, String> text;

  MarketingTip({required this.text});

  factory MarketingTip.fromJson(Map<String, dynamic> json) {
    Map<String, String> _safeMap(dynamic value) {
      if (value == null) return {};
      if (value is Map) {
        return Map<String, String>.from(value.map((k, v) => MapEntry(k.toString(), v?.toString() ?? '')));
      }
      return {};
    }
    return MarketingTip(text: _safeMap(json));
  }
}

class Disease {
  final Map<String, String> name;
  final String imageURL;
  final Map<String, String> description;
  final Map<String, String> prevention;

  Disease({
    required this.name,
    required this.imageURL,
    required this.description,
    required this.prevention,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    Map<String, String> _safeMap(dynamic value) {
      if (value == null) return {};
      if (value is Map) {
        return Map<String, String>.from(value.map((k, v) => MapEntry(k.toString(), v?.toString() ?? '')));
      }
      return {};
    }
    return Disease(
      name: _safeMap(json['name']),
      imageURL: json['imageURL'] as String? ?? '',
      description: _safeMap(json['description']),
      prevention: _safeMap(json['prevention']),
    );
  }
}