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
    // Clear local user data but NOT the device ID
    await LocalUserStorage.clearAll(); // This should only clear user data
    // Ensure we don't clear the device_id key
    CurrentUser.clearUser();
    await supabaseService.signOut();
    Future.microtask(() {
      if (context.mounted) {
        try {
          AppCubit.get(context).currentIndex = 0;
          navigateAndFinish(context, const RegistrationScreen());
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
