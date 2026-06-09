import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';

import 'ml_image_helper.dart';

class DiseaseResult {
  final String labelKey;
  final double confidence;
  final bool isUncertain;

  const DiseaseResult({
    required this.labelKey,
    required this.confidence,
    required this.isUncertain,
  });
}

class DiseaseClassifier {
  static const _modelAsset =
      'models/disease_classification_model/plant_disease_classifier_merged.onnx';
  static const _labelsAsset =
      'models/disease_classification_model/class_labels.json';
  static const double uncertainThreshold = 0.6;

  static OrtSession? _session;
  static List<String> _labelsByIndex = [];

  static Future<void> load() async {
    if (_session != null) return;

    final options = OrtSessionOptions()..setIntraOpNumThreads(4);
    final bytes = (await rootBundle.load(_modelAsset)).buffer.asUint8List();
    _session = OrtSession.fromBuffer(bytes, options);

    final jsonStr = await rootBundle.loadString(_labelsAsset);
    final map = json.decode(jsonStr) as Map<String, dynamic>;
    final maxIndex = map.keys.map(int.parse).reduce((a, b) => a > b ? a : b);
    _labelsByIndex = List.filled(maxIndex + 1, '');
    map.forEach((key, value) {
      _labelsByIndex[int.parse(key)] = value as String;
    });
  }

  static Future<DiseaseResult> classify(File image) async {
    final session = _session;
    if (session == null) throw Exception('DiseaseClassifier not loaded');

    // PERF_FIX: Use async image processing to avoid blocking main thread
    final resized = await decodeAndResize224Async(image);
    final inputData = diseaseInputNchw(resized);
    final inputTensor = OrtValueTensor.createTensorWithDataList(
      inputData,
      [1, 3, kModelInputSize, kModelInputSize],
    );

    final runOptions = OrtRunOptions();
    final outputs = await session.runAsync(
      runOptions,
      {session.inputNames.first: inputTensor},
    );

    inputTensor.release();
    runOptions.release();

    try {
      final output = outputs?.first;
      if (output == null) throw Exception('Disease model returned no output');
      final logits = readLogitsOutput(output.value);
      final probs = softmax(logits);
      final index = argmax(probs);
      final confidence = probs[index];
      return DiseaseResult(
        labelKey: _labelsByIndex[index],
        confidence: confidence,
        isUncertain: confidence < uncertainThreshold,
      );
    } finally {
      outputs?.forEach((o) => o?.release());
    }
  }
}
