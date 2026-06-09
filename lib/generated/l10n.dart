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
    final name = (locale.countryCode?.isEmpty ?? false)
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

  /// `Farming Insights`
  String get farming_insights {
    return Intl.message(
      'Farming Insights',
      name: 'farming_insights',
      desc: '',
      args: [],
    );
  }

  /// `Hourly Forecast`
  String get hourly_forecast {
    return Intl.message(
      'Hourly Forecast',
      name: 'hourly_forecast',
      desc: '',
      args: [],
    );
  }

  /// `7-Day Forecast`
  String get daily_forecast {
    return Intl.message(
      '7-Day Forecast',
      name: 'daily_forecast',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `Soil Temperature`
  String get soil_temp {
    return Intl.message(
      'Soil Temperature',
      name: 'soil_temp',
      desc: '',
      args: [],
    );
  }

  /// `Evapotranspiration`
  String get evapotranspiration {
    return Intl.message(
      'Evapotranspiration',
      name: 'evapotranspiration',
      desc: '',
      args: [],
    );
  }

  /// `Precipitation`
  String get precipitation {
    return Intl.message(
      'Precipitation',
      name: 'precipitation',
      desc: '',
      args: [],
    );
  }

  /// `Humidity`
  String get humidity_level {
    return Intl.message('Humidity', name: 'humidity_level', desc: '', args: []);
  }

  /// `No specific alerts for today.`
  String get no_insights {
    return Intl.message(
      'No specific alerts for today.',
      name: 'no_insights',
      desc: '',
      args: [],
    );
  }

  /// `Good conditions for farming activities.`
  String get good_for_farming {
    return Intl.message(
      'Good conditions for farming activities.',
      name: 'good_for_farming',
      desc: '',
      args: [],
    );
  }

  /// `Use caution with some farming activities.`
  String get warning_farming {
    return Intl.message(
      'Use caution with some farming activities.',
      name: 'warning_farming',
      desc: '',
      args: [],
    );
  }

  /// `High risk! Take immediate action to protect crops.`
  String get critical_farming {
    return Intl.message(
      'High risk! Take immediate action to protect crops.',
      name: 'critical_farming',
      desc: '',
      args: [],
    );
  }

  /// `Recommendation`
  String get recommendation {
    return Intl.message(
      'Recommendation',
      name: 'recommendation',
      desc: '',
      args: [],
    );
  }

  /// `Weather Trends`
  String get weather_trends {
    return Intl.message(
      'Weather Trends',
      name: 'weather_trends',
      desc: '',
      args: [],
    );
  }

  /// `Temperature`
  String get temperature_chart {
    return Intl.message(
      'Temperature',
      name: 'temperature_chart',
      desc: '',
      args: [],
    );
  }

  /// `Precipitation`
  String get precipitation_chart {
    return Intl.message(
      'Precipitation',
      name: 'precipitation_chart',
      desc: '',
      args: [],
    );
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

  /// `Log Out`
  String get logout {
    return Intl.message('Log Out', name: 'logout', desc: '', args: []);
  }

  /// `Confirm Sign Out`
  String get confirmLogout {
    return Intl.message(
      'Confirm Sign Out',
      name: 'confirmLogout',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out of your account?`
  String get logoutMessage {
    return Intl.message(
      'Are you sure you want to log out of your account?',
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

  /// `Name cannot be left empty`
  String get nameRequired {
    return Intl.message(
      'Name cannot be left empty',
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

  /// `Name`
  String get namefield {
    return Intl.message('Name', name: 'namefield', desc: '', args: []);
  }

  /// `Phone (optional)`
  String get phoneOptional {
    return Intl.message(
      'Phone (optional)',
      name: 'phoneOptional',
      desc: '',
      args: [],
    );
  }

  /// `Bio (optional)`
  String get bioOptional {
    return Intl.message(
      'Bio (optional)',
      name: 'bioOptional',
      desc: '',
      args: [],
    );
  }

  /// `Country (optional)`
  String get countryOptional {
    return Intl.message(
      'Country (optional)',
      name: 'countryOptional',
      desc: '',
      args: [],
    );
  }

  /// `Tell other farmers about yourself...`
  String get bioHint {
    return Intl.message(
      'Tell other farmers about yourself...',
      name: 'bioHint',
      desc: '',
      args: [],
    );
  }

  /// `{current}/{max}`
  String bioCharCount(Object current, Object max) {
    return Intl.message(
      '$current/$max',
      name: 'bioCharCount',
      desc: '',
      args: [current, max],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Are you sure you want to logout?`
  String get logoutConfirm {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'logoutConfirm',
      desc: '',
      args: [],
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

  /// `Search posts`
  String get searchPosts {
    return Intl.message(
      'Search posts',
      name: 'searchPosts',
      desc: '',
      args: [],
    );
  }

  /// `New Post`
  String get newPost {
    return Intl.message('New Post', name: 'newPost', desc: '', args: []);
  }

  /// `Comments`
  String get comments {
    return Intl.message('Comments', name: 'comments', desc: '', args: []);
  }

  /// `Write a comment...`
  String get write_comment {
    return Intl.message(
      'Write a comment...',
      name: 'write_comment',
      desc: '',
      args: [],
    );
  }

  /// `No posts`
  String get no_posts {
    return Intl.message('No posts', name: 'no_posts', desc: '', args: []);
  }

  /// `Create Post`
  String get createPost {
    return Intl.message('Create Post', name: 'createPost', desc: '', args: []);
  }

  /// `Post`
  String get postButton {
    return Intl.message('Post', name: 'postButton', desc: '', args: []);
  }

  /// `What's on your mind?`
  String get whatsOnMind {
    return Intl.message(
      'What\'s on your mind?',
      name: 'whatsOnMind',
      desc: '',
      args: [],
    );
  }

  /// `Add Photos`
  String get addPhotos {
    return Intl.message('Add Photos', name: 'addPhotos', desc: '', args: []);
  }

  /// `Positioning Tips`
  String get positioningTips {
    return Intl.message(
      'Positioning Tips',
      name: 'positioningTips',
      desc: '',
      args: [],
    );
  }

  /// `Capture in good natural lighting`
  String get positioningTip1 {
    return Intl.message(
      'Capture in good natural lighting',
      name: 'positioningTip1',
      desc: '',
      args: [],
    );
  }

  /// `Fill frame with the leaf`
  String get positioningTip2 {
    return Intl.message(
      'Fill frame with the leaf',
      name: 'positioningTip2',
      desc: '',
      args: [],
    );
  }

  /// `Avoid shadows on the subject`
  String get positioningTip3 {
    return Intl.message(
      'Avoid shadows on the subject',
      name: 'positioningTip3',
      desc: '',
      args: [],
    );
  }

  /// `Focus Requirements`
  String get focusRequirements {
    return Intl.message(
      'Focus Requirements',
      name: 'focusRequirements',
      desc: '',
      args: [],
    );
  }

  /// `Ensure leaf edges are clear`
  String get focusTip1 {
    return Intl.message(
      'Ensure leaf edges are clear',
      name: 'focusTip1',
      desc: '',
      args: [],
    );
  }

  /// `Focus on affected areas`
  String get focusTip2 {
    return Intl.message(
      'Focus on affected areas',
      name: 'focusTip2',
      desc: '',
      args: [],
    );
  }

  /// `Keep camera steady`
  String get focusTip3 {
    return Intl.message(
      'Keep camera steady',
      name: 'focusTip3',
      desc: '',
      args: [],
    );
  }

  /// `Background Tips`
  String get backgroundTips {
    return Intl.message(
      'Background Tips',
      name: 'backgroundTips',
      desc: '',
      args: [],
    );
  }

  /// `Use plain background`
  String get backgroundTip1 {
    return Intl.message(
      'Use plain background',
      name: 'backgroundTip1',
      desc: '',
      args: [],
    );
  }

  /// `White/light colors preferred`
  String get backgroundTip2 {
    return Intl.message(
      'White/light colors preferred',
      name: 'backgroundTip2',
      desc: '',
      args: [],
    );
  }

  /// `Avoid busy patterns`
  String get backgroundTip3 {
    return Intl.message(
      'Avoid busy patterns',
      name: 'backgroundTip3',
      desc: '',
      args: [],
    );
  }

  /// `Capture Guidelines`
  String get captureGuidelines {
    return Intl.message(
      'Capture Guidelines',
      name: 'captureGuidelines',
      desc: '',
      args: [],
    );
  }

  /// `I Understand - Continue`
  String get iUnderstand {
    return Intl.message(
      'I Understand - Continue',
      name: 'iUnderstand',
      desc: '',
      args: [],
    );
  }

  /// `Take Photo`
  String get takePhoto {
    return Intl.message('Take Photo', name: 'takePhoto', desc: '', args: []);
  }

  /// `Choose from Gallery`
  String get chooseFromGallery {
    return Intl.message(
      'Choose from Gallery',
      name: 'chooseFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred: {error}`
  String errorOccurred(Object error) {
    return Intl.message(
      'An error occurred: $error',
      name: 'errorOccurred',
      desc: '',
      args: [error],
    );
  }

  /// `Unknown`
  String get unknownDisease {
    return Intl.message('Unknown', name: 'unknownDisease', desc: '', args: []);
  }

  /// ``
  String get noDetails {
    return Intl.message('', name: 'noDetails', desc: '', args: []);
  }

  /// `Disease not recognized`
  String get diseaseNotDetected {
    return Intl.message(
      'Disease not recognized',
      name: 'diseaseNotDetected',
      desc: '',
      args: [],
    );
  }

  /// `Good`
  String get good {
    return Intl.message('Good', name: 'good', desc: '', args: []);
  }

  /// `Avoid`
  String get avoid {
    return Intl.message('Avoid', name: 'avoid', desc: '', args: []);
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Language changed. Restart the app?`
  String get languageChanged {
    return Intl.message(
      'Language changed. Restart the app?',
      name: 'languageChanged',
      desc: '',
      args: [],
    );
  }

  /// `Irrigation Alert`
  String get irrigation_alert {
    return Intl.message(
      'Irrigation Alert',
      name: 'irrigation_alert',
      desc: '',
      args: [],
    );
  }

  /// `Significant rain detected ({value} mm). Do not irrigate today to prevent waterlogging.`
  String irrigation_message(Object value) {
    return Intl.message(
      'Significant rain detected ($value mm). Do not irrigate today to prevent waterlogging.',
      name: 'irrigation_message',
      desc: '',
      args: [value],
    );
  }

  /// `Wind Warning`
  String get wind_warning {
    return Intl.message(
      'Wind Warning',
      name: 'wind_warning',
      desc: '',
      args: [],
    );
  }

  /// `High wind speeds ({value} km/h). Avoid spraying pesticides as they may drift.`
  String wind_message(Object value) {
    return Intl.message(
      'High wind speeds ($value km/h). Avoid spraying pesticides as they may drift.',
      name: 'wind_message',
      desc: '',
      args: [value],
    );
  }

  /// `Ideal Spraying`
  String get ideal_spraying {
    return Intl.message(
      'Ideal Spraying',
      name: 'ideal_spraying',
      desc: '',
      args: [],
    );
  }

  /// `Wind conditions are calm. Good time for pest control application.`
  String get ideal_spraying_message {
    return Intl.message(
      'Wind conditions are calm. Good time for pest control application.',
      name: 'ideal_spraying_message',
      desc: '',
      args: [],
    );
  }

  /// `Frost Risk`
  String get frost_risk {
    return Intl.message('Frost Risk', name: 'frost_risk', desc: '', args: []);
  }

  /// `Temperature is low ({value}°C). High risk of frost damage. Protect sensitive crops.`
  String frost_message(Object value) {
    return Intl.message(
      'Temperature is low ($value°C). High risk of frost damage. Protect sensitive crops.',
      name: 'frost_message',
      desc: '',
      args: [value],
    );
  }

  /// `High Evaporation`
  String get high_evaporation {
    return Intl.message(
      'High Evaporation',
      name: 'high_evaporation',
      desc: '',
      args: [],
    );
  }

  /// `High evapotranspiration rate ({value} mm). Consider increasing irrigation frequency.`
  String high_evaporation_message(Object value) {
    return Intl.message(
      'High evapotranspiration rate ($value mm). Consider increasing irrigation frequency.',
      name: 'high_evaporation_message',
      desc: '',
      args: [value],
    );
  }

  /// `Soil Condition`
  String get soil_condition {
    return Intl.message(
      'Soil Condition',
      name: 'soil_condition',
      desc: '',
      args: [],
    );
  }

  /// `Soil temperature is {value}°C, ideal for most seed germination.`
  String soil_condition_message(Object value) {
    return Intl.message(
      'Soil temperature is $value°C, ideal for most seed germination.',
      name: 'soil_condition_message',
      desc: '',
      args: [value],
    );
  }

  /// `Analyzing Image...`
  String get analyzingImage {
    return Intl.message(
      'Analyzing Image...',
      name: 'analyzingImage',
      desc: '',
      args: [],
    );
  }

  /// `Please wait while AI detects...`
  String get pleaseWait {
    return Intl.message(
      'Please wait while AI detects...',
      name: 'pleaseWait',
      desc: '',
      args: [],
    );
  }

  /// `Expert Advice`
  String get expertAdvice {
    return Intl.message(
      'Expert Advice',
      name: 'expertAdvice',
      desc: '',
      args: [],
    );
  }

  /// `Find Nearest Store`
  String get findNearestStore {
    return Intl.message(
      'Find Nearest Store',
      name: 'findNearestStore',
      desc: '',
      args: [],
    );
  }

  /// `Tips for Accurate Detection`
  String get tipsForAccurateDetection {
    return Intl.message(
      'Tips for Accurate Detection',
      name: 'tipsForAccurateDetection',
      desc: '',
      args: [],
    );
  }

  /// `Healthy`
  String get healthy {
    return Intl.message('Healthy', name: 'healthy', desc: '', args: []);
  }

  /// `Disease Detected`
  String get diseaseDetected {
    return Intl.message(
      'Disease Detected',
      name: 'diseaseDetected',
      desc: '',
      args: [],
    );
  }

  /// `Good lighting`
  String get goodLighting {
    return Intl.message(
      'Good lighting',
      name: 'goodLighting',
      desc: '',
      args: [],
    );
  }

  /// `Natural sunlight works best`
  String get naturalSunlightWorks {
    return Intl.message(
      'Natural sunlight works best',
      name: 'naturalSunlightWorks',
      desc: '',
      args: [],
    );
  }

  /// `Close focus`
  String get closeFocus {
    return Intl.message('Close focus', name: 'closeFocus', desc: '', args: []);
  }

  /// `Get 15-30cm from the leaf`
  String get distanceFromLeaf {
    return Intl.message(
      'Get 15-30cm from the leaf',
      name: 'distanceFromLeaf',
      desc: '',
      args: [],
    );
  }

  /// `Clear image`
  String get clearImage {
    return Intl.message('Clear image', name: 'clearImage', desc: '', args: []);
  }

  /// `Avoid blurred or tilted photos`
  String get avoidBlurred {
    return Intl.message(
      'Avoid blurred or tilted photos',
      name: 'avoidBlurred',
      desc: '',
      args: [],
    );
  }

  /// `Single leaf`
  String get singleLeaf {
    return Intl.message('Single leaf', name: 'singleLeaf', desc: '', args: []);
  }

  /// `Focus on one diseased leaf`
  String get focusOnDiseased {
    return Intl.message(
      'Focus on one diseased leaf',
      name: 'focusOnDiseased',
      desc: '',
      args: [],
    );
  }

  /// `Item deleted successfully`
  String get deletedSuccessfully {
    return Intl.message(
      'Item deleted successfully',
      name: 'deletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Your scan has been removed`
  String get itemDeleted {
    return Intl.message(
      'Your scan has been removed',
      name: 'itemDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Start Detection`
  String get startDetection {
    return Intl.message(
      'Start Detection',
      name: 'startDetection',
      desc: '',
      args: [],
    );
  }

  /// `Tap the camera button to capture a plant image and start the diagnosis`
  String get tapCameraToDetect {
    return Intl.message(
      'Tap the camera button to capture a plant image and start the diagnosis',
      name: 'tapCameraToDetect',
      desc: '',
      args: [],
    );
  }

  /// `Tap Camera`
  String get tapCamera {
    return Intl.message('Tap Camera', name: 'tapCamera', desc: '', args: []);
  }

  /// `Follow these tips for best results`
  String get followTheseSteps {
    return Intl.message(
      'Follow these tips for best results',
      name: 'followTheseSteps',
      desc: '',
      args: [],
    );
  }

  /// `Got It`
  String get gotIt {
    return Intl.message('Got It', name: 'gotIt', desc: '', args: []);
  }

  /// `Quick tips for best results`
  String get quickTipsForBestResults {
    return Intl.message(
      'Quick tips for best results',
      name: 'quickTipsForBestResults',
      desc: '',
      args: [],
    );
  }

  /// `Good Lighting`
  String get goodLightingCapture {
    return Intl.message(
      'Good Lighting',
      name: 'goodLightingCapture',
      desc: '',
      args: [],
    );
  }

  /// `Natural light works best`
  String get naturalLightWorks {
    return Intl.message(
      'Natural light works best',
      name: 'naturalLightWorks',
      desc: '',
      args: [],
    );
  }

  /// `Close & Clear`
  String get closeAndClear {
    return Intl.message(
      'Close & Clear',
      name: 'closeAndClear',
      desc: '',
      args: [],
    );
  }

  /// `15-30cm from leaf, sharp focus`
  String get distanceAndFocus {
    return Intl.message(
      '15-30cm from leaf, sharp focus',
      name: 'distanceAndFocus',
      desc: '',
      args: [],
    );
  }

  /// `Single Leaf`
  String get singleLeafCapture {
    return Intl.message(
      'Single Leaf',
      name: 'singleLeafCapture',
      desc: '',
      args: [],
    );
  }

  /// `Focus on one diseased area`
  String get focusOnOneDiseased {
    return Intl.message(
      'Focus on one diseased area',
      name: 'focusOnOneDiseased',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueButton {
    return Intl.message('Continue', name: 'continueButton', desc: '', args: []);
  }

  /// `Take care of your plants`
  String get homeSubtitle {
    return Intl.message(
      'Take care of your plants',
      name: 'homeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Grant location permission to view weather details`
  String get grantLocationPermission {
    return Intl.message(
      'Grant location permission to view weather details',
      name: 'grantLocationPermission',
      desc: '',
      args: [],
    );
  }

  /// `Location permission denied`
  String get locationDenied {
    return Intl.message(
      'Location permission denied',
      name: 'locationDenied',
      desc: '',
      args: [],
    );
  }

  /// `Allow Access`
  String get allowAccess {
    return Intl.message(
      'Allow Access',
      name: 'allowAccess',
      desc: '',
      args: [],
    );
  }

  /// `Error loading weather`
  String get weatherErrorTitle {
    return Intl.message(
      'Error loading weather',
      name: 'weatherErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Check the weather in your area`
  String get checkWeatherPrompt {
    return Intl.message(
      'Check the weather in your area',
      name: 'checkWeatherPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Clear Sky`
  String get clearSky {
    return Intl.message('Clear Sky', name: 'clearSky', desc: '', args: []);
  }

  /// `Partly Cloudy`
  String get partlyCloudy {
    return Intl.message(
      'Partly Cloudy',
      name: 'partlyCloudy',
      desc: '',
      args: [],
    );
  }

  /// `Foggy`
  String get foggy {
    return Intl.message('Foggy', name: 'foggy', desc: '', args: []);
  }

  /// `Drizzle`
  String get drizzle {
    return Intl.message('Drizzle', name: 'drizzle', desc: '', args: []);
  }

  /// `Rainy`
  String get rainy {
    return Intl.message('Rainy', name: 'rainy', desc: '', args: []);
  }

  /// `Snowy`
  String get snowy {
    return Intl.message('Snowy', name: 'snowy', desc: '', args: []);
  }

  /// `Rain Showers`
  String get rainShowers {
    return Intl.message(
      'Rain Showers',
      name: 'rainShowers',
      desc: '',
      args: [],
    );
  }

  /// `Thunderstorm`
  String get thunderstorm {
    return Intl.message(
      'Thunderstorm',
      name: 'thunderstorm',
      desc: '',
      args: [],
    );
  }

  /// `No diseases recorded`
  String get noDiseases {
    return Intl.message(
      'No diseases recorded',
      name: 'noDiseases',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get guestProfileTitle {
    return Intl.message(
      'Profile',
      name: 'guestProfileTitle',
      desc: '',
      args: [],
    );
  }

  /// `Join Plantie`
  String get guestJoinTitle {
    return Intl.message(
      'Join Plantie',
      name: 'guestJoinTitle',
      desc: '',
      args: [],
    );
  }

  /// `Unlock the full Plantie experience`
  String get guestJoinSubtitle {
    return Intl.message(
      'Unlock the full Plantie experience',
      name: 'guestJoinSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Sync Your History`
  String get guestBenefit1Title {
    return Intl.message(
      'Sync Your History',
      name: 'guestBenefit1Title',
      desc: '',
      args: [],
    );
  }

  /// `Access your detection history across devices`
  String get guestBenefit1Desc {
    return Intl.message(
      'Access your detection history across devices',
      name: 'guestBenefit1Desc',
      desc: '',
      args: [],
    );
  }

  /// `Join the Community`
  String get guestBenefit2Title {
    return Intl.message(
      'Join the Community',
      name: 'guestBenefit2Title',
      desc: '',
      args: [],
    );
  }

  /// `Like, comment, and share with other plant lovers`
  String get guestBenefit2Desc {
    return Intl.message(
      'Like, comment, and share with other plant lovers',
      name: 'guestBenefit2Desc',
      desc: '',
      args: [],
    );
  }

  /// `Help Improve Plantie`
  String get guestBenefit3Title {
    return Intl.message(
      'Help Improve Plantie',
      name: 'guestBenefit3Title',
      desc: '',
      args: [],
    );
  }

  /// `Your feedback trains better disease detection for everyone`
  String get guestBenefit3Desc {
    return Intl.message(
      'Your feedback trains better disease detection for everyone',
      name: 'guestBenefit3Desc',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get guestCreateAccount {
    return Intl.message(
      'Create Account',
      name: 'guestCreateAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get guestSignIn {
    return Intl.message('Sign In', name: 'guestSignIn', desc: '', args: []);
  }

  /// `Browsing as Guest • All detections are stored locally`
  String get guestBrowsingNote {
    return Intl.message(
      'Browsing as Guest • All detections are stored locally',
      name: 'guestBrowsingNote',
      desc: '',
      args: [],
    );
  }

  /// `Sign up to join`
  String get guestPromptTitle {
    return Intl.message(
      'Sign up to join',
      name: 'guestPromptTitle',
      desc: '',
      args: [],
    );
  }

  /// `Create an account to like, comment, and share with the Plantie community`
  String get guestPromptDescription {
    return Intl.message(
      'Create an account to like, comment, and share with the Plantie community',
      name: 'guestPromptDescription',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get guestPromptSignUp {
    return Intl.message(
      'Sign Up',
      name: 'guestPromptSignUp',
      desc: '',
      args: [],
    );
  }

  /// `Maybe Later`
  String get guestPromptMaybeLater {
    return Intl.message(
      'Maybe Later',
      name: 'guestPromptMaybeLater',
      desc: '',
      args: [],
    );
  }

  /// `Share with the community`
  String get guestCommunityTitle {
    return Intl.message(
      'Share with the community',
      name: 'guestCommunityTitle',
      desc: '',
      args: [],
    );
  }

  /// `Create an account to post, like, and comment with other plant lovers`
  String get guestCommunityDescription {
    return Intl.message(
      'Create an account to post, like, and comment with other plant lovers',
      name: 'guestCommunityDescription',
      desc: '',
      args: [],
    );
  }

  /// `No new notifications`
  String get noNewNotifications {
    return Intl.message(
      'No new notifications',
      name: 'noNewNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Create new post`
  String get createNewPost {
    return Intl.message(
      'Create new post',
      name: 'createNewPost',
      desc: '',
      args: [],
    );
  }

  /// `Post`
  String get post {
    return Intl.message('Post', name: 'post', desc: '', args: []);
  }

  /// `Latest`
  String get latest {
    return Intl.message('Latest', name: 'latest', desc: '', args: []);
  }

  /// `Popular`
  String get popular {
    return Intl.message('Popular', name: 'popular', desc: '', args: []);
  }

  /// `Trending`
  String get trending {
    return Intl.message('Trending', name: 'trending', desc: '', args: []);
  }

  /// `Loading more posts...`
  String get loadingMorePosts {
    return Intl.message(
      'Loading more posts...',
      name: 'loadingMorePosts',
      desc: '',
      args: [],
    );
  }

  /// `Be the first to share something amazing!`
  String get beFirstToShare {
    return Intl.message(
      'Be the first to share something amazing!',
      name: 'beFirstToShare',
      desc: '',
      args: [],
    );
  }

  /// `Search by post content`
  String get searchByPostContent {
    return Intl.message(
      'Search by post content',
      name: 'searchByPostContent',
      desc: '',
      args: [],
    );
  }

  /// `No posts match your search`
  String get noPostsMatch {
    return Intl.message(
      'No posts match your search',
      name: 'noPostsMatch',
      desc: '',
      args: [],
    );
  }

  /// `Clear search`
  String get clearSearch {
    return Intl.message(
      'Clear search',
      name: 'clearSearch',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Plantie!`
  String get welcomeToPlantie {
    return Intl.message(
      'Welcome to Plantie!',
      name: 'welcomeToPlantie',
      desc: '',
      args: [],
    );
  }

  /// `Discover expert plant care tips and join a community of plant lovers`
  String get discoverPlantCare {
    return Intl.message(
      'Discover expert plant care tips and join a community of plant lovers',
      name: 'discoverPlantCare',
      desc: '',
      args: [],
    );
  }

  /// `Get OTP Code`
  String get getOtpCode {
    return Intl.message('Get OTP Code', name: 'getOtpCode', desc: '', args: []);
  }

  /// `We'll send you a verification code via SMS`
  String get sendOtpSms {
    return Intl.message(
      'We\'ll send you a verification code via SMS',
      name: 'sendOtpSms',
      desc: '',
      args: [],
    );
  }

  /// `Continue as Guest`
  String get continueAsGuest {
    return Intl.message(
      'Continue as Guest',
      name: 'continueAsGuest',
      desc: '',
      args: [],
    );
  }

  /// `Enter phone number`
  String get phoneHint {
    return Intl.message(
      'Enter phone number',
      name: 'phoneHint',
      desc: '',
      args: [],
    );
  }

  /// `Invalid phone number`
  String get invalidPhone {
    return Intl.message(
      'Invalid phone number',
      name: 'invalidPhone',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get requiredField {
    return Intl.message(
      'This field is required',
      name: 'requiredField',
      desc: '',
      args: [],
    );
  }

  /// `Select country`
  String get selectCountry {
    return Intl.message(
      'Select country',
      name: 'selectCountry',
      desc: '',
      args: [],
    );
  }

  /// `What should we call you?`
  String get whatsYourName {
    return Intl.message(
      'What should we call you?',
      name: 'whatsYourName',
      desc: '',
      args: [],
    );
  }

  /// `Your name`
  String get nameHint {
    return Intl.message('Your name', name: 'nameHint', desc: '', args: []);
  }

  /// `Let's Start 🌱`
  String get letsStart {
    return Intl.message(
      'Let\'s Start 🌱',
      name: 'letsStart',
      desc: '',
      args: [],
    );
  }

  /// `Name must be at least 2 characters`
  String get nameTooShort {
    return Intl.message(
      'Name must be at least 2 characters',
      name: 'nameTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Letters and spaces only`
  String get lettersAndSpacesOnly {
    return Intl.message(
      'Letters and spaces only',
      name: 'lettersAndSpacesOnly',
      desc: '',
      args: [],
    );
  }

  /// `No account or password needed`
  String get noAccountNeeded {
    return Intl.message(
      'No account or password needed',
      name: 'noAccountNeeded',
      desc: '',
      args: [],
    );
  }

  /// `No Internet Connection`
  String get offlineTitle {
    return Intl.message(
      'No Internet Connection',
      name: 'offlineTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please check your network status and try refreshing.`
  String get offlineSubtitle {
    return Intl.message(
      'Please check your network status and try refreshing.',
      name: 'offlineSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retryButton {
    return Intl.message('Retry', name: 'retryButton', desc: '', args: []);
  }

  /// `About Me`
  String get aboutMe {
    return Intl.message('About Me', name: 'aboutMe', desc: '', args: []);
  }

  /// `Contact Details`
  String get contactInfo {
    return Intl.message(
      'Contact Details',
      name: 'contactInfo',
      desc: '',
      args: [],
    );
  }

  /// `Add a short bio to let people know you...`
  String get bioPlaceholder {
    return Intl.message(
      'Add a short bio to let people know you...',
      name: 'bioPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Add phone number`
  String get phonePlaceholder {
    return Intl.message(
      'Add phone number',
      name: 'phonePlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Add your country`
  String get countryPlaceholder {
    return Intl.message(
      'Add your country',
      name: 'countryPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get nameField {
    return Intl.message('Full Name', name: 'nameField', desc: '', args: []);
  }

  /// `Bio`
  String get bioField {
    return Intl.message('Bio', name: 'bioField', desc: '', args: []);
  }

  /// `Phone Number`
  String get phoneField {
    return Intl.message('Phone Number', name: 'phoneField', desc: '', args: []);
  }

  /// `Country`
  String get countryField {
    return Intl.message('Country', name: 'countryField', desc: '', args: []);
  }

  /// `Choose from Gallery`
  String get gallerySource {
    return Intl.message(
      'Choose from Gallery',
      name: 'gallerySource',
      desc: '',
      args: [],
    );
  }

  /// `Take a Photo`
  String get cameraSource {
    return Intl.message(
      'Take a Photo',
      name: 'cameraSource',
      desc: '',
      args: [],
    );
  }

  /// `Complete Your Profile!`
  String get completeProfilePrompt {
    return Intl.message(
      'Complete Your Profile!',
      name: 'completeProfilePrompt',
      desc: '',
      args: [],
    );
  }

  /// `Fill in your bio, location, and phone details to look official.`
  String get completeProfileSubtitle {
    return Intl.message(
      'Fill in your bio, location, and phone details to look official.',
      name: 'completeProfileSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Unsaved Changes`
  String get unsavedChangesTitle {
    return Intl.message(
      'Unsaved Changes',
      name: 'unsavedChangesTitle',
      desc: '',
      args: [],
    );
  }

  /// `You have modified details. Leaving now will discard all edits.`
  String get unsavedChangesMsg {
    return Intl.message(
      'You have modified details. Leaving now will discard all edits.',
      name: 'unsavedChangesMsg',
      desc: '',
      args: [],
    );
  }

  /// `Keep Editing`
  String get keepEditing {
    return Intl.message(
      'Keep Editing',
      name: 'keepEditing',
      desc: '',
      args: [],
    );
  }

  /// `Discard`
  String get discard {
    return Intl.message('Discard', name: 'discard', desc: '', args: []);
  }

  /// `Success`
  String get successTitle {
    return Intl.message('Success', name: 'successTitle', desc: '', args: []);
  }

  /// `Your profile information has been securely updated.`
  String get profileUpdatedMsg {
    return Intl.message(
      'Your profile information has been securely updated.',
      name: 'profileUpdatedMsg',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get errorTitle {
    return Intl.message('Error', name: 'errorTitle', desc: '', args: []);
  }

  /// `Profile updated successfully`
  String get profileUpdatedSuccess {
    return Intl.message(
      'Profile updated successfully',
      name: 'profileUpdatedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Save Avatar`
  String get saveAvatar {
    return Intl.message('Save Avatar', name: 'saveAvatar', desc: '', args: []);
  }

  /// `Plant Diagnosis`
  String get plantDiagnosis {
    return Intl.message(
      'Plant Diagnosis',
      name: 'plantDiagnosis',
      desc: '',
      args: [],
    );
  }

  /// `Recent Diagnoses`
  String get recentDiagnoses {
    return Intl.message(
      'Recent Diagnoses',
      name: 'recentDiagnoses',
      desc: '',
      args: [],
    );
  }

  /// `Identify Plant Diseases`
  String get scanPlantPrompt {
    return Intl.message(
      'Identify Plant Diseases',
      name: 'scanPlantPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Take a photo of a leaf to get an instant diagnosis and treatment plan.`
  String get scanPlantSubPrompt {
    return Intl.message(
      'Take a photo of a leaf to get an instant diagnosis and treatment plan.',
      name: 'scanPlantSubPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Start Scan`
  String get startScan {
    return Intl.message('Start Scan', name: 'startScan', desc: '', args: []);
  }

  /// `Analyzing Image...`
  String get analyzing {
    return Intl.message(
      'Analyzing Image...',
      name: 'analyzing',
      desc: '',
      args: [],
    );
  }

  /// `Not a Plant`
  String get notAPlant {
    return Intl.message('Not a Plant', name: 'notAPlant', desc: '', args: []);
  }

  /// `View Details`
  String get viewDetails {
    return Intl.message(
      'View Details',
      name: 'viewDetails',
      desc: '',
      args: [],
    );
  }

  /// `Scan Another`
  String get scanAnother {
    return Intl.message(
      'Scan Another',
      name: 'scanAnother',
      desc: '',
      args: [],
    );
  }

  /// `No history yet`
  String get noHistoryYet {
    return Intl.message(
      'No history yet',
      name: 'noHistoryYet',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message('Yesterday', name: 'yesterday', desc: '', args: []);
  }

  /// `days ago`
  String get daysAgo {
    return Intl.message('days ago', name: 'daysAgo', desc: '', args: []);
  }

  /// `Post by`
  String get postedBy {
    return Intl.message('Post by', name: 'postedBy', desc: '', args: []);
  }

  /// `avatar`
  String get avatar {
    return Intl.message('avatar', name: 'avatar', desc: '', args: []);
  }

  /// `Show more`
  String get showMore {
    return Intl.message('Show more', name: 'showMore', desc: '', args: []);
  }

  /// `Show less`
  String get showLess {
    return Intl.message('Show less', name: 'showLess', desc: '', args: []);
  }

  /// `likes`
  String get likes {
    return Intl.message('likes', name: 'likes', desc: '', args: []);
  }

  /// `Comment`
  String get comment {
    return Intl.message('Comment', name: 'comment', desc: '', args: []);
  }

  /// `Like`
  String get like {
    return Intl.message('Like', name: 'like', desc: '', args: []);
  }

  /// `Write comment`
  String get writeComment {
    return Intl.message(
      'Write comment',
      name: 'writeComment',
      desc: '',
      args: [],
    );
  }

  /// `Like post`
  String get likePost {
    return Intl.message('Like post', name: 'likePost', desc: '', args: []);
  }

  /// `Unlike post`
  String get unlikePost {
    return Intl.message('Unlike post', name: 'unlikePost', desc: '', args: []);
  }

  /// `Post actions`
  String get postActions {
    return Intl.message(
      'Post actions',
      name: 'postActions',
      desc: '',
      args: [],
    );
  }

  /// `More options`
  String get moreOptions {
    return Intl.message(
      'More options',
      name: 'moreOptions',
      desc: '',
      args: [],
    );
  }

  /// `Post options`
  String get postOptions {
    return Intl.message(
      'Post options',
      name: 'postOptions',
      desc: '',
      args: [],
    );
  }

  /// `Delete Post`
  String get deletePost {
    return Intl.message('Delete Post', name: 'deletePost', desc: '', args: []);
  }

  /// `Delete Post?`
  String get deletePostQuestion {
    return Intl.message(
      'Delete Post?',
      name: 'deletePostQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this post? This action cannot be undone.`
  String get deletePostConfirmation {
    return Intl.message(
      'Are you sure you want to delete this post? This action cannot be undone.',
      name: 'deletePostConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `No Internet Connection`
  String get noInternet {
    return Intl.message(
      'No Internet Connection',
      name: 'noInternet',
      desc: '',
      args: [],
    );
  }

  /// `Please check your network status and try refreshing.`
  String get checkNetwork {
    return Intl.message(
      'Please check your network status and try refreshing.',
      name: 'checkNetwork',
      desc: '',
      args: [],
    );
  }

  /// `Error loading posts`
  String get errorLoadingPosts {
    return Intl.message(
      'Error loading posts',
      name: 'errorLoadingPosts',
      desc: '',
      args: [],
    );
  }

  /// `Photos`
  String get photos {
    return Intl.message('Photos', name: 'photos', desc: '', args: []);
  }

  /// `Post created successfully!`
  String get postCreatedSuccessfully {
    return Intl.message(
      'Post created successfully!',
      name: 'postCreatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `User data not found. Please log in again.`
  String get userDataNotFound {
    return Intl.message(
      'User data not found. Please log in again.',
      name: 'userDataNotFound',
      desc: '',
      args: [],
    );
  }

  /// `No comments yet`
  String get noCommentsYet {
    return Intl.message(
      'No comments yet',
      name: 'noCommentsYet',
      desc: '',
      args: [],
    );
  }

  /// `Be the first to comment`
  String get beFirstToComment {
    return Intl.message(
      'Be the first to comment',
      name: 'beFirstToComment',
      desc: '',
      args: [],
    );
  }

  /// `Posting comment...`
  String get postingComment {
    return Intl.message(
      'Posting comment...',
      name: 'postingComment',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection. Please check your network and try again.`
  String get offlineSaveError {
    return Intl.message(
      'No internet connection. Please check your network and try again.',
      name: 'offlineSaveError',
      desc: '',
      args: [],
    );
  }

  /// `Cannot update avatar while offline. Please connect to the internet.`
  String get offlineAvatarError {
    return Intl.message(
      'Cannot update avatar while offline. Please connect to the internet.',
      name: 'offlineAvatarError',
      desc: '',
      args: [],
    );
  }

  /// `AR`
  String get arShort {
    return Intl.message('AR', name: 'arShort', desc: '', args: []);
  }

  /// `EN`
  String get enShort {
    return Intl.message('EN', name: 'enShort', desc: '', args: []);
  }

  /// `PREFERENCES & OPTIONS`
  String get preferencesAndOptions {
    return Intl.message(
      'PREFERENCES & OPTIONS',
      name: 'preferencesAndOptions',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection. Like will be saved when you're back online.`
  String get offlineLikeError {
    return Intl.message(
      'No internet connection. Like will be saved when you\'re back online.',
      name: 'offlineLikeError',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection. Your comment will be saved when you're back online.`
  String get offlineCommentError {
    return Intl.message(
      'No internet connection. Your comment will be saved when you\'re back online.',
      name: 'offlineCommentError',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection. Cannot load more posts.`
  String get offlineLoadMoreError {
    return Intl.message(
      'No internet connection. Cannot load more posts.',
      name: 'offlineLoadMoreError',
      desc: '',
      args: [],
    );
  }

  /// `Analysis took too long. Please try again with a clearer image.`
  String get detectionTimeoutError {
    return Intl.message(
      'Analysis took too long. Please try again with a clearer image.',
      name: 'detectionTimeoutError',
      desc: '',
      args: [],
    );
  }

  /// `Could not read the image. Please select a valid photo.`
  String get invalidImageError {
    return Intl.message(
      'Could not read the image. Please select a valid photo.',
      name: 'invalidImageError',
      desc: '',
      args: [],
    );
  }

  /// `Image is too large. Please use a smaller photo.`
  String get outOfMemoryError {
    return Intl.message(
      'Image is too large. Please use a smaller photo.',
      name: 'outOfMemoryError',
      desc: '',
      args: [],
    );
  }

  /// `The image does not appear to contain a plant leaf.`
  String get notAPlantError {
    return Intl.message(
      'The image does not appear to contain a plant leaf.',
      name: 'notAPlantError',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong. Please try again.`
  String get detectionGenericError {
    return Intl.message(
      'Something went wrong. Please try again.',
      name: 'detectionGenericError',
      desc: '',
      args: [],
    );
  }

  /// `No Internet Connection`
  String get noInternetConnection {
    return Intl.message(
      'No Internet Connection',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `You are currently offline. Your post will be saved and uploaded when you regain internet connection.`
  String get offlinePostMessage {
    return Intl.message(
      'You are currently offline. Your post will be saved and uploaded when you regain internet connection.',
      name: 'offlinePostMessage',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Could not post comment. Please try again.`
  String get commentFailed {
    return Intl.message(
      'Could not post comment. Please try again.',
      name: 'commentFailed',
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
