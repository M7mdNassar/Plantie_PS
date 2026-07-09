import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/user/user_model.dart';
import '../../../shared/network/local/local_user_storage.dart';
import '../../../shared/network/remote/supabase_auth_service.dart';
import '../../../shared/network/local/device_id_service.dart';
import 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(RegistrationInitial());

  Future<void> register(String name) async {
    if (state is RegistrationLoading) return;
    emit(RegistrationLoading());

    try {
      final trimmed = name.trim();
      if (trimmed.length < 2) {
        emit(RegistrationError('Name must be at least 2 characters'));
        return;
      }

      // ✅ Use persistent device ID as the user ID
      final deviceId = await DeviceIdService.getDeviceId();

      // Check if user already exists locally with this device ID
      final existingUser = await LocalUserStorage.loadUserById(deviceId);
      if (existingUser != null) {
        // Update the name if changed
        final updatedUser = existingUser.copyWith(name: trimmed);
        await LocalUserStorage.saveUser(updatedUser);
        CurrentUser.setUser(updatedUser);
        emit(RegistrationSuccess(updatedUser));
        _syncToSupabaseInBackground(updatedUser);
        return;
      }

      // Create new user with the device ID
      final user = UserModel(id: deviceId, name: trimmed);
      await LocalUserStorage.saveUser(user);
      CurrentUser.setUser(user);

      debugPrint('✅ User registered locally with device ID: $deviceId');
      emit(RegistrationSuccess(user));

      // Background sync to Supabase
      _syncToSupabaseInBackground(user);
    } catch (e) {
      debugPrint('❌ Registration error: $e');
      emit(RegistrationError(e.toString()));
    }
  }

  void _syncToSupabaseInBackground(UserModel user) {
    Future.microtask(() async {
      try {
        final authService = SupabaseAuthService();
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

  Future<void> refreshCurrentUserFromSupabase() async {
    final localUser = CurrentUser.user;
    if (localUser.id.isEmpty) return;
    try {
      final authService = SupabaseAuthService();
      final success = await authService.syncUserIfNeeded(localUser.id);
      if (success) {
        emit(RegistrationSuccess(CurrentUser.user));
        debugPrint('✅ User refreshed from Supabase');
      }
    } catch (e) {
      debugPrint('Could not refresh user from Supabase: $e');
    }
  }
}