import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/user/user_model.dart';
import '../../../shared/network/remote/dio.dart';
import 'states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(ProfileInitialState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  final picker = ImagePicker();
  File? image;
  var flagButtons = false;

  Future<void> pickProfileImage(BuildContext context) async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        image = File(pickedFile.path);
        emit(ProfileImagePickSuccessState());
        updateUserImagePickidButtons();

      } else {
        emit(ProfileImagePickCancelledState());
      }
    } catch (error) {
      emit(ProfileImagePickErrorState(error.toString()));
    }
  }

  void uploadProfileImage() async {
    emit(ProfileImageUpdateLoadingState());
    try {
      var imageBytes = await image!.readAsBytes();

      String uploadedImageUrl =
      await DioHelper.uploadImageToFirebase(imageBytes, "profiles/");

      final user = CurrentUser.user!;
      await updateUserProfile(
        name: user.name,
        phone: user.phone ?? "",
        bio: user.bio ?? "",
        image: uploadedImageUrl,
        country: user.country ?? "",
      );

      emit(ProfileImageUpdateSuccessState());
      updateUserImagePickidButtons();

    } catch (e) {
      image = null; // Clear the image if upload fails
      emit(ProfileImageUpdateErrorState("Failed to upload image: $e"));
    }
  }



  Future<void> updateUserProfile({
    required String name,
    required String bio,
    required String country,
    required String phone,
    String? image,
  }) async {

    if (image == null){
      emit(ProfileUpdateLoadingState());
    }

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userData = {
          'name': name,
          'bio': bio,
          'country': country,
          'phone': phone,
          'image': image ?? CurrentUser.user!.image,
        };

        // Update Firebase
        await FirebaseFirestore.instance
            .collection('users')
            .doc(CurrentUser.user!.uId)
            .update(userData);

        // Fetch updated user data
        final updatedUserData = await FirebaseFirestore.instance
            .collection('users')
            .doc(CurrentUser.user!.uId)
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

  void setImageToNull() {
    image = null;
    emit(ProfileImageClearedState());
  }


  void updateUserImagePickidButtons() {
    flagButtons = !flagButtons;
    emit(ProfileImageButtonsUpdateState());
  }

}
