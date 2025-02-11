// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome to Plantie!`
  String get onboardingTitle1 {
    return Intl.message(
      'Welcome to Plantie!',
      name: 'onboardingTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Stay updated with real-time weather and plant care advice tailored to your needs, and calculate the right amount of fertilizer for optimal plant growth.`
  String get onboardingBody1 {
    return Intl.message(
      'Stay updated with real-time weather and plant care advice tailored to your needs, and calculate the right amount of fertilizer for optimal plant growth.',
      name: 'onboardingBody1',
      desc: '',
      args: [],
    );
  }

  /// `Detect Plant Diseases`
  String get onboardingTitle2 {
    return Intl.message(
      'Detect Plant Diseases',
      name: 'onboardingTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Upload a photo of your plant to identify diseases and get expert solutions instantly.`
  String get onboardingBody2 {
    return Intl.message(
      'Upload a photo of your plant to identify diseases and get expert solutions instantly.',
      name: 'onboardingBody2',
      desc: '',
      args: [],
    );
  }

  /// `Find Nearby Plant Stores`
  String get onboardingTitle3 {
    return Intl.message(
      'Find Nearby Plant Stores',
      name: 'onboardingTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Easily locate nearby plant stores with just a tap, helping you take better care of your plants.`
  String get onboardingBody3 {
    return Intl.message(
      'Easily locate nearby plant stores with just a tap, helping you take better care of your plants.',
      name: 'onboardingBody3',
      desc: '',
      args: [],
    );
  }

  /// `Join the Plantie Community`
  String get onboardingTitle4 {
    return Intl.message(
      'Join the Plantie Community',
      name: 'onboardingTitle4',
      desc: '',
      args: [],
    );
  }

  /// `Connect with fellow plant lovers, share tips, and learn from each other to grow your green space together.`
  String get onboardingBody4 {
    return Intl.message(
      'Connect with fellow plant lovers, share tips, and learn from each other to grow your green space together.',
      name: 'onboardingBody4',
      desc: '',
      args: [],
    );
  }

  /// `SKIP`
  String get skip {
    return Intl.message('SKIP', name: 'skip', desc: '', args: []);
  }

  /// `Plantie`
  String get welcome_title {
    return Intl.message('Plantie', name: 'welcome_title', desc: '', args: []);
  }

  /// `Get more crops with Plantie's help!`
  String get welcome_subtitle {
    return Intl.message(
      'Get more crops with Plantie\'s help!',
      name: 'welcome_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login_button {
    return Intl.message('Login', name: 'login_button', desc: '', args: []);
  }

  /// `Register`
  String get register_button {
    return Intl.message(
      'Register',
      name: 'register_button',
      desc: '',
      args: [],
    );
  }

  /// `By logging in or registering, you agree to our Terms of Service and Privacy Policy`
  String get terms_and_conditions {
    return Intl.message(
      'By logging in or registering, you agree to our Terms of Service and Privacy Policy',
      name: 'terms_and_conditions',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message('Welcome', name: 'welcome', desc: '', args: []);
  }

  /// `Hello, Welcome back to Plantie!`
  String get welcome_back {
    return Intl.message(
      'Hello, Welcome back to Plantie!',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get email_address {
    return Intl.message(
      'Email Address',
      name: 'email_address',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email address`
  String get enter_email {
    return Intl.message(
      'Please enter your email address',
      name: 'enter_email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Password is too short`
  String get enter_password {
    return Intl.message(
      'Password is too short',
      name: 'enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password?`
  String get forget_password {
    return Intl.message(
      'Forget Password?',
      name: 'forget_password',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Create account?`
  String get create_account {
    return Intl.message(
      'Create account?',
      name: 'create_account',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `or login by`
  String get or_login_by {
    return Intl.message('or login by', name: 'or_login_by', desc: '', args: []);
  }

  /// `Reset Password`
  String get reset_password {
    return Intl.message(
      'Reset Password',
      name: 'reset_password',
      desc: '',
      args: [],
    );
  }

  /// `we sent to your email url to use it to reset the password`
  String get sent_email_to_update_paassword {
    return Intl.message(
      'we sent to your email url to use it to reset the password',
      name: 'sent_email_to_update_paassword',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Create Account`
  String get creat_account2 {
    return Intl.message(
      'Create Account',
      name: 'creat_account2',
      desc: '',
      args: [],
    );
  }

  /// `Complete your information to get started!`
  String get create_account3 {
    return Intl.message(
      'Complete your information to get started!',
      name: 'create_account3',
      desc: '',
      args: [],
    );
  }

  /// `please enter a user name`
  String get enter_name {
    return Intl.message(
      'please enter a user name',
      name: 'enter_name',
      desc: '',
      args: [],
    );
  }

  /// `please enter a valid email`
  String get email_valid {
    return Intl.message(
      'please enter a valid email',
      name: 'email_valid',
      desc: '',
      args: [],
    );
  }

  /// `or register by`
  String get or_register_by {
    return Intl.message(
      'or register by',
      name: 'or_register_by',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? `
  String get have_account {
    return Intl.message(
      'Already have an account? ',
      name: 'have_account',
      desc: '',
      args: [],
    );
  }

  /// `Weather`
  String get weather {
    return Intl.message('Weather', name: 'weather', desc: '', args: []);
  }

  /// `Choose a Plant`
  String get choosePlant {
    return Intl.message(
      'Choose a Plant',
      name: 'choosePlant',
      desc: '',
      args: [],
    );
  }

  /// `Calculate Fertilizer`
  String get calculateFertilizer {
    return Intl.message(
      'Calculate Fertilizer',
      name: 'calculateFertilizer',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Nutrition`
  String get nutrition {
    return Intl.message('Nutrition', name: 'nutrition', desc: '', args: []);
  }

  /// `Storage`
  String get storage {
    return Intl.message('Storage', name: 'storage', desc: '', args: []);
  }

  /// `Diseases`
  String get diseases {
    return Intl.message('Diseases', name: 'diseases', desc: '', args: []);
  }

  /// `Planting Time`
  String get plantingTime {
    return Intl.message(
      'Planting Time',
      name: 'plantingTime',
      desc: '',
      args: [],
    );
  }

  /// `NPK Formula`
  String get npkFormula {
    return Intl.message('NPK Formula', name: 'npkFormula', desc: '', args: []);
  }

  /// `Temperature`
  String get temperature {
    return Intl.message('Temperature', name: 'temperature', desc: '', args: []);
  }

  /// `Humidity`
  String get humidity {
    return Intl.message('Humidity', name: 'humidity', desc: '', args: []);
  }

  /// `Prevention`
  String get prevention {
    return Intl.message('Prevention', name: 'prevention', desc: '', args: []);
  }

  /// `Fetching weather...`
  String get fetchingWeather {
    return Intl.message(
      'Fetching weather...',
      name: 'fetchingWeather',
      desc: '',
      args: [],
    );
  }

  /// `Location permission required`
  String get locationRequired {
    return Intl.message(
      'Location permission required',
      name: 'locationRequired',
      desc: '',
      args: [],
    );
  }

  /// `Enable Location`
  String get enableLocation {
    return Intl.message(
      'Enable Location',
      name: 'enableLocation',
      desc: '',
      args: [],
    );
  }

  /// `Location permissions permanently denied. Please enable in settings.`
  String get permanentDenial {
    return Intl.message(
      'Location permissions permanently denied. Please enable in settings.',
      name: 'permanentDenial',
      desc: '',
      args: [],
    );
  }

  /// `Open Settings`
  String get openSettings {
    return Intl.message(
      'Open Settings',
      name: 'openSettings',
      desc: '',
      args: [],
    );
  }

  /// `Location services disabled. Please enable GPS.`
  String get gpsDisabled {
    return Intl.message(
      'Location services disabled. Please enable GPS.',
      name: 'gpsDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Enable GPS`
  String get enableGPS {
    return Intl.message('Enable GPS', name: 'enableGPS', desc: '', args: []);
  }

  /// `Error fetching weather: {error}`
  String weatherError(Object error) {
    return Intl.message(
      'Error fetching weather: $error',
      name: 'weatherError',
      desc: '',
      args: [error],
    );
  }

  /// `Try Again`
  String get tryAgain {
    return Intl.message('Try Again', name: 'tryAgain', desc: '', args: []);
  }

  /// `Get Weather`
  String get getWeather {
    return Intl.message('Get Weather', name: 'getWeather', desc: '', args: []);
  }

  /// `Feels like {temp}°C`
  String feelsLike(Object temp) {
    return Intl.message(
      'Feels like $temp°C',
      name: 'feelsLike',
      desc: '',
      args: [temp],
    );
  }

  /// `Weather Details`
  String get weather_details {
    return Intl.message(
      'Weather Details',
      name: 'weather_details',
      desc: '',
      args: [],
    );
  }

  /// `Current Weather`
  String get current_weather {
    return Intl.message(
      'Current Weather',
      name: 'current_weather',
      desc: '',
      args: [],
    );
  }

  /// `Feels Like`
  String get feels_like {
    return Intl.message('Feels Like', name: 'feels_like', desc: '', args: []);
  }

  /// `Wind Speed`
  String get wind_speed {
    return Intl.message('Wind Speed', name: 'wind_speed', desc: '', args: []);
  }

  /// `Pressure`
  String get pressure {
    return Intl.message('Pressure', name: 'pressure', desc: '', args: []);
  }

  /// `Sunrise`
  String get sunrise {
    return Intl.message('Sunrise', name: 'sunrise', desc: '', args: []);
  }

  /// `Sunset`
  String get sunset {
    return Intl.message('Sunset', name: 'sunset', desc: '', args: []);
  }

  /// `{emoji} {name} Fertilizer`
  String fertilizerCalculator(Object emoji, Object name) {
    return Intl.message(
      '$emoji $name Fertilizer',
      name: 'fertilizerCalculator',
      desc: '',
      args: [emoji, name],
    );
  }

  /// `Type: {type}`
  String plantType(Object type) {
    return Intl.message(
      'Type: $type',
      name: 'plantType',
      desc: '',
      args: [type],
    );
  }

  /// `Land Area ({unit}):`
  String landArea(Object unit) {
    return Intl.message(
      'Land Area ($unit):',
      name: 'landArea',
      desc: '',
      args: [unit],
    );
  }

  /// `Number of Trees`
  String get numberOfTrees {
    return Intl.message(
      'Number of Trees',
      name: 'numberOfTrees',
      desc: '',
      args: [],
    );
  }

  /// `Tree Age (Years)`
  String get treeAge {
    return Intl.message(
      'Tree Age (Years)',
      name: 'treeAge',
      desc: '',
      args: [],
    );
  }

  /// `Recommended NPK Ratio:`
  String get recommendedNpk {
    return Intl.message(
      'Recommended NPK Ratio:',
      name: 'recommendedNpk',
      desc: '',
      args: [],
    );
  }

  /// `Calculate Requirements`
  String get calculateRequirements {
    return Intl.message(
      'Calculate Requirements',
      name: 'calculateRequirements',
      desc: '',
      args: [],
    );
  }

  /// `Required Fertilizers ({calculationContext}):`
  String requiredFertilizers(Object calculationContext) {
    return Intl.message(
      'Required Fertilizers ($calculationContext):',
      name: 'requiredFertilizers',
      desc: '',
      args: [calculationContext],
    );
  }

  /// `Note: Calculations include age factor for {age} year old trees`
  String treeNote(Object age) {
    return Intl.message(
      'Note: Calculations include age factor for $age year old trees',
      name: 'treeNote',
      desc: '',
      args: [age],
    );
  }

  /// `Note: 1 Dunam = 1000 m² (10,000 sq ft)`
  String get areaNote {
    return Intl.message(
      'Note: 1 Dunam = 1000 m² (10,000 sq ft)',
      name: 'areaNote',
      desc: '',
      args: [],
    );
  }

  /// `Nitrogen`
  String get nitrogen {
    return Intl.message('Nitrogen', name: 'nitrogen', desc: '', args: []);
  }

  /// `Phosphorus`
  String get phosphorus {
    return Intl.message('Phosphorus', name: 'phosphorus', desc: '', args: []);
  }

  /// `Potassium`
  String get potassium {
    return Intl.message('Potassium', name: 'potassium', desc: '', args: []);
  }

  /// `Dunam`
  String get dunam {
    return Intl.message('Dunam', name: 'dunam', desc: '', args: []);
  }

  /// `Acre`
  String get acre {
    return Intl.message('Acre', name: 'acre', desc: '', args: []);
  }

  /// `Unit:`
  String get unit {
    return Intl.message('Unit:', name: 'unit', desc: '', args: []);
  }

  /// `UREA`
  String get urea {
    return Intl.message('UREA', name: 'urea', desc: '', args: []);
  }

  /// `SSP`
  String get ssp {
    return Intl.message('SSP', name: 'ssp', desc: '', args: []);
  }

  /// `MOP`
  String get mop {
    return Intl.message('MOP', name: 'mop', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message('Dark Mode', name: 'darkMode', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Confirm Logout`
  String get confirmLogout {
    return Intl.message(
      'Confirm Logout',
      name: 'confirmLogout',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get logoutMessage {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'logoutMessage',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Bio`
  String get bio {
    return Intl.message('Bio', name: 'bio', desc: '', args: []);
  }

  /// `Country`
  String get country {
    return Intl.message('Country', name: 'country', desc: '', args: []);
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Name must not be empty`
  String get nameRequired {
    return Intl.message(
      'Name must not be empty',
      name: 'nameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Bio must not be empty`
  String get bioRequired {
    return Intl.message(
      'Bio must not be empty',
      name: 'bioRequired',
      desc: '',
      args: [],
    );
  }

  /// `Country must not be empty`
  String get countryRequired {
    return Intl.message(
      'Country must not be empty',
      name: 'countryRequired',
      desc: '',
      args: [],
    );
  }

  /// `Phone must not be empty`
  String get phoneRequired {
    return Intl.message(
      'Phone must not be empty',
      name: 'phoneRequired',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated successfully`
  String get profileUpdated {
    return Intl.message(
      'Profile updated successfully',
      name: 'profileUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Update failed: {error}`
  String updateFailed(Object error) {
    return Intl.message(
      'Update failed: $error',
      name: 'updateFailed',
      desc: '',
      args: [error],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Community`
  String get community {
    return Intl.message('Community', name: 'community', desc: '', args: []);
  }

  /// `Detection`
  String get detection {
    return Intl.message('Detection', name: 'detection', desc: '', args: []);
  }

  /// `Profile`
  String get profile2 {
    return Intl.message('Profile', name: 'profile2', desc: '', args: []);
  }

  /// `Verification email resent. Please check your inbox.`
  String get verificationSent {
    return Intl.message(
      'Verification email resent. Please check your inbox.',
      name: 'verificationSent',
      desc: '',
      args: [],
    );
  }

  /// `Error sending verification: {error}`
  String verificationError(Object error) {
    return Intl.message(
      'Error sending verification: $error',
      name: 'verificationError',
      desc: '',
      args: [error],
    );
  }

  /// `Detection Results`
  String get detectionResults {
    return Intl.message(
      'Detection Results',
      name: 'detectionResults',
      desc: '',
      args: [],
    );
  }

  /// `Detection Result`
  String get detectionResult {
    return Intl.message(
      'Detection Result',
      name: 'detectionResult',
      desc: '',
      args: [],
    );
  }

  /// `Recommended Treatment`
  String get recommendedTreatment {
    return Intl.message(
      'Recommended Treatment',
      name: 'recommendedTreatment',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `No Detection History`
  String get noDetectionHistory {
    return Intl.message(
      'No Detection History',
      name: 'noDetectionHistory',
      desc: '',
      args: [],
    );
  }

  /// `Your plant health scans will appear here`
  String get historyPlaceholder {
    return Intl.message(
      'Your plant health scans will appear here',
      name: 'historyPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Delete`
  String get confirmDelete {
    return Intl.message(
      'Confirm Delete',
      name: 'confirmDelete',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this item?`
  String get deleteConfirmation {
    return Intl.message(
      'Are you sure you want to delete this item?',
      name: 'deleteConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `{treatment}`
  String treatmentLabel(Object treatment) {
    return Intl.message(
      '$treatment',
      name: 'treatmentLabel',
      desc: '',
      args: [treatment],
    );
  }

  /// `Treatment`
  String get treatment {
    return Intl.message('Treatment', name: 'treatment', desc: '', args: []);
  }

  /// `Tips`
  String get tips {
    return Intl.message('Tips', name: 'tips', desc: '', args: []);
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Nearest Plant Nursery`
  String get nearestNursery {
    return Intl.message(
      'Nearest Plant Nursery',
      name: 'nearestNursery',
      desc: '',
      args: [],
    );
  }

  /// `No nearby stores found`
  String get noStoresFound {
    return Intl.message(
      'No nearby stores found',
      name: 'noStoresFound',
      desc: '',
      args: [],
    );
  }

  /// `Error: {error}`
  String locationError(Object error) {
    return Intl.message(
      'Error: $error',
      name: 'locationError',
      desc: '',
      args: [error],
    );
  }

  /// `Could not launch maps`
  String get launchError {
    return Intl.message(
      'Could not launch maps',
      name: 'launchError',
      desc: '',
      args: [],
    );
  }

  /// `Tap the camera button below\nto start scanning your plants`
  String get tap_camera_to_scan {
    return Intl.message(
      'Tap the camera button below\nto start scanning your plants',
      name: 'tap_camera_to_scan',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
