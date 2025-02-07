import 'dart:developer';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ModelHandler {
  static late Interpreter _interpreter;
  static late List<String> _labels;
  static bool _isInitialized = false;

  static Future<void> initModel() async {
    if (_isInitialized) return;

    try {
      _interpreter = await Interpreter.fromAsset('assets/MLModel/model.tflite',
          options: InterpreterOptions()..threads = 4);

      // Verify input tensor shape
      final inputTensor = _interpreter.getInputTensor(0);
      if (!(inputTensor.shape[1] == 224 &&
          inputTensor.shape[2] == 224 &&
          inputTensor.shape[3] == 3)) {
        throw Exception('Invalid input tensor shape');
      }

      final labelData = await rootBundle.loadString('assets/MLModel/labels.txt');
      _labels = labelData.split('\n');
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to load model: $e');
    }
  }

  static Future<String?> classifyImage(File imageFile) async {
    if (!_isInitialized) throw Exception('Model not initialized');

    try {
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);
      if (image == null) return null;

      // Preprocess image
      final processedImage = _preprocessImage(image);

      // Allocate tensors
      final input = [processedImage];
      final output = List.generate(1, (_) => List<double>.filled(37, 0.0));

      // Run inference
      _interpreter.runForMultipleInputs(input, {0: output});

      // Get results
      final probabilities = output[0];
      final maxIndex =
          probabilities.indexOf(probabilities.reduce((a, b) => a > b ? a : b));

      return _labels[maxIndex];
    } catch (e) {
      log('Error during classification: $e');
      return null;
    }
  }

  static List<List<List<List<double>>>> _preprocessImage(img.Image image) {
    final resizedImage = img.copyResize(image, width: 224, height: 224);
    final normalizedValues = Float32List(1 * 224 * 224 * 3);
    int index = 0;

    for (var y = 0; y < 224; y++) {
      for (var x = 0; x < 224; x++) {
        final pixel = resizedImage.getPixel(x, y);

        // MobileNetV2 typically expects values in [-1, 1] range
        normalizedValues[index++] = (pixel.r / 127.5) - 1.0;
        normalizedValues[index++] = (pixel.g / 127.5) - 1.0;
        normalizedValues[index++] = (pixel.b / 127.5) - 1.0;
      }
    }

    // Reshape to [1, 224, 224, 3]
    return [
      List.generate(
          224,
          (y) => List.generate(
              224,
              (x) => List.generate(
                  3, (c) => normalizedValues[(y * 224 * 3) + (x * 3) + c])))
    ];
  }
}
