import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:plantie/shared/network/remote/supabase_service.dart';
import 'package:plantie/shared/network/local/local_user_storage.dart';
import '../../layout/cubit/cubit.dart';
import '../../modules/Registration/registration_screen.dart';
import '../../models/user/user_model.dart';
import 'components.dart';

/// Variables ///
// Auth state is now managed by Supabase, no need for local uId variable

/// Methods ///
Future<void> signOut(context) async {
  try {
    // Clear local storage first
    await LocalUserStorage.clearAll();
    // Clear in-memory user
    CurrentUser.clearUser();
    // Sign out from Supabase
    await supabaseService.signOut();
    // Use microtask to safely handle navigation after sign-out
    Future.microtask(() {
      if (context.mounted) {
        try {
          AppCubit.get(context).currentIndex = 0; // reset
          navigateAndFinish(
            context,
            const RegistrationScreen(),
          );
        } catch (e) {
          debugPrint('⚠️ Navigation error after sign-out: $e');
        }
      }
    });
  } catch (error) {
    debugPrint('❌ Error signing out: $error');
  }
}

bool isArabic() {
  return Intl.getCurrentLocale() == 'ar';
}
