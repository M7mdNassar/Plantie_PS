import 'dart:io';

import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';

import 'ml_image_helper.dart';

class PlantGateResult {
  final bool isPlant;
  final String label;
  final double confidence;

  const PlantGateResult({
    required this.isPlant,
    required this.label,
    required this.confidence,
  });
}

class PlantClassifier {
  static const _modelAsset =
      'models/plant_nonPlant_model/plant_classifier.onnx';
  static const _labelsAsset = 'models/plant_nonPlant_model/labels.txt';

  static OrtSession? _session;
  static List<String> _labels = [];

  static Future<void> load() async {
    if (_session != null) return;

    OrtEnv.instance.init();
    final options = OrtSessionOptions()..setIntraOpNumThreads(4);
    final bytes = (await rootBundle.load(_modelAsset)).buffer.asUint8List();
    _session = OrtSession.fromBuffer(bytes, options);

    final raw = await rootBundle.loadString(_labelsAsset);
    _labels = raw
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    if (_labels.length < 2) {
      throw Exception('Plant labels.txt must have at least 2 lines');
    }
  }

  static Future<PlantGateResult> classify(File image) async {
    final session = _session;
    if (session == null) throw Exception('PlantClassifier not loaded');

    // PERF_FIX: Use async image processing to avoid blocking main thread
    final resized = await decodeAndResize224Async(image);
    final inputData = plantGateInputNhwc(resized);
    final inputTensor = OrtValueTensor.createTensorWithDataList(
      inputData,
      [1, kModelInputSize, kModelInputSize, 3],
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
      if (output == null) throw Exception('Plant model returned no output');
      final score = readScalarOutput(output.value);
      final isPlant = score >= 0.5;
      final labelIndex = isPlant ? 1 : 0;
      final confidence = isPlant ? score : 1.0 - score;
      return PlantGateResult(
        isPlant: isPlant,
        label: _labels[labelIndex],
        confidence: confidence,
      );
    } finally {
      outputs?.forEach((o) => o?.release());
    }
  }
}
