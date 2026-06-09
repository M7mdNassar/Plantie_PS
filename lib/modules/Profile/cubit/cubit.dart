import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantie/shared/network/local/local_user_storage.dart';
import 'package:plantie/shared/network/remote/supabase_service.dart';
import '../../../models/user/user_model.dart';
import '../../../shared/services/supabase_auth_service.dart';
import 'states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(ProfileInitialState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  final ImagePicker picker = ImagePicker();

  File? pickedImageFile;
  bool isUploadingImage = false;
  bool isSavingFields = false;

  final Map<String, dynamic> _changedFields = {};
  UserModel? _originalUser;

  bool get hasFieldChanges => _changedFields.isNotEmpty;
  bool get hasImageChanges => pickedImageFile != null;
  bool get hasUnsavedChanges => hasFieldChanges || hasImageChanges;
  bool get isAnyLoading => isUploadingImage || isSavingFields;

  void initializeChangeTracking(UserModel? user) {
    _originalUser = user;
    _changedFields.clear();
    pickedImageFile = null;
    isUploadingImage = false;
    isSavingFields = false;
    emit(ProfileChangedState());
  }

  void trackFieldChange(String fieldName, String newValue) {
    final originalValue = _getOriginalFieldValue(fieldName);
    if (newValue.trim() != originalValue.trim()) {
      _changedFields[fieldName] = newValue.trim();
    } else {
      _changedFields.remove(fieldName);
    }
    emit(ProfileChangedState());
  }

  String _getOriginalFieldValue(String fieldName) {
    if (_originalUser == null) return '';
    switch (fieldName) {
      case 'name':
        return _originalUser!.name;
      case 'bio':
        return _originalUser!.bio ?? '';
      case 'country':
        return _originalUser!.country ?? '';
      case 'phone':
        return _originalUser!.phone ?? '';
      default:
        return '';
    }
  }

  Future<void> pickProfileImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 510,
        maxHeight: 510,
      );
      if (pickedFile != null) {
        pickedImageFile = File(pickedFile.path);
        emit(ProfileChangedState());
      }
    } catch (e) {
      emit(ProfileUpdateErrorState(e.toString()));
    }
  }

  void cancelImageChange() {
    pickedImageFile = null;
    emit(ProfileChangedState());
  }

  Future<void> updateAvatar() async {
    final user = CurrentUser.getUser();
    if (user == null || pickedImageFile == null) return;

    // Check online session
    final authService = SupabaseAuthService();
    final isReady = await authService.syncUserIfNeeded(user.id);
    if (!isReady) {
      emit(ProfileUpdateErrorState('offline_save_error'));
      return;
    }

    isUploadingImage = true;
    emit(ProfileChangedState());

    try {
      final fileExtension = pickedImageFile!.path.split('.').last;
      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final fileBytes = await pickedImageFile!.readAsBytes();

      // Use the authenticated user's ID as folder name (or local user ID, but must match RLS)
      final authUserId = authService.getCurrentAuthUserId() ?? user.id;
      final filePath = '$authUserId/$fileName';

      final imageUrl = await supabaseService.uploadFile(
        bucket: 'user-avatars',
        path: authUserId,  // folder name = auth user ID
        fileBytes: fileBytes,
        fileName: fileName,
      );

      await supabaseService.updateUserProfile(
        id: user.id,
        image: imageUrl,
      );

      final updatedData = await supabaseService.getUserData(user.id);
      if (updatedData != null) {
        CurrentUser.setUser(updatedData);
        await LocalUserStorage.saveUser(updatedData);
        _originalUser = updatedData;
        pickedImageFile = null;
      }

      isUploadingImage = false;
      emit(ProfileUpdateSuccessState(CurrentUser.getUser()));
      emit(ProfileChangedState());
    } catch (error) {
      isUploadingImage = false;
      emit(ProfileUpdateErrorState(error.toString()));
      emit(ProfileChangedState());
    }
  }

  Future<void> updateProfileFields() async {
    final user = CurrentUser.getUser();
    if (user == null) {
      emit(ProfileUpdateErrorState('User session not found.'));
      return;
    }

    if (_changedFields.isEmpty) {
      emit(ProfileUpdateSuccessState(user));
      return;
    }

    // Ensure online session
    final authService = SupabaseAuthService();
    final isReady = await authService.syncUserIfNeeded(user.id);
    if (!isReady) {
      emit(ProfileUpdateErrorState('offline_save_error'));
      return;
    }

    isSavingFields = true;
    emit(ProfileChangedState());

    try {
      await supabaseService.updateUserProfile(
        id: user.id,
        name: _changedFields['name'],
        phone: _changedFields['phone'],
        country: _changedFields['country'],
        bio: _changedFields['bio'],
      );

      final updatedData = await supabaseService.getUserData(user.id);
      if (updatedData != null) {
        CurrentUser.setUser(updatedData);
        await LocalUserStorage.saveUser(updatedData);
        _originalUser = updatedData;
        _changedFields.clear();
      }

      isSavingFields = false;
      emit(ProfileUpdateSuccessState(CurrentUser.getUser()));
      emit(ProfileChangedState());
    } catch (error) {
      isSavingFields = false;
      emit(ProfileUpdateErrorState(error.toString()));
      emit(ProfileChangedState());
    }
  }

  void resetChanges() {
    _changedFields.clear();
    pickedImageFile = null;
    isUploadingImage = false;
    isSavingFields = false;
    emit(ProfileChangedState());
  }
}