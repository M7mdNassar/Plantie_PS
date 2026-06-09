import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/user/user_model.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  late final SupabaseClient _client;

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  SupabaseClient get client => _client;

  void initialize(SupabaseClient client) {
    _client = client;
  }

  // ==================== AUTH METHODS ====================

  /// Get current authenticated user
  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  /// Get current session
  Session? getCurrentSession() {
    return _client.auth.currentSession;
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _client.auth.currentUser != null;
  }

  /// Sign out user
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // ==================== PHONE OTP AUTH METHODS ====================
  // DEPRECATED: Removed as part of auth overhaul
  // - sendPhoneOtp() - no longer used
  // - verifyPhoneOtp() - no longer used
  // - signInAnonymously() - still available for background sync if needed

  // ==================== USER METHODS ====================

  /// Get user data from users table
  Future<UserModel?> getUserData(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .single()
          .timeout(
            const Duration(seconds: 10),
          );

      return UserModel.fromJson(response);
    } catch (e) {
      debugPrint('Error fetching user: $e');
      return null;
    }
  }

  /// Create user in users table
  Future<void> createUser({
    required String id,
    required String name,
    String? phone,
    String? image,
  }) async {
    try {
      final userModel = UserModel(
        id: id,
        name: name,
        phone: phone,
        image: image,
      );

      await _client.from('users').insert(userModel.toMap());
    } catch (e) {
      debugPrint('Error creating user: $e');
      rethrow;
    }
  }

  /// Update user profile
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

      // 1. Try a standard update, returning the updated rows
      final response = await _client.from('users').update(updates).eq('id', id).select();

      // 2. If response is empty, the user row doesn't exist (offline registration)
      if (response.isEmpty) {
        final localUser = CurrentUser.getUser();
        if (localUser != null) {
          debugPrint('ℹ️ User row not found in Supabase. Creating row from local data...');
          
          // Full insert to create the user
          final dataToInsert = localUser.toMap();
          dataToInsert.removeWhere((key, value) => value == null);
          await _client.from('users').insert(dataToInsert);
          
          // Retry the specific update if we had specific fields to change
          await _client.from('users').update(updates).eq('id', id);
          debugPrint('✅ User row created and updated successfully');
        } else {
          throw Exception('User row does not exist in Supabase and no local user found to sync.');
        }
      }
    } catch (e) {
      debugPrint('Error updating user: $e');
      rethrow;
    }
  }

  // ==================== STORAGE METHODS ====================

  /// Upload file to storage
  Future<String> uploadFile({
    required String bucket,
    required String path,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    try {
      final fullPath = '$path/$fileName';
      await _client.storage.from(bucket).uploadBinary(
            fullPath,
            fileBytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Return public URL
      final publicUrl = _client.storage.from(bucket).getPublicUrl(fullPath);
      return publicUrl;
    } catch (e) {
      debugPrint('Error uploading file: $e');
      rethrow;
    }
  }

  /// Delete file from storage
  Future<void> deleteFile({
    required String bucket,
    required String path,
  }) async {
    try {
      await _client.storage.from(bucket).remove([path]);
    } catch (e) {
      debugPrint('Error deleting file: $e');
      rethrow;
    }
  }

  /// Get public URL for a file
  String getPublicUrl({
    required String bucket,
    required String path,
  }) {
    return _client.storage.from(bucket).getPublicUrl(path);
  }

  // ==================== DETECTION RESULTS METHODS ====================

  /// Insert a detection result to the cloud detection_results table
  Future<void> insertDetectionResult({
    required String userId,
    required String plantType,
    required String predictedClass,
    required double confidenceScore,
    String? userCorrectedLabel,
    required String imageUrl,
    required DateTime detectedAt,
  }) async {
    try {
      await _client.from('detection_results').insert({
        'user_id': userId,
        'plant_type': plantType,
        'predicted_class': predictedClass,
        'confidence_score': confidenceScore,
        'user_corrected_label': userCorrectedLabel,
        'image_url': imageUrl,
        'detected_at': detectedAt.toIso8601String(),
      });
      debugPrint('✅ Detection result inserted successfully');
    } catch (e) {
      debugPrint('❌ Error inserting detection result: $e');
      rethrow;
    }
  }

  // ==================== STREAM METHODS ====================

  /// Listen to auth state changes
  Stream<AuthState> authStateChanges() {
    return _client.auth.onAuthStateChange;
  }

  /// Listen to user data changes
  Stream<List<Map<String, dynamic>>> userDataStream(String uid) {
    return _client.from('users').stream(primaryKey: ['id']).eq('uid', uid);
  }
}

// Global instance
final supabaseService = SupabaseService();
