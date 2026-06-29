import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'history_db.dart';
import '../remote/supabase_service.dart';

class DetectionUploadService {
  static final DetectionUploadService _instance = DetectionUploadService._internal();

  factory DetectionUploadService() => _instance;

  DetectionUploadService._internal() {
    _initConnectivityListener();
  }

  final HistoryDBHelper _db = HistoryDBHelper();
  final Connectivity _connectivity = Connectivity();
  bool _isUploading = false;

  final ValueNotifier<int> pendingCount = ValueNotifier<int>(0);

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  void _initConnectivityListener() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
          (result) {
        if (result.contains(ConnectivityResult.none)) {
          debugPrint('📡 Detection upload: connection lost');
        } else {
          debugPrint('📡 Detection upload: connection restored, attempting uploads...');
          attemptPendingUploads();
        }
      },
    );
  }

  Future<void> _updatePendingCount() async {
    final count = await _db.getPendingUploadQueueItemsCount();
    pendingCount.value = count;
  }

  Future<int?> addDetectionToQueue({
    required String imagePath,
    required String predictedClass,
    required double confidenceScore,
    required String plantType,
    required String supabaseUserId,
  }) async {
    try {
      final now = DateTime.now().toIso8601String();

      final queueItem = {
        'local_image_path': imagePath,
        'predicted_class': predictedClass,
        'confidence_score': confidenceScore,
        'user_corrected_label': null,
        'plant_type': plantType,
        'detected_at': now,
        'supabase_user_id': supabaseUserId,
        'uploaded': 0,
        'upload_attempts': 0,
      };

      final id = await _db.insertUploadQueueItem(queueItem);
      debugPrint('✅ Detection added to queue with ID: $id');
      await _updatePendingCount();
      attemptPendingUploads();
      return id; // ✅ return the ID
    } catch (e) {
      debugPrint('❌ Error adding detection to queue: $e');
      return null;
    }
  }

  Future<void> attemptPendingUploads() async {
    if (_isUploading) {
      debugPrint('⏳ Detection upload already in progress, skipping...');
      return;
    }

    _isUploading = true;

    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        debugPrint('📡 No internet connection, skipping uploads');
        _isUploading = false;
        return;
      }

      final pendingDetections = await _db.getPendingUploadQueueItems();
      if (pendingDetections.isNotEmpty) {
        debugPrint('📦 Found ${pendingDetections.length} pending detections');
        for (final item in pendingDetections) {
          await _uploadSingleItem(item);
        }
      }

      debugPrint('✅ Detection uploads completed');
      await _updatePendingCount();
    } catch (e) {
      debugPrint('❌ Error in attemptPendingUploads: $e');
    } finally {
      _isUploading = false;
    }
  }

  Future<void> _uploadSingleItem(Map<String, dynamic> item) async {
    try {
      final itemId = item['id'] as int;
      final imagePath = item['local_image_path'] as String;
      final predictedClass = item['predicted_class'] as String;
      final confidenceScore = item['confidence_score'] as double;
      final userCorrectedLabel = item['user_corrected_label'];
      final plantType = item['plant_type'] as String;
      final detectedAt = item['detected_at'] as String;

      debugPrint('📤 Uploading detection: $itemId');

      String? supabaseUserId;
      try {
        final supabaseUser = supabaseService.getCurrentUser();
        if (supabaseUser != null) {
          supabaseUserId = supabaseUser.id;
        } else {
          debugPrint('⚠️ No active Supabase session, attempting anonymous login...');
          final authResponse = await supabaseService.client.auth.signInAnonymously();
          if (authResponse.user != null) {
            supabaseUserId = authResponse.user!.id;
          } else {
            throw Exception('Anonymous auth returned no user');
          }
        }
      } catch (e) {
        debugPrint('❌ Session check failed: $e');
        await _db.incrementUploadAttempts(itemId);
        await _updatePendingCount();
        return;
      }

      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        debugPrint('⚠️ Image file not found: $imagePath, marking as uploaded');
        await _db.markUploadQueueItemAsUploaded(itemId);
        await _updatePendingCount();
        return;
      }

      final imageBytes = await imageFile.readAsBytes();
      final fileName = DateTime.now().millisecondsSinceEpoch.toString() + '_detection.jpg';

      String imageUrl;
      try {
        imageUrl = await supabaseService.uploadFile(
          bucket: 'detection-images',
          path: supabaseUserId,
          fileBytes: imageBytes,
          fileName: fileName,
        );
      } catch (e) {
        debugPrint('❌ Image upload failed: $e');
        await _db.incrementUploadAttempts(itemId);
        await _updatePendingCount();
        return;
      }

      try {
        final finalPredictedClass = userCorrectedLabel ?? predictedClass;
        await supabaseService.insertDetectionResult(
          userId: supabaseUserId,
          plantType: plantType,
          predictedClass: finalPredictedClass,
          confidenceScore: confidenceScore,
          userCorrectedLabel: userCorrectedLabel,
          imageUrl: imageUrl,
          detectedAt: DateTime.parse(detectedAt),
        );
        await _db.markUploadQueueItemAsUploaded(itemId);
        debugPrint('✅ Queue item $itemId marked as uploaded');
        await _updatePendingCount();
      } catch (e) {
        debugPrint('❌ Metadata insert failed: $e');
        await _db.incrementUploadAttempts(itemId);
        await _updatePendingCount();
      }
    } catch (e) {
      debugPrint('❌ Error uploading single item: $e');
    }
  }

  Future<void> upgradeGuestToAuthenticated({
    required String guestId,
    required String authenticatedUserId,
  }) async {
    try {
      debugPrint('🔄 Upgrading guest $guestId to authenticated $authenticatedUserId');
      await _db.updateUserIdForQueueItems(guestId, authenticatedUserId);
      debugPrint('✅ Detection queue items updated with new user ID');
      await _updatePendingCount();
      attemptPendingUploads();
    } catch (e) {
      debugPrint('❌ Error upgrading guest session: $e');
    }
  }

  void dispose() {
    _connectivitySubscription.cancel();
    pendingCount.dispose();
  }
}

final detectionUploadService = DetectionUploadService();