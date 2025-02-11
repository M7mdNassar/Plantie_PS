// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(temp) => "Feels like ${temp}°C";

  static String m1(emoji, name) => "${emoji} ${name} Fertilizer";

  static String m2(unit) => "Land Area (${unit}):";

  static String m3(error) => "Error: ${error}";

  static String m4(type) => "Type: ${type}";

  static String m5(calculationContext) =>
      "Required Fertilizers (${calculationContext}):";

  static String m6(treatment) => "${treatment}";

  static String m7(age) =>
      "Note: Calculations include age factor for ${age} year old trees";

  static String m8(error) => "Update failed: ${error}";

  static String m9(error) => "Error sending verification: ${error}";

  static String m10(error) => "Error fetching weather: ${error}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "acre": MessageLookupByLibrary.simpleMessage("Acre"),
    "areaNote": MessageLookupByLibrary.simpleMessage(
      "Note: 1 Dunam = 1000 m² (10,000 sq ft)",
    ),
    "bio": MessageLookupByLibrary.simpleMessage("Bio"),
    "bioRequired": MessageLookupByLibrary.simpleMessage(
      "Bio must not be empty",
    ),
    "calculateFertilizer": MessageLookupByLibrary.simpleMessage(
      "Calculate Fertilizer",
    ),
    "calculateRequirements": MessageLookupByLibrary.simpleMessage(
      "Calculate Requirements",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "choosePlant": MessageLookupByLibrary.simpleMessage("Choose a Plant"),
    "community": MessageLookupByLibrary.simpleMessage("Community"),
    "confirmDelete": MessageLookupByLibrary.simpleMessage("Confirm Delete"),
    "confirmLogout": MessageLookupByLibrary.simpleMessage("Confirm Logout"),
    "country": MessageLookupByLibrary.simpleMessage("Country"),
    "countryRequired": MessageLookupByLibrary.simpleMessage(
      "Country must not be empty",
    ),
    "creat_account2": MessageLookupByLibrary.simpleMessage("Create Account"),
    "create_account": MessageLookupByLibrary.simpleMessage("Create account?"),
    "create_account3": MessageLookupByLibrary.simpleMessage(
      "Complete your information to get started!",
    ),
    "current_weather": MessageLookupByLibrary.simpleMessage("Current Weather"),
    "darkMode": MessageLookupByLibrary.simpleMessage("Dark Mode"),
    "date": MessageLookupByLibrary.simpleMessage("Date"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this item?",
    ),
    "description": MessageLookupByLibrary.simpleMessage("Description"),
    "detection": MessageLookupByLibrary.simpleMessage("Detection"),
    "detectionResult": MessageLookupByLibrary.simpleMessage("Detection Result"),
    "detectionResults": MessageLookupByLibrary.simpleMessage(
      "Detection Results",
    ),
    "diseases": MessageLookupByLibrary.simpleMessage("Diseases"),
    "dunam": MessageLookupByLibrary.simpleMessage("Dunam"),
    "editProfile": MessageLookupByLibrary.simpleMessage("Edit Profile"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "email_address": MessageLookupByLibrary.simpleMessage("Email Address"),
    "email_valid": MessageLookupByLibrary.simpleMessage(
      "please enter a valid email",
    ),
    "enableGPS": MessageLookupByLibrary.simpleMessage("Enable GPS"),
    "enableLocation": MessageLookupByLibrary.simpleMessage("Enable Location"),
    "english": MessageLookupByLibrary.simpleMessage("English"),
    "enter_email": MessageLookupByLibrary.simpleMessage(
      "Please enter your email address",
    ),
    "enter_name": MessageLookupByLibrary.simpleMessage(
      "please enter a user name",
    ),
    "enter_password": MessageLookupByLibrary.simpleMessage(
      "Password is too short",
    ),
    "feelsLike": m0,
    "feels_like": MessageLookupByLibrary.simpleMessage("Feels Like"),
    "fertilizerCalculator": m1,
    "fetchingWeather": MessageLookupByLibrary.simpleMessage(
      "Fetching weather...",
    ),
    "forget_password": MessageLookupByLibrary.simpleMessage("Forget Password?"),
    "getWeather": MessageLookupByLibrary.simpleMessage("Get Weather"),
    "gpsDisabled": MessageLookupByLibrary.simpleMessage(
      "Location services disabled. Please enable GPS.",
    ),
    "have_account": MessageLookupByLibrary.simpleMessage(
      "Already have an account? ",
    ),
    "history": MessageLookupByLibrary.simpleMessage("History"),
    "historyPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Your plant health scans will appear here",
    ),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "humidity": MessageLookupByLibrary.simpleMessage("Humidity"),
    "landArea": m2,
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "launchError": MessageLookupByLibrary.simpleMessage(
      "Could not launch maps",
    ),
    "locationError": m3,
    "locationRequired": MessageLookupByLibrary.simpleMessage(
      "Location permission required",
    ),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "login_button": MessageLookupByLibrary.simpleMessage("Login"),
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "logoutMessage": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to log out?",
    ),
    "mop": MessageLookupByLibrary.simpleMessage("MOP"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "nameRequired": MessageLookupByLibrary.simpleMessage(
      "Name must not be empty",
    ),
    "nearestNursery": MessageLookupByLibrary.simpleMessage(
      "Nearest Plant Nursery",
    ),
    "nitrogen": MessageLookupByLibrary.simpleMessage("Nitrogen"),
    "noDetectionHistory": MessageLookupByLibrary.simpleMessage(
      "No Detection History",
    ),
    "noStoresFound": MessageLookupByLibrary.simpleMessage(
      "No nearby stores found",
    ),
    "npkFormula": MessageLookupByLibrary.simpleMessage("NPK Formula"),
    "numberOfTrees": MessageLookupByLibrary.simpleMessage("Number of Trees"),
    "nutrition": MessageLookupByLibrary.simpleMessage("Nutrition"),
    "onboardingBody1": MessageLookupByLibrary.simpleMessage(
      "Stay updated with real-time weather and plant care advice tailored to your needs, and calculate the right amount of fertilizer for optimal plant growth.",
    ),
    "onboardingBody2": MessageLookupByLibrary.simpleMessage(
      "Upload a photo of your plant to identify diseases and get expert solutions instantly.",
    ),
    "onboardingBody3": MessageLookupByLibrary.simpleMessage(
      "Easily locate nearby plant stores with just a tap, helping you take better care of your plants.",
    ),
    "onboardingBody4": MessageLookupByLibrary.simpleMessage(
      "Connect with fellow plant lovers, share tips, and learn from each other to grow your green space together.",
    ),
    "onboardingTitle1": MessageLookupByLibrary.simpleMessage(
      "Welcome to Plantie!",
    ),
    "onboardingTitle2": MessageLookupByLibrary.simpleMessage(
      "Detect Plant Diseases",
    ),
    "onboardingTitle3": MessageLookupByLibrary.simpleMessage(
      "Find Nearby Plant Stores",
    ),
    "onboardingTitle4": MessageLookupByLibrary.simpleMessage(
      "Join the Plantie Community",
    ),
    "openSettings": MessageLookupByLibrary.simpleMessage("Open Settings"),
    "or_login_by": MessageLookupByLibrary.simpleMessage("or login by"),
    "or_register_by": MessageLookupByLibrary.simpleMessage("or register by"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "permanentDenial": MessageLookupByLibrary.simpleMessage(
      "Location permissions permanently denied. Please enable in settings.",
    ),
    "phone": MessageLookupByLibrary.simpleMessage("Phone"),
    "phoneRequired": MessageLookupByLibrary.simpleMessage(
      "Phone must not be empty",
    ),
    "phosphorus": MessageLookupByLibrary.simpleMessage("Phosphorus"),
    "plantType": m4,
    "plantingTime": MessageLookupByLibrary.simpleMessage("Planting Time"),
    "potassium": MessageLookupByLibrary.simpleMessage("Potassium"),
    "pressure": MessageLookupByLibrary.simpleMessage("Pressure"),
    "prevention": MessageLookupByLibrary.simpleMessage("Prevention"),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "profile2": MessageLookupByLibrary.simpleMessage("Profile"),
    "profileUpdated": MessageLookupByLibrary.simpleMessage(
      "Profile updated successfully",
    ),
    "recommendedNpk": MessageLookupByLibrary.simpleMessage(
      "Recommended NPK Ratio:",
    ),
    "recommendedTreatment": MessageLookupByLibrary.simpleMessage(
      "Recommended Treatment",
    ),
    "register": MessageLookupByLibrary.simpleMessage("Register"),
    "register_button": MessageLookupByLibrary.simpleMessage("Register"),
    "requiredFertilizers": m5,
    "reset_password": MessageLookupByLibrary.simpleMessage("Reset Password"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("Save Changes"),
    "sent_email_to_update_paassword": MessageLookupByLibrary.simpleMessage(
      "we sent to your email url to use it to reset the password",
    ),
    "skip": MessageLookupByLibrary.simpleMessage("SKIP"),
    "ssp": MessageLookupByLibrary.simpleMessage("SSP"),
    "storage": MessageLookupByLibrary.simpleMessage("Storage"),
    "submit": MessageLookupByLibrary.simpleMessage("Submit"),
    "sunrise": MessageLookupByLibrary.simpleMessage("Sunrise"),
    "sunset": MessageLookupByLibrary.simpleMessage("Sunset"),
    "tap_camera_to_scan": MessageLookupByLibrary.simpleMessage(
      "Tap the camera button below\nto start scanning your plants",
    ),
    "temperature": MessageLookupByLibrary.simpleMessage("Temperature"),
    "terms_and_conditions": MessageLookupByLibrary.simpleMessage(
      "By logging in or registering, you agree to our Terms of Service and Privacy Policy",
    ),
    "tips": MessageLookupByLibrary.simpleMessage("Tips"),
    "treatment": MessageLookupByLibrary.simpleMessage("Treatment"),
    "treatmentLabel": m6,
    "treeAge": MessageLookupByLibrary.simpleMessage("Tree Age (Years)"),
    "treeNote": m7,
    "tryAgain": MessageLookupByLibrary.simpleMessage("Try Again"),
    "unit": MessageLookupByLibrary.simpleMessage("Unit:"),
    "updateFailed": m8,
    "urea": MessageLookupByLibrary.simpleMessage("UREA"),
    "verificationError": m9,
    "verificationSent": MessageLookupByLibrary.simpleMessage(
      "Verification email resent. Please check your inbox.",
    ),
    "weather": MessageLookupByLibrary.simpleMessage("Weather"),
    "weatherError": m10,
    "weather_details": MessageLookupByLibrary.simpleMessage("Weather Details"),
    "welcome": MessageLookupByLibrary.simpleMessage("Welcome"),
    "welcome_back": MessageLookupByLibrary.simpleMessage(
      "Hello, Welcome back to Plantie!",
    ),
    "welcome_subtitle": MessageLookupByLibrary.simpleMessage(
      "Get more crops with Plantie\'s help!",
    ),
    "welcome_title": MessageLookupByLibrary.simpleMessage("Plantie"),
    "wind_speed": MessageLookupByLibrary.simpleMessage("Wind Speed"),
  };
}
