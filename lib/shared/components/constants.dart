import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:intl/intl.dart';
import '../../layout/cubit/cubit.dart';
import '../../models/user/user_model.dart';
import '../../modules/WelcomePlantie/welcome_screen.dart';
import '../network/local/cache_helper.dart';
import '../network/remote/dio.dart';
import 'components.dart';

/// Variables ///
String uId = '';

/// Methods ///
void signOut(context) {
  CacheHelper.removeData(
    key: 'uId',
  ).then((value) {
    if (value) {
      AppCubit.get(context).currentIndex = 0; // reset
      navigateAndFinish(
        context,
        WelcomeScreen(),
      );
    }
  });
}

bool isArabic(){
  return Intl.getCurrentLocale() == 'ar';
}

/// These Methods Importent for Facebook Authentecation ///
Future<LoginResult> loginWithFacebook(String nonce) async {
  return await FacebookAuth.instance.login(
    loginTracking: LoginTracking.limited,
    nonce: nonce,
  );
}

OAuthCredential getFacebookAuthCredential(
  AccessToken accessToken,
  String rawNonce,
) {
  if (Platform.isIOS && accessToken.type == AccessTokenType.limited) {
    final token = accessToken as LimitedToken;
    return OAuthCredential(
      providerId: 'facebook.com',
      signInMethod: 'oauth',
      idToken: token.tokenString,
      rawNonce: rawNonce,
    );
  }

  return FacebookAuthProvider.credential(accessToken.tokenString);
}

Future<void> handleFirestoreUser(Map<String, dynamic> userData) async {
  // Initialize Dio for image handling
  DioHelper.init();

  // Download and upload image to Firebase Storage
  final imageUrl = await DioHelper.downloadAndUploadImage(
    userData["picture"]["data"]["url"],
  );

  final userDoc = await FirebaseFirestore.instance
      .collection("users")
      .doc(userData["id"])
      .get();

  if (userDoc.exists && userDoc.data() != null) {
    // User exists in Firestore; set as current user
    CurrentUser.setUser(UserModel.fromJson(userDoc.data()!));
  } else {
    // Create new user in Firestore

    userCreate(
      name: userData["name"] ?? "",
      email: userData["email"] ?? "",
      uId: userData["id"],
      imageURL: imageUrl,
      isEmailVerified: true,
    );
  }
}

Future<void> userCreate({
  required String name,
  required String email,
  required String uId,
  imageURL = "",
  isEmailVerified = false,
}) async {
  UserModel model = UserModel(
    name: name,
    email: email,
    uId: uId,
    isEmailVerified: isEmailVerified,
    image: imageURL,
  );

  await FirebaseFirestore.instance
      .collection('users')
      .doc(uId)
      .set(model.toMap())
      .then((value) {
    CurrentUser.setUser(model);
  }).catchError((error) {});
}

String generateNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

/// End of These Methods ///
