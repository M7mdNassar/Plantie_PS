import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/user/user_model.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  late final SupabaseClient _client;

  factory SupabaseService() => _instance;
  SupabaseService._internal();

  SupabaseClient get client => _client;

  void initialize(SupabaseClient client) {
    _client = client;
  }

  // ==================== AUTH METHODS ====================

  User? getCurrentUser() => _client.auth.currentUser;
  Session? getCurrentSession() => _client.auth.currentSession;
  bool isAuthenticated() => _client.auth.currentUser != null;
  Future<void> signOut() async => await _client.auth.signOut();

  // ==================== USER METHODS ====================

  Future<UserModel?> getUserData(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .single()
          .timeout(const Duration(seconds: 10));
      return UserModel.fromJson(response);
    } catch (e) {
      debugPrint('Error fetching user: $e');
      return null;
    }
  }

  Future<void> createUser({required String id, required String name, String? phone, String? image}) async {
    try {
      final userModel = UserModel(id: id, name: name, phone: phone, image: image);
      await _client.from('users').insert(userModel.toMap());
    } catch (e) {
      debugPrint('Error creating user: $e');
      rethrow;
    }
  }

  Future<void> updateUserProfile({
    required String id,
    String? name,
    String? phone,
    String? country,
    String? image,
    String? bio,
  }) async {
    try {
      final updates = {
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (country != null) 'country': country,
        if (image != null) 'image': image,
        if (bio != null) 'bio': bio,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _client.from('users').update(updates).eq('id', id).select();
      if (response.isEmpty) {
        final localUser = CurrentUser.getUser();
        if (localUser != null) {
          debugPrint('ℹ️ User row not found in Supabase. Creating row from local data...');
          final dataToInsert = localUser.toMap();
          dataToInsert.removeWhere((key, value) => value == null);
          await _client.from('users').insert(dataToInsert);
          await _client.from('users').update(updates).eq('id', id);
          debugPrint('✅ User row created and updated successfully');
        } else {
          throw Exception('User row does not exist and no local user found.');
        }
      }
    } catch (e) {
      debugPrint('Error updating user: $e');
      rethrow;
    }
  }

  // ==================== FOLLOWERS ====================

  Future<bool> isFollowing(String followerId, String followingId) async {
    try {
      final response = await _client
          .from('followers')
          .select('id')
          .eq('follower_id', followerId)
          .eq('following_id', followingId)
          .maybeSingle();
      return response != null;
    } catch (e) {
      debugPrint('Error checking follow: $e');
      return false;
    }
  }

  Future<void> followUser(String followerId, String followingId) async {
    await _client.from('followers').insert({
      'follower_id': followerId,
      'following_id': followingId,
    });
  }

  Future<void> unfollowUser(String followerId, String followingId) async {
    await _client
        .from('followers')
        .delete()
        .eq('follower_id', followerId)
        .eq('following_id', followingId);
  }

  // ✅ SIMPLE FIX: fetch all and return length (no 'count' parameter)
  Future<int> getFollowersCount(String userId) async {
    try {
      final response = await _client
          .from('followers')
          .select('id')
          .eq('following_id', userId);
      return response.length;
    } catch (e) {
      debugPrint('Error getting followers count: $e');
      return 0;
    }
  }

  Future<int> getFollowingCount(String userId) async {
    try {
      final response = await _client
          .from('followers')
          .select('id')
          .eq('follower_id', userId);
      return response.length;
    } catch (e) {
      debugPrint('Error getting following count: $e');
      return 0;
    }
  }

  // ==================== USER SEARCH ====================

  Future<List<UserModel>> searchUsers(String query, {int limit = 20}) async {
    if (query.trim().isEmpty) return [];
    try {
      final response = await _client
          .from('users')
          .select()
          .ilike('name', '%$query%')
          .limit(limit);
      return response.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error searching users: $e');
      return [];
    }
  }

  // ==================== STORAGE ====================

  Future<String> uploadFile({
    required String bucket,
    required String path,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    final fullPath = '$path/$fileName';
    await _client.storage.from(bucket).uploadBinary(
      fullPath,
      fileBytes,
      fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
    );
    return _client.storage.from(bucket).getPublicUrl(fullPath);
  }

  Future<void> deleteFile({required String bucket, required String path}) async {
    await _client.storage.from(bucket).remove([path]);
  }

  String getPublicUrl({required String bucket, required String path}) {
    return _client.storage.from(bucket).getPublicUrl(path);
  }

  // ==================== DETECTION ====================

  Future<void> insertDetectionResult({
    required String userId,
    required String plantType,
    required String predictedClass,
    required double confidenceScore,
    String? userCorrectedLabel,
    required String imageUrl,
    required DateTime detectedAt,
  }) async {
    await _client.from('detection_results').insert({
      'user_id': userId,
      'plant_type': plantType,
      'predicted_class': predictedClass,
      'confidence_score': confidenceScore,
      'user_corrected_label': userCorrectedLabel,
      'image_url': imageUrl,
      'detected_at': detectedAt.toIso8601String(),
    });
  }

  // ==================== STREAMS ====================

  Stream<AuthState> authStateChanges() => _client.auth.onAuthStateChange;
  Stream<List<Map<String, dynamic>>> userDataStream(String uid) =>
      _client.from('users').stream(primaryKey: ['id']).eq('uid', uid);
}

final supabaseService = SupabaseService();