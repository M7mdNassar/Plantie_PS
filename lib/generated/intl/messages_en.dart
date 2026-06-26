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

  static String m0(current, max) => "${current}/${max}";

  static String m1(error) => "An error occurred: ${error}";

  static String m2(temp) => "Feels like ${temp}°C";

  static String m3(emoji, name) => "${emoji} ${name} Fertilizer";

  static String m4(value) =>
      "Temperature is low (${value}°C). High risk of frost damage. Protect sensitive crops.";

  static String m5(value) =>
      "High evapotranspiration rate (${value} mm). Consider increasing irrigation frequency.";

  static String m6(value) =>
      "Significant rain detected (${value} mm). Do not irrigate today to prevent waterlogging.";

  static String m7(unit) => "Land Area (${unit}):";

  static String m8(error) => "Error: ${error}";

  static String m9(type) => "Type: ${type}";

  static String m10(calculationContext) =>
      "Required Fertilizers (${calculationContext}):";

  static String m11(value) =>
      "Soil temperature is ${value}°C, ideal for most seed germination.";

  static String m12(treatment) => "${treatment}";

  static String m13(age) =>
      "Note: Calculations include age factor for ${age} year old trees";

  static String m14(error) => "Update failed: ${error}";

  static String m15(error) => "Error sending verification: ${error}";

  static String m16(error) => "Error fetching weather: ${error}";

  static String m17(value) =>
      "High wind speeds (${value} km/h). Avoid spraying pesticides as they may drift.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "aboutMe": MessageLookupByLibrary.simpleMessage("About Me"),
    "acre": MessageLookupByLibrary.simpleMessage("Acre"),
    "addPhotos": MessageLookupByLibrary.simpleMessage("Add Photos"),
    "aiAssistant": MessageLookupByLibrary.simpleMessage("AI Assistant"),
    "aiAssistantEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Ask me anything about plants, farming, or gardening.",
    ),
    "aiAssistantEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "How can I help you?",
    ),
    "allowAccess": MessageLookupByLibrary.simpleMessage("Allow Access"),
    "analyzing": MessageLookupByLibrary.simpleMessage("Analyzing Image..."),
    "analyzingImage": MessageLookupByLibrary.simpleMessage(
      "Analyzing Image...",
    ),
    "arShort": MessageLookupByLibrary.simpleMessage("AR"),
    "areaNote": MessageLookupByLibrary.simpleMessage(
      "Note: 1 Dunam = 1000 m² (10,000 sq ft)",
    ),
    "avatar": MessageLookupByLibrary.simpleMessage("avatar"),
    "avoid": MessageLookupByLibrary.simpleMessage("Avoid"),
    "avoidBlurred": MessageLookupByLibrary.simpleMessage(
      "Avoid blurred or tilted photos",
    ),
    "backgroundTip1": MessageLookupByLibrary.simpleMessage(
      "Use plain background",
    ),
    "backgroundTip2": MessageLookupByLibrary.simpleMessage(
      "White/light colors preferred",
    ),
    "backgroundTip3": MessageLookupByLibrary.simpleMessage(
      "Avoid busy patterns",
    ),
    "backgroundTips": MessageLookupByLibrary.simpleMessage("Background Tips"),
    "beFirstToComment": MessageLookupByLibrary.simpleMessage(
      "Be the first to comment",
    ),
    "beFirstToShare": MessageLookupByLibrary.simpleMessage(
      "Be the first to share something amazing!",
    ),
    "bio": MessageLookupByLibrary.simpleMessage("Bio"),
    "bioCharCount": m0,
    "bioField": MessageLookupByLibrary.simpleMessage("Bio"),
    "bioHint": MessageLookupByLibrary.simpleMessage(
      "Tell other farmers about yourself...",
    ),
    "bioOptional": MessageLookupByLibrary.simpleMessage("Bio (optional)"),
    "bioPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Add a short bio to let people know you...",
    ),
    "bioRequired": MessageLookupByLibrary.simpleMessage(
      "Bio must not be empty",
    ),
    "calculateFertilizer": MessageLookupByLibrary.simpleMessage(
      "Calculate Fertilizer",
    ),
    "calculateRequirements": MessageLookupByLibrary.simpleMessage(
      "Calculate Requirements",
    ),
    "cameraSource": MessageLookupByLibrary.simpleMessage("Take a Photo"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "captureGuidelines": MessageLookupByLibrary.simpleMessage(
      "Capture Guidelines",
    ),
    "checkNetwork": MessageLookupByLibrary.simpleMessage(
      "Please check your network status and try refreshing.",
    ),
    "checkWeatherPrompt": MessageLookupByLibrary.simpleMessage(
      "Check the weather in your area",
    ),
    "chooseFromGallery": MessageLookupByLibrary.simpleMessage(
      "Choose from Gallery",
    ),
    "choosePlant": MessageLookupByLibrary.simpleMessage("Choose a Plant"),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "clearChat": MessageLookupByLibrary.simpleMessage("Clear Chat"),
    "clearChatConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to clear this conversation?",
    ),
    "clearImage": MessageLookupByLibrary.simpleMessage("Clear image"),
    "clearSearch": MessageLookupByLibrary.simpleMessage("Clear search"),
    "clearSky": MessageLookupByLibrary.simpleMessage("Clear Sky"),
    "closeAndClear": MessageLookupByLibrary.simpleMessage("Close & Clear"),
    "closeFocus": MessageLookupByLibrary.simpleMessage("Close focus"),
    "comment": MessageLookupByLibrary.simpleMessage("Comment"),
    "commentFailed": MessageLookupByLibrary.simpleMessage(
      "Could not post comment. Please try again.",
    ),
    "comments": MessageLookupByLibrary.simpleMessage("Comments"),
    "community": MessageLookupByLibrary.simpleMessage("Community"),
    "completeProfilePrompt": MessageLookupByLibrary.simpleMessage(
      "Complete Your Profile!",
    ),
    "completeProfileSubtitle": MessageLookupByLibrary.simpleMessage(
      "Fill in your bio, location, and phone details to look official.",
    ),
    "confirmDelete": MessageLookupByLibrary.simpleMessage("Confirm Delete"),
    "confirmLogout": MessageLookupByLibrary.simpleMessage("Confirm Sign Out"),
    "contactInfo": MessageLookupByLibrary.simpleMessage("Contact Details"),
    "continueAsGuest": MessageLookupByLibrary.simpleMessage(
      "Continue as Guest",
    ),
    "continueButton": MessageLookupByLibrary.simpleMessage("Continue"),
    "country": MessageLookupByLibrary.simpleMessage("Country"),
    "countryField": MessageLookupByLibrary.simpleMessage("Country"),
    "countryOptional": MessageLookupByLibrary.simpleMessage(
      "Country (optional)",
    ),
    "countryPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Add your country",
    ),
    "countryRequired": MessageLookupByLibrary.simpleMessage(
      "Country must not be empty",
    ),
    "creat_account2": MessageLookupByLibrary.simpleMessage("Create Account"),
    "createNewPost": MessageLookupByLibrary.simpleMessage("Create new post"),
    "createPost": MessageLookupByLibrary.simpleMessage("Create Post"),
    "create_account": MessageLookupByLibrary.simpleMessage("Create account?"),
    "create_account3": MessageLookupByLibrary.simpleMessage(
      "Complete your information to get started!",
    ),
    "critical_farming": MessageLookupByLibrary.simpleMessage(
      "High risk! Take immediate action to protect crops.",
    ),
    "current_weather": MessageLookupByLibrary.simpleMessage("Current Weather"),
    "daily_forecast": MessageLookupByLibrary.simpleMessage("7-Day Forecast"),
    "darkMode": MessageLookupByLibrary.simpleMessage("Dark Mode"),
    "date": MessageLookupByLibrary.simpleMessage("Date"),
    "daysAgo": MessageLookupByLibrary.simpleMessage("days ago"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this item?",
    ),
    "deletePost": MessageLookupByLibrary.simpleMessage("Delete Post"),
    "deletePostConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this post? This action cannot be undone.",
    ),
    "deletePostQuestion": MessageLookupByLibrary.simpleMessage("Delete Post?"),
    "deletedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Item deleted successfully",
    ),
    "description": MessageLookupByLibrary.simpleMessage("Description"),
    "detection": MessageLookupByLibrary.simpleMessage("Detection"),
    "detectionGenericError": MessageLookupByLibrary.simpleMessage(
      "Something went wrong. Please try again.",
    ),
    "detectionResult": MessageLookupByLibrary.simpleMessage("Detection Result"),
    "detectionResults": MessageLookupByLibrary.simpleMessage(
      "Detection Results",
    ),
    "detectionTimeoutError": MessageLookupByLibrary.simpleMessage(
      "Analysis took too long. Please try again with a clearer image.",
    ),
    "discard": MessageLookupByLibrary.simpleMessage("Discard"),
    "discoverPlantCare": MessageLookupByLibrary.simpleMessage(
      "Discover expert plant care tips and join a community of plant lovers",
    ),
    "diseaseDetected": MessageLookupByLibrary.simpleMessage("Disease Detected"),
    "diseaseNotDetected": MessageLookupByLibrary.simpleMessage(
      "Disease not recognized",
    ),
    "diseases": MessageLookupByLibrary.simpleMessage("Diseases"),
    "distanceAndFocus": MessageLookupByLibrary.simpleMessage(
      "15-30cm from leaf, sharp focus",
    ),
    "distanceFromLeaf": MessageLookupByLibrary.simpleMessage(
      "Get 15-30cm from the leaf",
    ),
    "drizzle": MessageLookupByLibrary.simpleMessage("Drizzle"),
    "dunam": MessageLookupByLibrary.simpleMessage("Dunam"),
    "editProfile": MessageLookupByLibrary.simpleMessage("Edit Profile"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "email_address": MessageLookupByLibrary.simpleMessage("Email Address"),
    "email_valid": MessageLookupByLibrary.simpleMessage(
      "please enter a valid email",
    ),
    "enShort": MessageLookupByLibrary.simpleMessage("EN"),
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
    "errorLoadingPosts": MessageLookupByLibrary.simpleMessage(
      "Error loading posts",
    ),
    "errorOccurred": m1,
    "errorTitle": MessageLookupByLibrary.simpleMessage("Error"),
    "evapotranspiration": MessageLookupByLibrary.simpleMessage(
      "Evapotranspiration",
    ),
    "expertAdvice": MessageLookupByLibrary.simpleMessage("Expert Advice"),
    "failedToLoadPlants": MessageLookupByLibrary.simpleMessage(
      "Failed to load plants",
    ),
    "failedToLoadPlantsMessage": MessageLookupByLibrary.simpleMessage(
      "Unable to load plant data. Please check your internet connection and try again.",
    ),
    "farming_insights": MessageLookupByLibrary.simpleMessage(
      "Farming Insights",
    ),
    "feelsLike": m2,
    "feels_like": MessageLookupByLibrary.simpleMessage("Feels Like"),
    "fertilizerCalculator": m3,
    "fetchingWeather": MessageLookupByLibrary.simpleMessage(
      "Fetching weather...",
    ),
    "findNearestStore": MessageLookupByLibrary.simpleMessage(
      "Find Nearest Store",
    ),
    "focusOnDiseased": MessageLookupByLibrary.simpleMessage(
      "Focus on one diseased leaf",
    ),
    "focusOnOneDiseased": MessageLookupByLibrary.simpleMessage(
      "Focus on one diseased area",
    ),
    "focusRequirements": MessageLookupByLibrary.simpleMessage(
      "Focus Requirements",
    ),
    "focusTip1": MessageLookupByLibrary.simpleMessage(
      "Ensure leaf edges are clear",
    ),
    "focusTip2": MessageLookupByLibrary.simpleMessage(
      "Focus on affected areas",
    ),
    "focusTip3": MessageLookupByLibrary.simpleMessage("Keep camera steady"),
    "foggy": MessageLookupByLibrary.simpleMessage("Foggy"),
    "followTheseSteps": MessageLookupByLibrary.simpleMessage(
      "Follow these tips for best results",
    ),
    "forget_password": MessageLookupByLibrary.simpleMessage("Forget Password?"),
    "frost_message": m4,
    "frost_risk": MessageLookupByLibrary.simpleMessage("Frost Risk"),
    "gallerySource": MessageLookupByLibrary.simpleMessage(
      "Choose from Gallery",
    ),
    "getOtpCode": MessageLookupByLibrary.simpleMessage("Get OTP Code"),
    "getWeather": MessageLookupByLibrary.simpleMessage("Get Weather"),
    "good": MessageLookupByLibrary.simpleMessage("Good"),
    "goodLighting": MessageLookupByLibrary.simpleMessage("Good lighting"),
    "goodLightingCapture": MessageLookupByLibrary.simpleMessage(
      "Good Lighting",
    ),
    "good_for_farming": MessageLookupByLibrary.simpleMessage(
      "Good conditions for farming activities.",
    ),
    "gotIt": MessageLookupByLibrary.simpleMessage("Got It"),
    "gpsDisabled": MessageLookupByLibrary.simpleMessage(
      "Location services disabled. Please enable GPS.",
    ),
    "grantLocationPermission": MessageLookupByLibrary.simpleMessage(
      "Grant location permission to view weather details",
    ),
    "guestBenefit1Desc": MessageLookupByLibrary.simpleMessage(
      "Access your detection history across devices",
    ),
    "guestBenefit1Title": MessageLookupByLibrary.simpleMessage(
      "Sync Your History",
    ),
    "guestBenefit2Desc": MessageLookupByLibrary.simpleMessage(
      "Like, comment, and share with other plant lovers",
    ),
    "guestBenefit2Title": MessageLookupByLibrary.simpleMessage(
      "Join the Community",
    ),
    "guestBenefit3Desc": MessageLookupByLibrary.simpleMessage(
      "Your feedback trains better disease detection for everyone",
    ),
    "guestBenefit3Title": MessageLookupByLibrary.simpleMessage(
      "Help Improve Plantie",
    ),
    "guestBrowsingNote": MessageLookupByLibrary.simpleMessage(
      "Browsing as Guest • All detections are stored locally",
    ),
    "guestCommunityDescription": MessageLookupByLibrary.simpleMessage(
      "Create an account to post, like, and comment with other plant lovers",
    ),
    "guestCommunityTitle": MessageLookupByLibrary.simpleMessage(
      "Share with the community",
    ),
    "guestCreateAccount": MessageLookupByLibrary.simpleMessage(
      "Create Account",
    ),
    "guestJoinSubtitle": MessageLookupByLibrary.simpleMessage(
      "Unlock the full Plantie experience",
    ),
    "guestJoinTitle": MessageLookupByLibrary.simpleMessage("Join Plantie"),
    "guestProfileTitle": MessageLookupByLibrary.simpleMessage("Profile"),
    "guestPromptDescription": MessageLookupByLibrary.simpleMessage(
      "Create an account to like, comment, and share with the Plantie community",
    ),
    "guestPromptMaybeLater": MessageLookupByLibrary.simpleMessage(
      "Maybe Later",
    ),
    "guestPromptSignUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
    "guestPromptTitle": MessageLookupByLibrary.simpleMessage("Sign up to join"),
    "guestSignIn": MessageLookupByLibrary.simpleMessage("Sign In"),
    "have_account": MessageLookupByLibrary.simpleMessage(
      "Already have an account? ",
    ),
    "healthy": MessageLookupByLibrary.simpleMessage("Healthy"),
    "high_evaporation": MessageLookupByLibrary.simpleMessage(
      "High Evaporation",
    ),
    "high_evaporation_message": m5,
    "history": MessageLookupByLibrary.simpleMessage("History"),
    "historyPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Your plant health scans will appear here",
    ),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "homeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Take care of your plants",
    ),
    "hourly_forecast": MessageLookupByLibrary.simpleMessage("Hourly Forecast"),
    "humidity": MessageLookupByLibrary.simpleMessage("Humidity"),
    "humidity_level": MessageLookupByLibrary.simpleMessage("Humidity"),
    "iUnderstand": MessageLookupByLibrary.simpleMessage(
      "I Understand - Continue",
    ),
    "ideal_spraying": MessageLookupByLibrary.simpleMessage("Ideal Spraying"),
    "ideal_spraying_message": MessageLookupByLibrary.simpleMessage(
      "Wind conditions are calm. Good time for pest control application.",
    ),
    "invalidImageError": MessageLookupByLibrary.simpleMessage(
      "Could not read the image. Please select a valid photo.",
    ),
    "invalidPhone": MessageLookupByLibrary.simpleMessage(
      "Invalid phone number",
    ),
    "irrigation_alert": MessageLookupByLibrary.simpleMessage(
      "Irrigation Alert",
    ),
    "irrigation_message": m6,
    "itemDeleted": MessageLookupByLibrary.simpleMessage(
      "Your scan has been removed",
    ),
    "keepEditing": MessageLookupByLibrary.simpleMessage("Keep Editing"),
    "landArea": m7,
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "languageChanged": MessageLookupByLibrary.simpleMessage(
      "Language changed. Restart the app?",
    ),
    "latest": MessageLookupByLibrary.simpleMessage("Latest"),
    "launchError": MessageLookupByLibrary.simpleMessage(
      "Could not launch maps",
    ),
    "letsStart": MessageLookupByLibrary.simpleMessage("Let\'s Start 🌱"),
    "lettersAndSpacesOnly": MessageLookupByLibrary.simpleMessage(
      "Letters and spaces only",
    ),
    "like": MessageLookupByLibrary.simpleMessage("Like"),
    "likePost": MessageLookupByLibrary.simpleMessage("Like post"),
    "likes": MessageLookupByLibrary.simpleMessage("likes"),
    "loadingMorePosts": MessageLookupByLibrary.simpleMessage(
      "Loading more posts...",
    ),
    "locationDenied": MessageLookupByLibrary.simpleMessage(
      "Location permission denied",
    ),
    "locationError": m8,
    "locationRequired": MessageLookupByLibrary.simpleMessage(
      "Location permission required",
    ),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "login_button": MessageLookupByLibrary.simpleMessage("Login"),
    "logout": MessageLookupByLibrary.simpleMessage("Log Out"),
    "logoutConfirm": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to logout?",
    ),
    "logoutMessage": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to log out of your account?",
    ),
    "mop": MessageLookupByLibrary.simpleMessage("MOP"),
    "moreOptions": MessageLookupByLibrary.simpleMessage("More options"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "nameField": MessageLookupByLibrary.simpleMessage("Full Name"),
    "nameHint": MessageLookupByLibrary.simpleMessage("Your name"),
    "nameRequired": MessageLookupByLibrary.simpleMessage(
      "Name cannot be left empty",
    ),
    "nameTooShort": MessageLookupByLibrary.simpleMessage(
      "Name must be at least 2 characters",
    ),
    "namefield": MessageLookupByLibrary.simpleMessage("Name"),
    "naturalLightWorks": MessageLookupByLibrary.simpleMessage(
      "Natural light works best",
    ),
    "naturalSunlightWorks": MessageLookupByLibrary.simpleMessage(
      "Natural sunlight works best",
    ),
    "nearestNursery": MessageLookupByLibrary.simpleMessage(
      "Nearest Plant Nursery",
    ),
    "newPost": MessageLookupByLibrary.simpleMessage("New Post"),
    "nitrogen": MessageLookupByLibrary.simpleMessage("Nitrogen"),
    "noAccountNeeded": MessageLookupByLibrary.simpleMessage(
      "No account or password needed",
    ),
    "noCommentsYet": MessageLookupByLibrary.simpleMessage("No comments yet"),
    "noDetails": MessageLookupByLibrary.simpleMessage(""),
    "noDetectionHistory": MessageLookupByLibrary.simpleMessage(
      "No Detection History",
    ),
    "noDiseases": MessageLookupByLibrary.simpleMessage("No diseases recorded"),
    "noHistoryYet": MessageLookupByLibrary.simpleMessage("No history yet"),
    "noInternet": MessageLookupByLibrary.simpleMessage(
      "No Internet Connection",
    ),
    "noInternetConnection": MessageLookupByLibrary.simpleMessage(
      "No Internet Connection",
    ),
    "noNewNotifications": MessageLookupByLibrary.simpleMessage(
      "No new notifications",
    ),
    "noPostsMatch": MessageLookupByLibrary.simpleMessage(
      "No posts match your search",
    ),
    "noStoresFound": MessageLookupByLibrary.simpleMessage(
      "No nearby stores found",
    ),
    "no_insights": MessageLookupByLibrary.simpleMessage(
      "No specific alerts for today.",
    ),
    "no_posts": MessageLookupByLibrary.simpleMessage("No posts"),
    "notAPlant": MessageLookupByLibrary.simpleMessage("Not a Plant"),
    "notAPlantError": MessageLookupByLibrary.simpleMessage(
      "The image does not appear to contain a plant leaf.",
    ),
    "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
    "npkFormula": MessageLookupByLibrary.simpleMessage("NPK Formula"),
    "numberOfTrees": MessageLookupByLibrary.simpleMessage("Number of Trees"),
    "nutrition": MessageLookupByLibrary.simpleMessage("Nutrition"),
    "offlineAvatarError": MessageLookupByLibrary.simpleMessage(
      "Cannot update avatar while offline. Please connect to the internet.",
    ),
    "offlineCommentError": MessageLookupByLibrary.simpleMessage(
      "No internet connection. Your comment will be saved when you\'re back online.",
    ),
    "offlineLikeError": MessageLookupByLibrary.simpleMessage(
      "No internet connection. Like will be saved when you\'re back online.",
    ),
    "offlineLoadMoreError": MessageLookupByLibrary.simpleMessage(
      "No internet connection. Cannot load more posts.",
    ),
    "offlinePostMessage": MessageLookupByLibrary.simpleMessage(
      "You are currently offline. Your post will be saved and uploaded when you regain internet connection.",
    ),
    "offlineSaveError": MessageLookupByLibrary.simpleMessage(
      "No internet connection. Please check your network and try again.",
    ),
    "offlineSubtitle": MessageLookupByLibrary.simpleMessage(
      "Please check your network status and try refreshing.",
    ),
    "offlineTitle": MessageLookupByLibrary.simpleMessage(
      "No Internet Connection",
    ),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
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
    "outOfMemoryError": MessageLookupByLibrary.simpleMessage(
      "Image is too large. Please use a smaller photo.",
    ),
    "partlyCloudy": MessageLookupByLibrary.simpleMessage("Partly Cloudy"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "permanentDenial": MessageLookupByLibrary.simpleMessage(
      "Location permissions permanently denied. Please enable in settings.",
    ),
    "phone": MessageLookupByLibrary.simpleMessage("Phone"),
    "phoneField": MessageLookupByLibrary.simpleMessage("Phone Number"),
    "phoneHint": MessageLookupByLibrary.simpleMessage("Enter phone number"),
    "phoneOptional": MessageLookupByLibrary.simpleMessage("Phone (optional)"),
    "phonePlaceholder": MessageLookupByLibrary.simpleMessage(
      "Add phone number",
    ),
    "phoneRequired": MessageLookupByLibrary.simpleMessage(
      "Phone must not be empty",
    ),
    "phosphorus": MessageLookupByLibrary.simpleMessage("Phosphorus"),
    "photos": MessageLookupByLibrary.simpleMessage("Photos"),
    "plantDiagnosis": MessageLookupByLibrary.simpleMessage("Plant Diagnosis"),
    "plantType": m9,
    "plantingTime": MessageLookupByLibrary.simpleMessage("Planting Time"),
    "pleaseWait": MessageLookupByLibrary.simpleMessage(
      "Please wait while AI detects...",
    ),
    "popular": MessageLookupByLibrary.simpleMessage("Popular"),
    "positioningTip1": MessageLookupByLibrary.simpleMessage(
      "Capture in good natural lighting",
    ),
    "positioningTip2": MessageLookupByLibrary.simpleMessage(
      "Fill frame with the leaf",
    ),
    "positioningTip3": MessageLookupByLibrary.simpleMessage(
      "Avoid shadows on the subject",
    ),
    "positioningTips": MessageLookupByLibrary.simpleMessage("Positioning Tips"),
    "post": MessageLookupByLibrary.simpleMessage("Post"),
    "postActions": MessageLookupByLibrary.simpleMessage("Post actions"),
    "postButton": MessageLookupByLibrary.simpleMessage("Post"),
    "postCreatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Post created successfully!",
    ),
    "postOptions": MessageLookupByLibrary.simpleMessage("Post options"),
    "postedBy": MessageLookupByLibrary.simpleMessage("Post by"),
    "postingComment": MessageLookupByLibrary.simpleMessage(
      "Posting comment...",
    ),
    "potassium": MessageLookupByLibrary.simpleMessage("Potassium"),
    "precipitation": MessageLookupByLibrary.simpleMessage("Precipitation"),
    "precipitation_chart": MessageLookupByLibrary.simpleMessage(
      "Precipitation",
    ),
    "preferencesAndOptions": MessageLookupByLibrary.simpleMessage(
      "PREFERENCES & OPTIONS",
    ),
    "pressure": MessageLookupByLibrary.simpleMessage("Pressure"),
    "prevention": MessageLookupByLibrary.simpleMessage("Prevention"),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "profile2": MessageLookupByLibrary.simpleMessage("Profile"),
    "profileUpdated": MessageLookupByLibrary.simpleMessage(
      "Profile updated successfully",
    ),
    "profileUpdatedMsg": MessageLookupByLibrary.simpleMessage(
      "Your profile information has been securely updated.",
    ),
    "profileUpdatedSuccess": MessageLookupByLibrary.simpleMessage(
      "Profile updated successfully",
    ),
    "quickTipsForBestResults": MessageLookupByLibrary.simpleMessage(
      "Quick tips for best results",
    ),
    "rainShowers": MessageLookupByLibrary.simpleMessage("Rain Showers"),
    "rainy": MessageLookupByLibrary.simpleMessage("Rainy"),
    "recentDiagnoses": MessageLookupByLibrary.simpleMessage("Recent Diagnoses"),
    "recommendation": MessageLookupByLibrary.simpleMessage("Recommendation"),
    "recommendedNpk": MessageLookupByLibrary.simpleMessage(
      "Recommended NPK Ratio:",
    ),
    "recommendedTreatment": MessageLookupByLibrary.simpleMessage(
      "Recommended Treatment",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage("Refresh"),
    "register": MessageLookupByLibrary.simpleMessage("Register"),
    "register_button": MessageLookupByLibrary.simpleMessage("Register"),
    "requiredFertilizers": m10,
    "requiredField": MessageLookupByLibrary.simpleMessage(
      "This field is required",
    ),
    "reset_password": MessageLookupByLibrary.simpleMessage("Reset Password"),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "retryButton": MessageLookupByLibrary.simpleMessage("Retry"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "saveAvatar": MessageLookupByLibrary.simpleMessage("Save Avatar"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("Save Changes"),
    "scanAnother": MessageLookupByLibrary.simpleMessage("Scan Another"),
    "scanPlantPrompt": MessageLookupByLibrary.simpleMessage(
      "Identify Plant Diseases",
    ),
    "scanPlantSubPrompt": MessageLookupByLibrary.simpleMessage(
      "Take a photo of a leaf to get an instant diagnosis and treatment plan.",
    ),
    "searchByPostContent": MessageLookupByLibrary.simpleMessage(
      "Search by post content",
    ),
    "searchPosts": MessageLookupByLibrary.simpleMessage("Search posts"),
    "selectCountry": MessageLookupByLibrary.simpleMessage("Select country"),
    "selectLanguage": MessageLookupByLibrary.simpleMessage("Select Language"),
    "sendOtpSms": MessageLookupByLibrary.simpleMessage(
      "We\'ll send you a verification code via SMS",
    ),
    "sent_email_to_update_paassword": MessageLookupByLibrary.simpleMessage(
      "we sent to your email url to use it to reset the password",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "showLess": MessageLookupByLibrary.simpleMessage("Show less"),
    "showMore": MessageLookupByLibrary.simpleMessage("Show more"),
    "singleLeaf": MessageLookupByLibrary.simpleMessage("Single leaf"),
    "singleLeafCapture": MessageLookupByLibrary.simpleMessage("Single Leaf"),
    "skip": MessageLookupByLibrary.simpleMessage("SKIP"),
    "snowy": MessageLookupByLibrary.simpleMessage("Snowy"),
    "soil_condition": MessageLookupByLibrary.simpleMessage("Soil Condition"),
    "soil_condition_message": m11,
    "soil_temp": MessageLookupByLibrary.simpleMessage("Soil Temperature"),
    "ssp": MessageLookupByLibrary.simpleMessage("SSP"),
    "startDetection": MessageLookupByLibrary.simpleMessage("Start Detection"),
    "startScan": MessageLookupByLibrary.simpleMessage("Start Scan"),
    "storage": MessageLookupByLibrary.simpleMessage("Storage"),
    "submit": MessageLookupByLibrary.simpleMessage("Submit"),
    "successTitle": MessageLookupByLibrary.simpleMessage("Success"),
    "sunrise": MessageLookupByLibrary.simpleMessage("Sunrise"),
    "sunset": MessageLookupByLibrary.simpleMessage("Sunset"),
    "takePhoto": MessageLookupByLibrary.simpleMessage("Take Photo"),
    "tapCamera": MessageLookupByLibrary.simpleMessage("Tap Camera"),
    "tapCameraToDetect": MessageLookupByLibrary.simpleMessage(
      "Tap the camera button to capture a plant image and start the diagnosis",
    ),
    "tap_camera_to_scan": MessageLookupByLibrary.simpleMessage(
      "Tap the camera button below\nto start scanning your plants",
    ),
    "temperature": MessageLookupByLibrary.simpleMessage("Temperature"),
    "temperature_chart": MessageLookupByLibrary.simpleMessage("Temperature"),
    "terms_and_conditions": MessageLookupByLibrary.simpleMessage(
      "By logging in or registering, you agree to our Terms of Service and Privacy Policy",
    ),
    "thunderstorm": MessageLookupByLibrary.simpleMessage("Thunderstorm"),
    "tips": MessageLookupByLibrary.simpleMessage("Tips"),
    "tipsForAccurateDetection": MessageLookupByLibrary.simpleMessage(
      "Tips for Accurate Detection",
    ),
    "today": MessageLookupByLibrary.simpleMessage("Today"),
    "treatment": MessageLookupByLibrary.simpleMessage("Treatment"),
    "treatmentLabel": m12,
    "treeAge": MessageLookupByLibrary.simpleMessage("Tree Age (Years)"),
    "treeNote": m13,
    "trending": MessageLookupByLibrary.simpleMessage("Trending"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("Try Again"),
    "typeMessage": MessageLookupByLibrary.simpleMessage("Type a message..."),
    "unit": MessageLookupByLibrary.simpleMessage("Unit:"),
    "unknownDisease": MessageLookupByLibrary.simpleMessage("Unknown"),
    "unlikePost": MessageLookupByLibrary.simpleMessage("Unlike post"),
    "unsavedChangesMsg": MessageLookupByLibrary.simpleMessage(
      "You have modified details. Leaving now will discard all edits.",
    ),
    "unsavedChangesTitle": MessageLookupByLibrary.simpleMessage(
      "Unsaved Changes",
    ),
    "updateFailed": m14,
    "urea": MessageLookupByLibrary.simpleMessage("UREA"),
    "userDataNotFound": MessageLookupByLibrary.simpleMessage(
      "User data not found. Please log in again.",
    ),
    "verificationError": m15,
    "verificationSent": MessageLookupByLibrary.simpleMessage(
      "Verification email resent. Please check your inbox.",
    ),
    "viewDetails": MessageLookupByLibrary.simpleMessage("View Details"),
    "warning_farming": MessageLookupByLibrary.simpleMessage(
      "Use caution with some farming activities.",
    ),
    "weather": MessageLookupByLibrary.simpleMessage("Weather"),
    "weatherError": m16,
    "weatherErrorTitle": MessageLookupByLibrary.simpleMessage(
      "Error loading weather",
    ),
    "weather_details": MessageLookupByLibrary.simpleMessage("Weather Details"),
    "weather_trends": MessageLookupByLibrary.simpleMessage("Weather Trends"),
    "welcome": MessageLookupByLibrary.simpleMessage("Welcome"),
    "welcomeToPlantie": MessageLookupByLibrary.simpleMessage(
      "Welcome to Plantie!",
    ),
    "welcome_back": MessageLookupByLibrary.simpleMessage(
      "Hello, Welcome back to Plantie!",
    ),
    "welcome_subtitle": MessageLookupByLibrary.simpleMessage(
      "Get more crops with Plantie\'s help!",
    ),
    "welcome_title": MessageLookupByLibrary.simpleMessage("Plantie"),
    "whatsOnMind": MessageLookupByLibrary.simpleMessage(
      "What\'s on your mind?",
    ),
    "whatsYourName": MessageLookupByLibrary.simpleMessage(
      "What should we call you?",
    ),
    "wind_message": m17,
    "wind_speed": MessageLookupByLibrary.simpleMessage("Wind Speed"),
    "wind_warning": MessageLookupByLibrary.simpleMessage("Wind Warning"),
    "writeComment": MessageLookupByLibrary.simpleMessage("Write comment"),
    "write_comment": MessageLookupByLibrary.simpleMessage("Write a comment..."),
    "yesterday": MessageLookupByLibrary.simpleMessage("Yesterday"),
  };
}
