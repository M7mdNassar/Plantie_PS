// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get onboardingTitle1 => 'Welcome to Plantie!';

  @override
  String get onboardingBody1 =>
      'Stay updated with real-time weather and plant care advice tailored to your needs, and calculate the right amount of fertilizer for optimal plant growth.';

  @override
  String get onboardingTitle2 => 'Detect Plant Diseases';

  @override
  String get onboardingBody2 =>
      'Upload a photo of your plant to identify diseases and get expert solutions instantly.';

  @override
  String get onboardingTitle3 => 'Find Nearby Plant Stores';

  @override
  String get onboardingBody3 =>
      'Easily locate nearby plant stores with just a tap, helping you take better care of your plants.';

  @override
  String get onboardingTitle4 => 'Join the Plantie Community';

  @override
  String get onboardingBody4 =>
      'Connect with fellow plant lovers, share tips, and learn from each other to grow your green space together.';

  @override
  String get skip => 'SKIP';

  @override
  String get welcome_title => 'Plantie';

  @override
  String get welcome_subtitle => 'Get more crops with Plantie\'s help!';

  @override
  String get login_button => 'Login';

  @override
  String get register_button => 'Register';

  @override
  String get terms_and_conditions =>
      'By logging in or registering, you agree to our Terms of Service and Privacy Policy';

  @override
  String get welcome => 'Welcome';

  @override
  String get welcome_back => 'Hello, Welcome back to Plantie!';

  @override
  String get email_address => 'Email Address';

  @override
  String get enter_email => 'Please enter your email address';

  @override
  String get password => 'Password';

  @override
  String get enter_password => 'Password is too short';

  @override
  String get forget_password => 'Forget Password?';

  @override
  String get login => 'Login';

  @override
  String get create_account => 'Create account?';

  @override
  String get register => 'Register';

  @override
  String get or_login_by => 'or login by';

  @override
  String get reset_password => 'Reset Password';

  @override
  String get sent_email_to_update_paassword =>
      'we sent to your email url to use it to reset the password';

  @override
  String get submit => 'Submit';

  @override
  String get cancel => 'Cancel';

  @override
  String get name => 'Name';

  @override
  String get creat_account2 => 'Create Account';

  @override
  String get create_account3 => 'Complete your information to get started!';

  @override
  String get enter_name => 'please enter a user name';

  @override
  String get email_valid => 'please enter a valid email';

  @override
  String get or_register_by => 'or register by';

  @override
  String get have_account => 'Already have an account? ';

  @override
  String get weather => 'Weather';

  @override
  String get choosePlant => 'Choose a Plant';

  @override
  String get calculateFertilizer => 'Calculate Fertilizer';

  @override
  String get description => 'Description';

  @override
  String get nutrition => 'Nutrition';

  @override
  String get storage => 'Storage';

  @override
  String get diseases => 'Diseases';

  @override
  String get plantingTime => 'Planting Time';

  @override
  String get npkFormula => 'NPK Formula';

  @override
  String get temperature => 'Temperature';

  @override
  String get humidity => 'Humidity';

  @override
  String get prevention => 'Prevention';

  @override
  String get fetchingWeather => 'Fetching weather...';

  @override
  String get locationRequired => 'Location permission required';

  @override
  String get enableLocation => 'Enable Location';

  @override
  String get permanentDenial =>
      'Location permissions permanently denied. Please enable in settings.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get gpsDisabled => 'Location services disabled. Please enable GPS.';

  @override
  String get enableGPS => 'Enable GPS';

  @override
  String weatherError(Object error) {
    return 'Error fetching weather: $error';
  }

  @override
  String get tryAgain => 'Try Again';

  @override
  String get getWeather => 'Get Weather';

  @override
  String feelsLike(Object temp) {
    return 'Feels like $temp°C';
  }

  @override
  String get weather_details => 'Weather Details';

  @override
  String get current_weather => 'Current Weather';

  @override
  String get feels_like => 'Feels Like';

  @override
  String get wind_speed => 'Wind Speed';

  @override
  String get pressure => 'Pressure';

  @override
  String get sunrise => 'Sunrise';

  @override
  String get sunset => 'Sunset';

  @override
  String get farming_insights => 'Farming Insights';

  @override
  String get hourly_forecast => 'Hourly Forecast';

  @override
  String get daily_forecast => '7-Day Forecast';

  @override
  String get today => 'Today';

  @override
  String get soil_temp => 'Soil Temperature';

  @override
  String get evapotranspiration => 'Evapotranspiration';

  @override
  String get precipitation => 'Precipitation';

  @override
  String get humidity_level => 'Humidity';

  @override
  String get no_insights => 'No specific alerts for today.';

  @override
  String get good_for_farming => 'Good conditions for farming activities.';

  @override
  String get warning_farming => 'Use caution with some farming activities.';

  @override
  String get critical_farming =>
      'High risk! Take immediate action to protect crops.';

  @override
  String get recommendation => 'Recommendation';

  @override
  String get weather_trends => 'Weather Trends';

  @override
  String get temperature_chart => 'Temperature';

  @override
  String get precipitation_chart => 'Precipitation';

  @override
  String fertilizerCalculator(Object emoji, Object name) {
    return '$emoji $name Fertilizer';
  }

  @override
  String plantType(Object type) {
    return 'Type: $type';
  }

  @override
  String landArea(Object unit) {
    return 'Land Area ($unit):';
  }

  @override
  String get numberOfTrees => 'Number of Trees';

  @override
  String get treeAge => 'Tree Age (Years)';

  @override
  String get recommendedNpk => 'Recommended NPK Ratio:';

  @override
  String get calculateRequirements => 'Calculate Requirements';

  @override
  String requiredFertilizers(Object calculationContext) {
    return 'Required Fertilizers ($calculationContext):';
  }

  @override
  String treeNote(Object age) {
    return 'Note: Calculations include age factor for $age year old trees';
  }

  @override
  String get areaNote => 'Note: 1 Dunam = 1000 m² (10,000 sq ft)';

  @override
  String get nitrogen => 'Nitrogen';

  @override
  String get phosphorus => 'Phosphorus';

  @override
  String get potassium => 'Potassium';

  @override
  String get dunam => 'Dunam';

  @override
  String get acre => 'Acre';

  @override
  String get unit => 'Unit:';

  @override
  String get urea => 'UREA';

  @override
  String get ssp => 'SSP';

  @override
  String get mop => 'MOP';

  @override
  String get profile => 'Profile';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get logout => 'Log Out';

  @override
  String get confirmLogout => 'Confirm Sign Out';

  @override
  String get logoutMessage =>
      'Are you sure you want to log out of your account?';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get save => 'Save';

  @override
  String get bio => 'Bio';

  @override
  String get country => 'Country';

  @override
  String get phone => 'Phone';

  @override
  String get email => 'Email';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get nameRequired => 'Name cannot be left empty';

  @override
  String get bioRequired => 'Bio must not be empty';

  @override
  String get countryRequired => 'Country must not be empty';

  @override
  String get phoneRequired => 'Phone must not be empty';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String updateFailed(Object error) {
    return 'Update failed: $error';
  }

  @override
  String get namefield => 'Name';

  @override
  String get phoneOptional => 'Phone (optional)';

  @override
  String get bioOptional => 'Bio (optional)';

  @override
  String get countryOptional => 'Country (optional)';

  @override
  String get bioHint => 'Tell other farmers about yourself...';

  @override
  String bioCharCount(Object current, Object max) {
    return '$current/$max';
  }

  @override
  String get settings => 'Settings';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get refresh => 'Refresh';

  @override
  String get home => 'Home';

  @override
  String get community => 'Community';

  @override
  String get detection => 'Detection';

  @override
  String get profile2 => 'Profile';

  @override
  String get verificationSent =>
      'Verification email resent. Please check your inbox.';

  @override
  String verificationError(Object error) {
    return 'Error sending verification: $error';
  }

  @override
  String get detectionResults => 'Detection Results';

  @override
  String get detectionResult => 'Detection Result';

  @override
  String get recommendedTreatment => 'Recommended Treatment';

  @override
  String get history => 'History';

  @override
  String get noDetectionHistory => 'No Detection History';

  @override
  String get historyPlaceholder => 'Your plant health scans will appear here';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get deleteConfirmation => 'Are you sure you want to delete this item?';

  @override
  String get delete => 'Delete';

  @override
  String treatmentLabel(Object treatment) {
    return '$treatment';
  }

  @override
  String get treatment => 'Treatment';

  @override
  String get tips => 'Tips';

  @override
  String get date => 'Date';

  @override
  String get nearestNursery => 'Nearest Plant Nursery';

  @override
  String get noStoresFound => 'No nearby stores found';

  @override
  String locationError(Object error) {
    return 'Error: $error';
  }

  @override
  String get launchError => 'Could not launch maps';

  @override
  String get tap_camera_to_scan =>
      'Tap the camera button below\nto start scanning your plants';

  @override
  String get searchPosts => 'Search posts';

  @override
  String get newPost => 'New Post';

  @override
  String get comments => 'Comments';

  @override
  String get write_comment => 'Write a comment...';

  @override
  String get no_posts => 'No posts';

  @override
  String get createPost => 'Create Post';

  @override
  String get postButton => 'Post';

  @override
  String get whatsOnMind => 'What\'s on your mind?';

  @override
  String get addPhotos => 'Add Photos';

  @override
  String get positioningTips => 'Positioning Tips';

  @override
  String get positioningTip1 => 'Capture in good natural lighting';

  @override
  String get positioningTip2 => 'Fill frame with the leaf';

  @override
  String get positioningTip3 => 'Avoid shadows on the subject';

  @override
  String get focusRequirements => 'Focus Requirements';

  @override
  String get focusTip1 => 'Ensure leaf edges are clear';

  @override
  String get focusTip2 => 'Focus on affected areas';

  @override
  String get focusTip3 => 'Keep camera steady';

  @override
  String get backgroundTips => 'Background Tips';

  @override
  String get backgroundTip1 => 'Use plain background';

  @override
  String get backgroundTip2 => 'White/light colors preferred';

  @override
  String get backgroundTip3 => 'Avoid busy patterns';

  @override
  String get captureGuidelines => 'Capture Guidelines';

  @override
  String get iUnderstand => 'I Understand - Continue';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String errorOccurred(Object error) {
    return 'An error occurred: $error';
  }

  @override
  String get unknownDisease => 'Unknown';

  @override
  String get noDetails => '';

  @override
  String get diseaseNotDetected => 'Disease not recognized';

  @override
  String get good => 'Good';

  @override
  String get avoid => 'Avoid';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageChanged => 'Language changed. Restart the app?';

  @override
  String get irrigation_alert => 'Irrigation Alert';

  @override
  String irrigation_message(Object value) {
    return 'Significant rain detected ($value mm). Do not irrigate today to prevent waterlogging.';
  }

  @override
  String get wind_warning => 'Wind Warning';

  @override
  String wind_message(Object value) {
    return 'High wind speeds ($value km/h). Avoid spraying pesticides as they may drift.';
  }

  @override
  String get ideal_spraying => 'Ideal Spraying';

  @override
  String get ideal_spraying_message =>
      'Wind conditions are calm. Good time for pest control application.';

  @override
  String get frost_risk => 'Frost Risk';

  @override
  String frost_message(Object value) {
    return 'Temperature is low ($value°C). High risk of frost damage. Protect sensitive crops.';
  }

  @override
  String get high_evaporation => 'High Evaporation';

  @override
  String high_evaporation_message(Object value) {
    return 'High evapotranspiration rate ($value mm). Consider increasing irrigation frequency.';
  }

  @override
  String get soil_condition => 'Soil Condition';

  @override
  String soil_condition_message(Object value) {
    return 'Soil temperature is $value°C, ideal for most seed germination.';
  }

  @override
  String get analyzingImage => 'Analyzing Image...';

  @override
  String get pleaseWait => 'Please wait while AI detects...';

  @override
  String get expertAdvice => 'Expert Advice';

  @override
  String get findNearestStore => 'Find Nearest Store';

  @override
  String get tipsForAccurateDetection => 'Tips for Accurate Detection';

  @override
  String get healthy => 'Healthy';

  @override
  String get diseaseDetected => 'Disease Detected';

  @override
  String get goodLighting => 'Good lighting';

  @override
  String get naturalSunlightWorks => 'Natural sunlight works best';

  @override
  String get closeFocus => 'Close focus';

  @override
  String get distanceFromLeaf => 'Get 15-30cm from the leaf';

  @override
  String get clearImage => 'Clear image';

  @override
  String get avoidBlurred => 'Avoid blurred or tilted photos';

  @override
  String get singleLeaf => 'Single leaf';

  @override
  String get focusOnDiseased => 'Focus on one diseased leaf';

  @override
  String get deletedSuccessfully => 'Item deleted successfully';

  @override
  String get itemDeleted => 'Your scan has been removed';

  @override
  String get startDetection => 'Start Detection';

  @override
  String get tapCameraToDetect =>
      'Tap the camera button to capture a plant image and start the diagnosis';

  @override
  String get tapCamera => 'Tap Camera';

  @override
  String get followTheseSteps => 'Follow these tips for best results';

  @override
  String get gotIt => 'Got It';

  @override
  String get quickTipsForBestResults => 'Quick tips for best results';

  @override
  String get goodLightingCapture => 'Good Lighting';

  @override
  String get naturalLightWorks => 'Natural light works best';

  @override
  String get closeAndClear => 'Close & Clear';

  @override
  String get distanceAndFocus => '15-30cm from leaf, sharp focus';

  @override
  String get singleLeafCapture => 'Single Leaf';

  @override
  String get focusOnOneDiseased => 'Focus on one diseased area';

  @override
  String get continueButton => 'Continue';

  @override
  String get homeSubtitle => 'Take care of your plants';

  @override
  String get grantLocationPermission =>
      'Grant location permission to view weather details';

  @override
  String get locationDenied => 'Location permission denied';

  @override
  String get allowAccess => 'Allow Access';

  @override
  String get weatherErrorTitle => 'Error loading weather';

  @override
  String get checkWeatherPrompt => 'Check the weather in your area';

  @override
  String get clearSky => 'Clear Sky';

  @override
  String get partlyCloudy => 'Partly Cloudy';

  @override
  String get foggy => 'Foggy';

  @override
  String get drizzle => 'Drizzle';

  @override
  String get rainy => 'Rainy';

  @override
  String get snowy => 'Snowy';

  @override
  String get rainShowers => 'Rain Showers';

  @override
  String get thunderstorm => 'Thunderstorm';

  @override
  String get noDiseases => 'No diseases recorded';

  @override
  String get guestProfileTitle => 'Profile';

  @override
  String get guestJoinTitle => 'Join Plantie';

  @override
  String get guestJoinSubtitle => 'Unlock the full Plantie experience';

  @override
  String get guestBenefit1Title => 'Sync Your History';

  @override
  String get guestBenefit1Desc =>
      'Access your detection history across devices';

  @override
  String get guestBenefit2Title => 'Join the Community';

  @override
  String get guestBenefit2Desc =>
      'Like, comment, and share with other plant lovers';

  @override
  String get guestBenefit3Title => 'Help Improve Plantie';

  @override
  String get guestBenefit3Desc =>
      'Your feedback trains better disease detection for everyone';

  @override
  String get guestCreateAccount => 'Create Account';

  @override
  String get guestSignIn => 'Sign In';

  @override
  String get guestBrowsingNote =>
      'Browsing as Guest • All detections are stored locally';

  @override
  String get guestPromptTitle => 'Sign up to join';

  @override
  String get guestPromptDescription =>
      'Create an account to like, comment, and share with the Plantie community';

  @override
  String get guestPromptSignUp => 'Sign Up';

  @override
  String get guestPromptMaybeLater => 'Maybe Later';

  @override
  String get guestCommunityTitle => 'Share with the community';

  @override
  String get guestCommunityDescription =>
      'Create an account to post, like, and comment with other plant lovers';

  @override
  String get noNewNotifications => 'No new notifications';

  @override
  String get notifications => 'Notifications';

  @override
  String get createNewPost => 'Create new post';

  @override
  String get post => 'Post';

  @override
  String get latest => 'Latest';

  @override
  String get popular => 'Popular';

  @override
  String get trending => 'Trending';

  @override
  String get loadingMorePosts => 'Loading more posts...';

  @override
  String get beFirstToShare => 'Be the first to share something amazing!';

  @override
  String get searchByPostContent => 'Search by post content';

  @override
  String get noPostsMatch => 'No posts match your search';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get welcomeToPlantie => 'Welcome to Plantie!';

  @override
  String get discoverPlantCare =>
      'Discover expert plant care tips and join a community of plant lovers';

  @override
  String get getOtpCode => 'Get OTP Code';

  @override
  String get sendOtpSms => 'We\'ll send you a verification code via SMS';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get phoneHint => 'Enter phone number';

  @override
  String get invalidPhone => 'Invalid phone number';

  @override
  String get requiredField => 'This field is required';

  @override
  String get selectCountry => 'Select country';

  @override
  String get whatsYourName => 'What should we call you?';

  @override
  String get nameHint => 'Your name';

  @override
  String get letsStart => 'Let\'s Start 🌱';

  @override
  String get nameTooShort => 'Name must be at least 2 characters';

  @override
  String get lettersAndSpacesOnly => 'Letters and spaces only';

  @override
  String get noAccountNeeded => 'No account or password needed';

  @override
  String get offlineTitle => 'No Internet Connection';

  @override
  String get offlineSubtitle =>
      'Please check your network status and try refreshing.';

  @override
  String get retryButton => 'Retry';

  @override
  String get aboutMe => 'About Me';

  @override
  String get contactInfo => 'Contact Details';

  @override
  String get bioPlaceholder => 'Add a short bio to let people know you...';

  @override
  String get phonePlaceholder => 'Add phone number';

  @override
  String get countryPlaceholder => 'Add your country';

  @override
  String get nameField => 'Full Name';

  @override
  String get bioField => 'Bio';

  @override
  String get phoneField => 'Phone Number';

  @override
  String get countryField => 'Country';

  @override
  String get gallerySource => 'Choose from Gallery';

  @override
  String get cameraSource => 'Take a Photo';

  @override
  String get completeProfilePrompt => 'Complete Your Profile!';

  @override
  String get completeProfileSubtitle =>
      'Fill in your bio, location, and phone details to look official.';

  @override
  String get unsavedChangesTitle => 'Unsaved Changes';

  @override
  String get unsavedChangesMsg =>
      'You have modified details. Leaving now will discard all edits.';

  @override
  String get keepEditing => 'Keep Editing';

  @override
  String get discard => 'Discard';

  @override
  String get successTitle => 'Success';

  @override
  String get profileUpdatedMsg =>
      'Your profile information has been securely updated.';

  @override
  String get errorTitle => 'Error';

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully';

  @override
  String get saveAvatar => 'Save Avatar';

  @override
  String get plantDiagnosis => 'Plant Diagnosis';

  @override
  String get recentDiagnoses => 'Recent Diagnoses';

  @override
  String get scanPlantPrompt => 'Identify Plant Diseases';

  @override
  String get scanPlantSubPrompt =>
      'Take a photo of a leaf to get an instant diagnosis and treatment plan.';

  @override
  String get startScan => 'Start Scan';

  @override
  String get analyzing => 'Analyzing Image...';

  @override
  String get notAPlant => 'Not a Plant';

  @override
  String get viewDetails => 'View Details';

  @override
  String get scanAnother => 'Scan Another';

  @override
  String get noHistoryYet => 'No history yet';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get daysAgo => 'days ago';

  @override
  String get postedBy => 'Post by';

  @override
  String get avatar => 'avatar';

  @override
  String get showMore => 'Show more';

  @override
  String get showLess => 'Show less';

  @override
  String get likes => 'likes';

  @override
  String get comment => 'Comment';

  @override
  String get like => 'Like';

  @override
  String get writeComment => 'Write comment';

  @override
  String get likePost => 'Like post';

  @override
  String get unlikePost => 'Unlike post';

  @override
  String get postActions => 'Post actions';

  @override
  String get moreOptions => 'More options';

  @override
  String get postOptions => 'Post options';

  @override
  String get deletePost => 'Delete Post';

  @override
  String get deletePostQuestion => 'Delete Post?';

  @override
  String get deletePostConfirmation =>
      'Are you sure you want to delete this post? This action cannot be undone.';

  @override
  String get retry => 'Retry';

  @override
  String get noInternet => 'No Internet Connection';

  @override
  String get checkNetwork =>
      'Please check your network status and try refreshing.';

  @override
  String get errorLoadingPosts => 'Error loading posts';

  @override
  String get photos => 'Photos';

  @override
  String get postCreatedSuccessfully => 'Post created successfully!';

  @override
  String get userDataNotFound => 'User data not found. Please log in again.';

  @override
  String get noCommentsYet => 'No comments yet';

  @override
  String get beFirstToComment => 'Be the first to comment';

  @override
  String get postingComment => 'Posting comment...';

  @override
  String get offlineSaveError =>
      'No internet connection. Please check your network and try again.';

  @override
  String get offlineAvatarError =>
      'Cannot update avatar while offline. Please connect to the internet.';

  @override
  String get arShort => 'AR';

  @override
  String get enShort => 'EN';

  @override
  String get preferencesAndOptions => 'PREFERENCES & OPTIONS';

  @override
  String get offlineLikeError =>
      'No internet connection. Like will be saved when you\'re back online.';

  @override
  String get offlineCommentError =>
      'No internet connection. Your comment will be saved when you\'re back online.';

  @override
  String get offlineLoadMoreError =>
      'No internet connection. Cannot load more posts.';

  @override
  String get detectionTimeoutError =>
      'Analysis took too long. Please try again with a clearer image.';

  @override
  String get invalidImageError =>
      'Could not read the image. Please select a valid photo.';

  @override
  String get outOfMemoryError =>
      'Image is too large. Please use a smaller photo.';

  @override
  String get notAPlantError =>
      'The image does not appear to contain a plant leaf.';

  @override
  String get detectionGenericError => 'Something went wrong. Please try again.';

  @override
  String get noInternetConnection => 'No Internet Connection';

  @override
  String get offlinePostMessage =>
      'You are currently offline. Your post will be saved and uploaded when you regain internet connection.';

  @override
  String get ok => 'OK';

  @override
  String get commentFailed => 'Could not post comment. Please try again.';

  @override
  String get failedToLoadPlants => 'Failed to load plants';

  @override
  String get failedToLoadPlantsMessage =>
      'Unable to load plant data. Please check your internet connection and try again.';

  @override
  String get aiAssistant => 'AI Assistant';

  @override
  String get aiAssistantEmptyTitle => 'How can I help you?';

  @override
  String get aiAssistantEmptySubtitle =>
      'Ask me anything about plants, farming, or gardening.';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get clearChat => 'Clear Chat';

  @override
  String get clearChatConfirmation =>
      'Are you sure you want to clear this conversation?';

  @override
  String get clear => 'Clear';

  @override
  String get noFreeMessages => 'No free messages left.';

  @override
  String get noFreeMessagesShort => '0 free';

  @override
  String get watchAdButton => 'Watch Ad';

  @override
  String freeCount(int count) {
    return '$count free';
  }

  @override
  String rewardReceived(int count) {
    return '🎉 +1 free chat! You now have $count remaining.';
  }

  @override
  String get adFailedToShow => 'Ad failed to show. Please try again.';

  @override
  String get adNotAvailable => 'Ad not available. Please try again later.';

  @override
  String get offlineLikeMessage =>
      'You are offline. Please try again when you have a connection.';

  @override
  String get chatOfflineTitle => 'No Internet Connection';

  @override
  String get chatOfflineMessage =>
      'The AI Assistant needs an internet connection to work. Please connect and try again.';

  @override
  String get askAIAssistant => 'Ask AI Assistant';

  @override
  String get askAIAssistantSubtitle => 'Get instant farming advice';

  @override
  String get weather_permission_title => 'Weather for Your Farm';

  @override
  String get weather_permission_message =>
      'We need your location to show accurate weather and farming advice for your area.';

  @override
  String get notNow => 'Not now';

  @override
  String get allow_access => 'Allow';

  @override
  String get tapToGetWeather => 'Tap to get weather';

  @override
  String get permission_required => 'Permission Required';

  @override
  String get location_permission_denied_forever =>
      'Location permission has been permanently denied. Please enable it in your device settings to use weather features.';

  @override
  String get open_settings => 'Open Settings';
}
