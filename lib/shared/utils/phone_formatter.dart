/// Phone number formatting utilities for Supabase OTP
class PhoneFormatter {
  /// Formats phone number to E.164 format required by Supabase
  /// Example: +1 (555) 123-4567 -> +15551234567
  static String formatToE164({
    required String countryCode,
    required String phoneNumber,
  }) {
    // Remove all non-digit characters
    String digits = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // If country code already has +, remove it temporarily
    String code = countryCode.replaceAll('+', '');

    // Combine: +{countryCode}{digits}
    return '+$code$digits';
  }

  /// Validates if phone number is in E.164 format
  static bool isValidE164(String phone) {
    // E.164 format: + followed by 1-15 digits
    return RegExp(r'^\+[1-9]\d{1,14}$').hasMatch(phone);
  }

  /// Extracts clean OTP code (only digits, no spaces)
  static String cleanOtpCode(String otp) {
    return otp.replaceAll(RegExp(r'\D'), '');
  }
}
