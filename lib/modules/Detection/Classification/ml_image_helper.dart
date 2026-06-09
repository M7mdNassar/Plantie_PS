import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

const int kModelInputSize = 224;

const List<double> _diseaseMean = [0.485, 0.456, 0.406];
const List<double> _diseaseStd = [0.229, 0.224, 0.225];

// PERF_FIX: Async version that uses compute() to avoid blocking main thread
Future<img.Image> decodeAndResize224Async(File file) async {
  return await compute(_decodeAndResize224Isolated, file);
}

// Isolated function for background processing
img.Image _decodeAndResize224Isolated(File file) {
  return _decodeAndResize224Implementation(file);
}

/// Decode [file] to RGB and resize to 224×224 (bilinear).
img.Image decodeAndResize224(File file) {
  return _decodeAndResize224Implementation(file);
}

/// Implementation - shared between sync and async versions
img.Image _decodeAndResize224Implementation(File file) {
  final bytes = file.readAsBytesSync();
  final decoded = img.decodeImage(bytes);
  if (decoded == null) {
    throw Exception('Could not decode image');
  }
  return img.copyResize(
    decoded,
    width: kModelInputSize,
    height: kModelInputSize,
    interpolation: img.Interpolation.linear,
  );
}

/// Plant gate: NHWC [1, 224, 224, 3], (pixel/127.5) - 1.0 per channel.
Float32List plantGateInputNhwc(img.Image resized) {
  final out = Float32List(kModelInputSize * kModelInputSize * 3);
  var i = 0;
  for (var y = 0; y < kModelInputSize; y++) {
    for (var x = 0; x < kModelInputSize; x++) {
      final p = resized.getPixel(x, y);
      out[i++] = (p.r / 127.5) - 1.0;
      out[i++] = (p.g / 127.5) - 1.0;
      out[i++] = (p.b / 127.5) - 1.0;
    }
  }
  return out;
}

/// Disease model: NCHW [1, 3, 224, 224], ImageNet normalize.
Float32List diseaseInputNchw(img.Image resized) {
  final out = Float32List(3 * kModelInputSize * kModelInputSize);
  for (var c = 0; c < 3; c++) {
    final mean = _diseaseMean[c];
    final std = _diseaseStd[c];
    final channelOffset = c * kModelInputSize * kModelInputSize;
    for (var y = 0; y < kModelInputSize; y++) {
      for (var x = 0; x < kModelInputSize; x++) {
        final p = resized.getPixel(x, y);
        final v = switch (c) {
          0 => p.r,
          1 => p.g,
          _ => p.b,
        };
        out[channelOffset + y * kModelInputSize + x] =
            ((v / 255.0) - mean) / std;
      }
    }
  }
  return out;
}

List<double> softmax(List<double> logits) {
  if (logits.isEmpty) return const [];
  final maxLogit = logits.reduce(math.max);
  final exps = logits.map((e) => math.exp(e - maxLogit)).toList();
  final sum = exps.fold<double>(0, (a, b) => a + b);
  return exps.map((e) => e / sum).toList();
}

int argmax(List<double> values) {
  var best = 0;
  for (var i = 1; i < values.length; i++) {
    if (values[i] > values[best]) best = i;
  }
  return best;
}

double readScalarOutput(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is List) {
    if (value.isEmpty) throw Exception('Empty model output');
    if (value.first is List) return readScalarOutput(value.first);
    return (value.first as num).toDouble();
  }
  throw Exception('Unexpected output type: ${value.runtimeType}');
}

List<double> readLogitsOutput(dynamic value) {
  if (value is List<num>) {
    return value.map((e) => e.toDouble()).toList();
  }
  if (value is List) {
    if (value.isEmpty) throw Exception('Empty logits');
    final first = value.first;
    if (first is num) {
      return value.map((e) => (e as num).toDouble()).toList();
    }
    if (first is List) {
      return readLogitsOutput(first);
    }
  }
  throw Exception('Unexpected logits type: ${value.runtimeType}');
}
