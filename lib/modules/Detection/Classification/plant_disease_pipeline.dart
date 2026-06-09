import 'dart:async';
import 'dart:io';

import '../../../shared/utils/disease_label_parser.dart';
import 'disease_classifier.dart';
import 'plant_classifier.dart';

class PlantDiseaseAnalysisResult {
  final bool isPlant;
  final bool rejected;
  final String? diseaseLabel;
  final double confidence;
  final bool isUncertain;
  final String? plantGateLabel;
  final String? plantName;

  const PlantDiseaseAnalysisResult({
    required this.isPlant,
    required this.rejected,
    this.diseaseLabel,
    required this.confidence,
    required this.isUncertain,
    this.plantGateLabel,
    this.plantName,
  });
}

class PlantDiseasePipeline {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    await PlantClassifier.load();
    await DiseaseClassifier.load();
    _initialized = true;
  }

  static Future<PlantDiseaseAnalysisResult> analyzePlantDisease(File image) async {
    if (!_initialized) {
      throw Exception('PlantDiseasePipeline not initialized');
    }
    // Timeout after 15 seconds
    return await Future.any([
      _analyzeInternal(image),
      Future.delayed(const Duration(seconds: 15), () {
        throw TimeoutException('Analysis took too long');
      }),
    ]);
  }

  static Future<PlantDiseaseAnalysisResult> _analyzeInternal(File image) async {
    final gate = await PlantClassifier.classify(image);
    if (!gate.isPlant) {
      return PlantDiseaseAnalysisResult(
        isPlant: false,
        rejected: true,
        diseaseLabel: null,
        confidence: gate.confidence,
        isUncertain: false,
        plantGateLabel: gate.label,
      );
    }

    final disease = await DiseaseClassifier.classify(image);
    final plantKey = DiseaseLabelParser.extractPlantKey(disease.labelKey);
    return PlantDiseaseAnalysisResult(
      isPlant: true,
      rejected: false,
      diseaseLabel: disease.labelKey,
      confidence: disease.confidence,
      isUncertain: disease.isUncertain,
      plantGateLabel: gate.label,
      plantName: plantKey != null
          ? DiseaseLabelParser.formatPlantDisplayName(plantKey)
          : null,
    );
  }
}