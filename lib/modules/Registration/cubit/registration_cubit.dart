import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../models/user/user_model.dart';
import '../../../shared/network/local/local_user_storage.dart';
import '../../../shared/network/remote/supabase_auth_service.dart';
import 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(RegistrationInitial());

  /// Register a new user locally (OFFLINE-FIRST)
  /// Then sync to Supabase in background when online.
  Future<void> register(String name) async {
    if (state is RegistrationLoading) return;

    emit(RegistrationLoading());

    try {
      final trimmed = name.trim();
      if (trimmed.length < 2) {
        emit(RegistrationError('Name must be at least 2 characters'));
        return;
      }

      // Generate UUID locally
      final uuid = const Uuid().v4();

      // Create user model (minimal, other fields will be added later)
      final user = UserModel(id: uuid, name: trimmed);

      // Save full user to local storage
      await LocalUserStorage.saveUser(user);

      // Set globally
      CurrentUser.setUser(user);

      debugPrint('✅ User registered locally: $uuid - $trimmed');

      emit(RegistrationSuccess(user));

      // Non-blocking background sync to Supabase (using the new unified method)
      _syncToSupabaseInBackground(user);
    } catch (e) {
      debugPrint('❌ Registration error: $e');
      emit(RegistrationError(e.toString()));
    }
  }

  /// Sync user to Supabase in background (non-blocking)
  /// Uses the central syncUserIfNeeded to ensure an Auth session and upsert the user.
  void _syncToSupabaseInBackground(UserModel user) {
    Future.microtask(() async {
      try {
        final authService = SupabaseAuthService();
        // syncUserIfNeeded will:
        // - Create anonymous Auth session if offline/not exists
        // - Upsert the user into public.users (with auth_user_id)
        // - Update local storage with latest data
        final success = await authService.syncUserIfNeeded(user.id);
        if (success) {
          debugPrint('✅ User synced to Supabase after registration');
        } else {
          debugPrint('⚠️ Background sync failed (offline or error)');
        }
      } catch (e) {
        debugPrint('⚠️ Background sync error: $e');
      }
    });
  }

  /// Refresh current user from Supabase (called on app start or when needed)
  /// Now delegates to syncUserIfNeeded to ensure the user is fully up‑to‑date.
  Future<void> refreshCurrentUserFromSupabase() async {
    final localUser = CurrentUser.user;
    if (localUser.id.isEmpty) return;

    try {
      final authService = SupabaseAuthService();
      final success = await authService.syncUserIfNeeded(localUser.id);
      if (success) {
        // syncUserIfNeeded already updated CurrentUser and local storage
        // We can emit a success state to refresh UI if needed.
        emit(RegistrationSuccess(CurrentUser.user));
        debugPrint('✅ User refreshed from Supabase');
      }
    } catch (e) {
      debugPrint('Could not refresh user from Supabase: $e');
    }
  }
}