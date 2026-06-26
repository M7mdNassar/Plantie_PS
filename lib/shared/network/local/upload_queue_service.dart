import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../remote/supabase_auth_service.dart';
import 'history_db.dart';
import '../remote/supabase_service.dart';

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

  Future<void> addOfflineAction({
    required String type,
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    final id = await _db.insertOfflineAction({
      'action_type': type,
      'data': jsonEncode(data),
      'user_id': userId,
      'created_at': DateTime.now().toIso8601String(),
    });
    debugPrint('✅ Offline action queued: $type (ID: $id)');
    attemptPendingUploads();
  }

  Future<void> attemptPendingUploads() async {
    if (_isUploading) {
      debugPrint('⏳ Upload already in progress, skipping...');
      return;
    }

    _isUploading = true;

    try {
      debugPrint('🚀 Starting pending uploads...');

      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        debugPrint('📡 No internet connection, skipping uploads');
        _isUploading = false;
        return;
      }

      // 1. Upload pending detections
      final pendingDetections = await _db.getPendingUploadQueueItems();
      if (pendingDetections.isNotEmpty) {
        debugPrint('📦 Found ${pendingDetections.length} pending detections');
        for (final item in pendingDetections) {
          await _uploadSingleItem(item);
        }
      }

      // 2. Upload pending offline actions (posts/comments)
      final pendingActions = await _db.getPendingOfflineActions();
      if (pendingActions.isNotEmpty) {
        debugPrint('📦 Found ${pendingActions.length} pending offline actions');
        for (final action in pendingActions) {
          await _uploadOfflineAction(action);
        }
      }

      debugPrint('✅ Pending uploads completed');
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
        return;
      }

      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        debugPrint('⚠️ Image file not found: $imagePath, marking as uploaded');
        await _db.markUploadQueueItemAsUploaded(itemId);
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
        return;
      }

      try {
        final final_predicted_class = userCorrectedLabel ?? predictedClass;
        await supabaseService.insertDetectionResult(
          userId: supabaseUserId,
          plantType: plantType,
          predictedClass: final_predicted_class,
          confidenceScore: confidenceScore,
          userCorrectedLabel: userCorrectedLabel,
          imageUrl: imageUrl,
          detectedAt: DateTime.parse(detectedAt),
        );
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

      attemptPendingUploads();
      return id;
    } catch (e) {
      debugPrint('❌ Error adding detection to queue: $e');
      return null;
    }
  }

  Future<void> updateCorrectionForQueueItem(int queueId, String correctedLabel) async {
    try {
      await _db.updateCorrectedLabel(queueId, correctedLabel);
      debugPrint('✅ Corrected label updated for queue item: $queueId');

      final items = await _db.getPendingUploadQueueItems();
      final item = items.firstWhere((i) => i['id'] == queueId, orElse: () => {});
      if (item.isNotEmpty) {
        attemptPendingUploads();
      }
    } catch (e) {
      debugPrint('❌ Error updating correction: $e');
    }
  }

  Future<void> upgradeGuestToAuthenticated({
    required String guestId,
    required String authenticatedUserId,
  }) async {
    try {
      debugPrint('🔄 Upgrading guest $guestId to authenticated $authenticatedUserId');
      await _db.updateUserIdForQueueItems(guestId, authenticatedUserId);
      debugPrint('✅ Upload queue items updated with new user ID');
      attemptPendingUploads();
    } catch (e) {
      debugPrint('❌ Error upgrading guest session: $e');
    }
  }

  // ==================== OFFLINE ACTION UPLOAD (null-safe) ====================
  Future<void> _uploadOfflineAction(Map<String, dynamic> action) async {
    final id = action['id'] as int;
    final type = action['action_type'] as String? ?? ''; // ✅ null-safe
    final dataRaw = action['data'] as String?; // ✅ may be null
    if (dataRaw == null) {
      debugPrint('⚠️ Offline action $id has null data, marking failed');
      await _db.updateOfflineActionStatus(id, 'failed');
      return;
    }
    final Map<String, dynamic> data = jsonDecode(dataRaw);
    final userId = action['user_id'] as String? ?? ''; // ✅ null-safe

    // Ensure user has a Supabase session
    final authService = SupabaseAuthService();
    final ready = await authService.syncUserIfNeeded(userId);
    if (!ready) {
      debugPrint('⚠️ Cannot sync user for action $id, retrying later');
      await _db.updateOfflineActionStatus(id, 'pending', attempts: (action['attempts'] as int) + 1);
      return;
    }

    try {
      if (type == 'post') {
        await _uploadPost(data);
      } else if (type == 'comment') {
        await _uploadComment(data);
      } else {
        debugPrint('⚠️ Unknown action type: $type');
        await _db.updateOfflineActionStatus(id, 'failed');
        return;
      }
      await _db.updateOfflineActionStatus(id, 'done');
      debugPrint('✅ Offline action $id uploaded');
    } catch (e) {
      debugPrint('❌ Offline action $id failed: $e');
      final attempts = (action['attempts'] as int) + 1;
      final status = attempts >= 3 ? 'failed' : 'pending';
      await _db.updateOfflineActionStatus(id, status, attempts: attempts);
    }
  }

  Future<void> _uploadPost(Map<String, dynamic> data) async {
    final userId = data['user_id'] as String? ?? '';
    final text = data['text'] as String? ?? '';
    final images = data['images'] as List<dynamic>? ?? [];

    List<String> uploadedUrls = [];
    for (final imagePath in images) {
      final file = File(imagePath as String);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        final fileName = 'post_${DateTime.now().millisecondsSinceEpoch}.jpg';
        try {
          final url = await supabaseService.uploadFile(
            bucket: 'post-images',
            path: 'posts',
            fileBytes: bytes,
            fileName: fileName,
          );
          uploadedUrls.add(url);
        } catch (e) {
          debugPrint('❌ Failed to upload image: $e');
        }
      }
    }

    final response = await supabaseService.client
        .from('posts')
        .insert({'user_id': userId, 'text': text})
        .select('*, users(*)')
        .single();

    final postId = response['id'] as String;

    if (uploadedUrls.isNotEmpty) {
      final imageInserts = uploadedUrls.map((url) => {
        'post_id': postId,
        'image_url': url,
        'created_at': DateTime.now().toIso8601String(),
      }).toList();
      await supabaseService.client.from('post_images').insert(imageInserts);
    }
  }

  Future<void> _uploadComment(Map<String, dynamic> data) async {
    final postId = data['post_id'] as String? ?? '';
    final userId = data['user_id'] as String? ?? '';
    final text = data['text'] as String? ?? '';
    await supabaseService.client
        .from('comments')
        .insert({'post_id': postId, 'user_id': userId, 'text': text});
  }

  void dispose() {
    _connectivitySubscription.cancel();
  }
}

final uploadQueueService = UploadQueueService();