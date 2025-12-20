import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:tflite_v2/tflite_v2.dart';

class ClassifierService {
  bool _isModelLoaded = false;

  bool get isModelLoaded => _isModelLoaded;

  Future<void> loadModel() async {
    try {
      String? res = await Tflite.loadModel(
        model: "assets/model/model_unquant.tflite",
        labels: "assets/model/labels.txt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false,
      );
      _isModelLoaded = res != null;
      debugPrint("Model loaded: $res");
    } catch (e) {
      debugPrint("Failed to load model: $e");
      _isModelLoaded = false;
    }
  }

  Future<List?> classifyImage(File image) async {
    if (!_isModelLoaded) return null;

    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 127.5, // Standard for Teachable Machine
      imageStd: 127.5,  // Standard for Teachable Machine
      numResults: 1,    // Focus on the best match for accuracy
      threshold: 0.2,   // Filter out low-confidence noise
      asynch: true,
    );
    return recognitions;
  }

  Future<void> dispose() async {
    await Tflite.close();
  }
}
