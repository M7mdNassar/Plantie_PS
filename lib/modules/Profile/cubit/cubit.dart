import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantie/modules/Profile/cubit/states.dart';
import '../../../models/user/user_model.dart';


class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(ProfileInitialState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  final picker = ImagePicker();
  File? profileImage;

  Future<void> pickProfileImage() async {
    emit(ProfileImagePickLoadingState());
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        profileImage = File(pickedFile.path);
        emit(ProfileImagePickSuccessState());
      } else {
        emit(ProfileImagePickCancelledState());
      }
    } catch (error) {
      emit(ProfileImagePickErrorState(error.toString()));
    }
  }

  Future<void> updateUserProfile({
    required String name,
    required String bio,
    required String country,
    required String phone,
  }) async {
    emit(ProfileUpdateLoadingState());

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userData = {
          'name': name,
          'bio': bio,
          'country': country,
          'phone': phone,
          'profileImage': profileImage != null ? profileImage!.path : null,
        };

        // Update Firebase
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(userData);

        // Fetch updated user data
        final updatedUserData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        final data = updatedUserData.data();
        if (data != null) {
          CurrentUser.setUser(UserModel.fromJson(data));
        }
        emit(ProfileUpdateSuccessState(CurrentUser.getUser()));
      } else {
        emit(ProfileUpdateErrorState('User not authenticated'));
      }
    } catch (error) {
      emit(ProfileUpdateErrorState(error.toString()));
    }
  }

}
