class Plant {
  final String name;
  final int id;
  final String npk;
  final String category;
  final String description;
  final String plantingTime;
  final String fertilizer;
  final Map<String, String> storageInfo;
  final Map<String, String> nutritionRecommendations;
  final List<String> marketingTips;
  final List<Disease> diseaseAndPestControl;
  final String imageName;

  Plant({
    required this.name,
    required this.id,
    required this.npk,
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

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      name: json['name'],
      id: json['id'],
      npk: json['npk'],
      category: json['category'],
      description: json['description'],
      plantingTime: json['plantingTime'],
      fertilizer: json['fertilizer'],
      storageInfo: Map<String, String>.from(json['storageInfo']),
      nutritionRecommendations:
          Map<String, String>.from(json['nutritionRecommendations']),
      marketingTips: List<String>.from(json['marketingTips']),
      diseaseAndPestControl:
          (json['diseaseAndPestControl']['commonDiseases'] as List)
              .map((disease) => Disease.fromJson(disease))
              .toList(),
      imageName: json['imageName'],
    );
  }
}

class Disease {
  final String name;
  final String imageURL;
  final String description;
  final String prevention;

  Disease({
    required this.name,
    required this.imageURL,
    required this.description,
    required this.prevention,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      name: json['name'],
      imageURL: json['imageURL'],
      description: json['description'],
      prevention: json['prevention'],
    );
  }
}