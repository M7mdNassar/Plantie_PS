import 'dart:io';
import '../network/local/local_user_storage.dart';
import '../network/remote/dio.dart';
import '../network/remote/supabase_service.dart';
import '../../../models/user/user_model.dart';

class SupabaseAuthService {
  static final SupabaseAuthService _instance = SupabaseAuthService._internal();
  factory SupabaseAuthService() => _instance;
  SupabaseAuthService._internal();

  // Prevent concurrent sync for the same user ID
  final Set<String> _syncInProgress = {};

  /// Ensures the current user has a linked Supabase Auth session and exists in `public.users`.
  /// Returns `true` if the user is ready for online operations, `false` otherwise (offline).
  /// This method is idempotent – safe to call multiple times.
  Future<bool> syncUserIfNeeded(String localUserId) async {
    // 1. Fast connectivity check (DNS lookup)
    if (!await isConnectedFast()) {
      debugPrint('⚠️ [Auth] No internet, skipping sync for $localUserId');
      return false;
    }

    // 2. Prevent concurrent sync for the same user
    if (_syncInProgress.contains(localUserId)) {
      debugPrint('⏳ [Auth] Sync already in progress for $localUserId, waiting...');
      for (int i = 0; i < 50; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (!_syncInProgress.contains(localUserId)) break;
      }
      if (_syncInProgress.contains(localUserId)) {
        debugPrint('❌ [Auth] Timeout waiting for sync');
        return false;
      }
    }

    _syncInProgress.add(localUserId);
    try {
      // 3. Ensure a Supabase Auth session exists (anonymous)
      final session = supabaseService.client.auth.currentSession;
      if (session == null) {
        debugPrint('🔐 [Auth] No session, creating anonymous session...');
        await supabaseService.client.auth.signInAnonymously();
        debugPrint('✅ [Auth] Anonymous session created');
      }

      final authUser = supabaseService.client.auth.currentUser!;
      final authUserId = authUser.id;

      // 4. Update or insert into `public.users` with upsert (prevents duplicates)
      final localUser = CurrentUser.user;
      if (localUser == null) {
        debugPrint('❌ [Auth] CurrentUser not loaded');
        return false;
      }

      final userData = localUser.toJson();
      userData['auth_user_id'] = authUserId;   // link auth ID

      final response = await supabaseService.client
          .from('users')
          .upsert(userData, onConflict: 'id')
          .select()
          .maybeSingle();

      if (response != null) {
        final updatedUser = UserModel.fromJson(response);
        await LocalUserStorage.saveUser(updatedUser);
        CurrentUser.setUser(updatedUser);
        debugPrint('✅ [Auth] User synced to Supabase (auth_id: $authUserId)');
      } else {
        debugPrint('⚠️ [Auth] Upsert returned no data');
      }

      return true;
    } catch (e) {
      debugPrint('❌ [Auth] Sync error: $e');
      return false;
    } finally {
      _syncInProgress.remove(localUserId);
    }
  }

  /// Returns the current authenticated Supabase user ID, or null if offline/no session.
  String? getCurrentAuthUserId() {
    return supabaseService.client.auth.currentUser?.id;
  }

  /// Fast connectivity test (DNS lookup with 2‑second timeout)
  Future<bool> isConnectedFast() async {
    try {
      final result = await InternetAddress.lookup('supabase.co')
          .timeout(const Duration(seconds: 2));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}