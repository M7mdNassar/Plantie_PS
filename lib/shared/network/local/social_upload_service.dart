import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../remote/supabase_auth_service.dart';
import 'history_db.dart';
import '../remote/supabase_service.dart';

class SocialUploadService {
  static final SocialUploadService _instance = SocialUploadService._internal();

  factory SocialUploadService() => _instance;

  SocialUploadService._internal() {
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
          debugPrint('📡 Social upload: connection lost');
        } else {
          debugPrint('📡 Social upload: connection restored, attempting uploads...');
          attemptPendingUploads();
        }
      },
    );
  }

  Future<void> _updatePendingCount() async {
    final count = await _db.getPendingOfflineActionsCount();
    pendingCount.value = count;
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
    await _updatePendingCount();
    attemptPendingUploads();
  }

  Future<void> attemptPendingUploads() async {
    if (_isUploading) {
      debugPrint('⏳ Social upload already in progress, skipping...');
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

      final pendingActions = await _db.getPendingOfflineActions();
      if (pendingActions.isNotEmpty) {
        debugPrint('📦 Found ${pendingActions.length} pending offline actions');
        for (final action in pendingActions) {
          await _uploadOfflineAction(action);
        }
      }

      debugPrint('✅ Social uploads completed');
      await _updatePendingCount();
    } catch (e) {
      debugPrint('❌ Error in attemptPendingUploads: $e');
    } finally {
      _isUploading = false;
    }
  }

  Future<void> _uploadOfflineAction(Map<String, dynamic> action) async {
    final id = action['id'] as int;
    final type = action['action_type'] as String? ?? '';
    final dataRaw = action['data'] as String?;
    if (dataRaw == null) {
      debugPrint('⚠️ Offline action $id has null data, marking failed');
      await _db.updateOfflineActionStatus(id, 'failed');
      await _updatePendingCount();
      return;
    }
    final Map<String, dynamic> data = jsonDecode(dataRaw);
    final userId = action['user_id'] as String? ?? '';

    final authService = SupabaseAuthService();
    final ready = await authService.syncUserIfNeeded(userId);
    if (!ready) {
      debugPrint('⚠️ Cannot sync user for action $id, retrying later');
      await _db.updateOfflineActionStatus(id, 'pending', attempts: (action['attempts'] as int) + 1);
      await _updatePendingCount();
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
        await _updatePendingCount();
        return;
      }
      await _db.updateOfflineActionStatus(id, 'done');
      debugPrint('✅ Offline action $id uploaded');
      await _updatePendingCount();
    } catch (e) {
      debugPrint('❌ Offline action $id failed: $e');
      final attempts = (action['attempts'] as int) + 1;
      final status = attempts >= 3 ? 'failed' : 'pending';
      await _db.updateOfflineActionStatus(id, status, attempts: attempts);
      await _updatePendingCount();
    }
  }

  Future<void> _uploadPost(Map<String, dynamic> data) async {
    final userId = data['user_id'] as String? ?? '';
    final text = data['text'] as String? ?? '';
    final images = data['images'] as List<dynamic>? ?? [];
    final pendingId = data['pending_id'] as String?;

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

    // If we have a pending ID, we could update local state here.
    // But we'll handle it via real-time subscription.
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
    pendingCount.dispose();
  }
}

final socialUploadService = SocialUploadService();