import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../network/local/history_db.dart';
import '../network/remote/supabase_service.dart';

class UploadQueueService {
  static final UploadQueueService _instance = UploadQueueService._internal();

  factory UploadQueueService() {
    return _instance;
  }

  UploadQueueService._internal() {
    _initConnectivityListener();
  }

  final HistoryDBHelper _db = HistoryDBHelper();
  final Connectivity _connectivity = Connectivity();
  bool _isUploading = false;

  // Connectivity listener
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  void _initConnectivityListener() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (result) {
        if (result.contains(ConnectivityResult.none)) {
          debugPrint('📡 Connection lost');
        } else {
          debugPrint('📡 Connection restored, attempting uploads...');
          attemptPendingUploads();
        }
      },
    );
  }

  /// Main method to attempt uploading all pending queue items
  /// Safe to call multiple times concurrently (uses _isUploading flag)
  Future<void> attemptPendingUploads() async {
    if (_isUploading) {
      debugPrint('⏳ Upload already in progress, skipping...');
      return;
    }

    _isUploading = true;

    try {
      debugPrint('🚀 Starting pending uploads...');

      // Check internet connectivity first
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        debugPrint('📡 No internet connection, skipping uploads');
        _isUploading = false;
        return;
      }

      // Get all pending items
      final pendingItems = await _db.getPendingUploadQueueItems();

      if (pendingItems.isEmpty) {
        debugPrint('✅ No pending items to upload');
        _isUploading = false;
        return;
      }

      debugPrint('📦 Found ${pendingItems.length} pending items to upload');

      // Upload each item
      for (final item in pendingItems) {
        await _uploadSingleItem(item);
      }

      debugPrint('✅ Pending uploads completed');
    } catch (e) {
      debugPrint('❌ Error in attemptPendingUploads: $e');
    } finally {
      _isUploading = false;
    }
  }

  /// Upload a single detection result to Supabase
  Future<void> _uploadSingleItem(Map<String, dynamic> item) async {
    try {
      final itemId = item['id'] as int;
      final imagePath = item['local_image_path'] as String;
      final predictedClass = item['predicted_class'] as String;
      final confidenceScore = item['confidence_score'] as double;
      final userCorrectedLabel = item['user_corrected_label'];
      final plantType = item['plant_type'] as String;
      final detectedAt = item['detected_at'] as String;
      // Local UUID (used for offline storage, not for Supabase)
      final _ = item['supabase_user_id'] as String;

      debugPrint('📤 Uploading detection: $itemId');

      // ⚠️ CRITICAL: Before uploading, ensure Supabase session exists
      // This is where we handle the auth.uid() mapping
      String? supabaseUserId;
      try {
        final supabaseUser = supabaseService.getCurrentUser();
        if (supabaseUser != null) {
          supabaseUserId = supabaseUser.id; // Real auth.uid() for RLS policy
          debugPrint('✅ Using Supabase auth.uid(): $supabaseUserId');
        } else {
          // Try to create anonymous session (internet must be available at this point)
          debugPrint('⚠️ No active Supabase session, attempting anonymous login...');
          try {
            final authResponse =
                await supabaseService.client.auth.signInAnonymously();
            if (authResponse.user != null) {
              supabaseUserId = authResponse.user!.id;
              debugPrint('✅ Created Supabase anonymous session: $supabaseUserId');
            } else {
              throw Exception('Anonymous auth returned no user');
            }
          } catch (e) {
            debugPrint('❌ Cannot create Supabase session: $e');
            debugPrint(
                '⚠️ Upload requires internet for authentication - will retry later');
            await _db.incrementUploadAttempts(itemId);
            return; // Will retry when internet and auth available
          }
        }
      } catch (e) {
        debugPrint('❌ Session check failed: $e');
        await _db.incrementUploadAttempts(itemId);
        return; // Will retry
      }

      // 1. Upload image to Supabase Storage
      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        debugPrint('⚠️  Image file not found: $imagePath, marking as uploaded');
        await _db.markUploadQueueItemAsUploaded(itemId);
        return;
      }

      final imageBytes = await imageFile.readAsBytes();
      final fileName =
          DateTime.now().millisecondsSinceEpoch.toString() + '_detection.jpg';

      String imageUrl;
      try {
        imageUrl = await supabaseService.uploadFile(
          bucket: 'detection-images',
          path: supabaseUserId, // Use Supabase auth.uid(), not local UUID
          fileBytes: imageBytes,
          fileName: fileName,
        );
        debugPrint('✅ Image uploaded to: $imageUrl');
      } catch (e) {
        debugPrint('❌ Image upload failed: $e');
        await _db.incrementUploadAttempts(itemId);
        return;
      }

      // 2. Insert metadata to Supabase detection_results table
      try {
        final final_predicted_class = userCorrectedLabel ?? predictedClass;
        await supabaseService.insertDetectionResult(
          userId: supabaseUserId, // Use Supabase auth.uid() for RLS ✅
          plantType: plantType,
          predictedClass: final_predicted_class,
          confidenceScore: confidenceScore,
          userCorrectedLabel: userCorrectedLabel,
          imageUrl: imageUrl,
          detectedAt: DateTime.parse(detectedAt),
        );
        debugPrint('✅ Metadata inserted to detection_results');

        // 3. Mark as uploaded
        await _db.markUploadQueueItemAsUploaded(itemId);
        debugPrint('✅ Queue item $itemId marked as uploaded');
      } catch (e) {
        debugPrint('❌ Metadata insert failed: $e');
        await _db.incrementUploadAttempts(itemId);
      }
    } catch (e) {
      debugPrint('❌ Error uploading single item: $e');
    }
  }

  /// Add a new detection to the upload queue
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

      // Attempt upload immediately if online
      attemptPendingUploads();

      return id;
    } catch (e) {
      debugPrint('❌ Error adding detection to queue: $e');
      return null;
    }
  }

  /// Update corrected label for a queued detection
  Future<void> updateCorrectionForQueueItem(
      int queueId, String correctedLabel) async {
    try {
      await _db.updateCorrectedLabel(queueId, correctedLabel);
      debugPrint('✅ Corrected label updated for queue item: $queueId');

      // If item was already uploaded, don't re-upload; otherwise trigger upload
      final items = await _db.getPendingUploadQueueItems();
      final item =
          items.firstWhere((i) => i['id'] == queueId, orElse: () => {});
      if (item.isNotEmpty) {
        attemptPendingUploads();
      }
    } catch (e) {
      debugPrint('❌ Error updating correction: $e');
    }
  }

  /// Upgrade a guest session to authenticated (linkIdentity)
  /// Updates all upload queue items with the new authenticated user ID
  Future<void> upgradeGuestToAuthenticated({
    required String guestId,
    required String authenticatedUserId,
  }) async {
    try {
      debugPrint(
          '🔄 Upgrading guest $guestId to authenticated $authenticatedUserId');

      // Update all queue items with the new user ID
      await _db.updateUserIdForQueueItems(guestId, authenticatedUserId);

      debugPrint('✅ Upload queue items updated with new user ID');

      // Trigger uploads with the new authenticated user
      attemptPendingUploads();
    } catch (e) {
      debugPrint('❌ Error upgrading guest session: $e');
    }
  }

  void dispose() {
    _connectivitySubscription.cancel();
  }
}

final uploadQueueService = UploadQueueService();
