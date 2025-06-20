import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plantie/modules/Register/cubit/states.dart';
import '../../../models/user/user_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
  }) {
    emit(RegisterLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      value.user!.sendEmailVerification().then((_) {
        emit(RegisterSuccessState());
        showToast(
          text: "Verification email sent. Please check your inbox.",
          state: ToastStates.success,
        );
        userCreate(
          name: name,
          email: email,
          uId: value.user!.uid,
        );
        emit(CreateUserSuccessState(value.user!.uid));
      }).catchError((error) {
        emit(RegisterErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(RegisterErrorState(error.toString()));
    });
  }

  Future<void> signInWithGoogle() async {
    try {
      // Begin interactive sign-in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        // User canceled the sign-in process
        emit(RegisterCanceldState("Google sign-in was canceled."));
        return;
      }

      // Obtain auth details from the request
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Create a new credential for the user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Sign in with the obtained credential
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCredential.user;

      if (user == null) {
        emit(RegisterErrorState("Failed to retrieve user details."));
        return;
      }
      emit(RegisterLoadingState());

      // Check if user exists in Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        // Set current user data
        CurrentUser.setUser(UserModel.fromJson(userDoc.data()!));
        emit(CreateUserSuccessState(user.uid));
      } else {
        // Handle case where user data doesn't exist in Firestore
        userCreate(
          name: user.displayName!,
          email: user.email!,
          uId: user.uid,
          imageURL: user.photoURL,
          isEmailVerified: user.emailVerified,
        ).then((value) {
          emit(CreateUserSuccessState(user.uid));
        }).catchError((error) {
          emit(CreateUserErrorState(error.toString()));
        });
      }
    } catch (error) {
      emit(RegisterErrorState(error.toString()));
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      // Step 1: Generate nonce for security
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Step 2: Trigger Facebook login
      final loginResult = await loginWithFacebook(nonce);

      if (loginResult.accessToken == null) {
        throw Exception("Access token is null: ${loginResult.message}");
      }

      // Step 3: Get Firebase credential based on the platform and token type
      final facebookAuthCredential = getFacebookAuthCredential(
        loginResult.accessToken!,
        rawNonce,
      );

      emit(RegisterLoadingState());

      // Step 4: Sign in to Firebase with the credential
      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      // Step 5: Fetch Facebook user data
      final userData = await FacebookAuth.instance.getUserData();

      // Step 6: Handle user data in Firestore
      await handleFirestoreUser(userData);

      emit(CreateUserSuccessState(userData["id"]));
    } catch (error) {
      emit(RegisterErrorState(error.toString()));
    }
  }

  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;

    emit(RegisterChangePasswordVisibilityState());
  }
}
