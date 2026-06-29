import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Plantie!'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'Stay updated with real-time weather and plant care advice tailored to your needs, and calculate the right amount of fertilizer for optimal plant growth.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Detect Plant Diseases'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'Upload a photo of your plant to identify diseases and get expert solutions instantly.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Find Nearby Plant Stores'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In en, this message translates to:
  /// **'Easily locate nearby plant stores with just a tap, helping you take better care of your plants.'**
  String get onboardingBody3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Join the Plantie Community'**
  String get onboardingTitle4;

  /// No description provided for @onboardingBody4.
  ///
  /// In en, this message translates to:
  /// **'Connect with fellow plant lovers, share tips, and learn from each other to grow your green space together.'**
  String get onboardingBody4;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'SKIP'**
  String get skip;

  /// No description provided for @welcome_title.
  ///
  /// In en, this message translates to:
  /// **'Plantie'**
  String get welcome_title;

  /// No description provided for @welcome_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Get more crops with Plantie\'s help!'**
  String get welcome_subtitle;

  /// No description provided for @login_button.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_button;

  /// No description provided for @register_button.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register_button;

  /// No description provided for @terms_and_conditions.
  ///
  /// In en, this message translates to:
  /// **'By logging in or registering, you agree to our Terms of Service and Privacy Policy'**
  String get terms_and_conditions;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Hello, Welcome back to Plantie!'**
  String get welcome_back;

  /// No description provided for @email_address.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email_address;

  /// No description provided for @enter_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get enter_email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enter_password.
  ///
  /// In en, this message translates to:
  /// **'Password is too short'**
  String get enter_password;

  /// No description provided for @forget_password.
  ///
  /// In en, this message translates to:
  /// **'Forget Password?'**
  String get forget_password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create account?'**
  String get create_account;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @or_login_by.
  ///
  /// In en, this message translates to:
  /// **'or login by'**
  String get or_login_by;

  /// No description provided for @reset_password.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password;

  /// No description provided for @sent_email_to_update_paassword.
  ///
  /// In en, this message translates to:
  /// **'we sent to your email url to use it to reset the password'**
  String get sent_email_to_update_paassword;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @creat_account2.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get creat_account2;

  /// No description provided for @create_account3.
  ///
  /// In en, this message translates to:
  /// **'Complete your information to get started!'**
  String get create_account3;

  /// No description provided for @enter_name.
  ///
  /// In en, this message translates to:
  /// **'please enter a user name'**
  String get enter_name;

  /// No description provided for @email_valid.
  ///
  /// In en, this message translates to:
  /// **'please enter a valid email'**
  String get email_valid;

  /// No description provided for @or_register_by.
  ///
  /// In en, this message translates to:
  /// **'or register by'**
  String get or_register_by;

  /// No description provided for @have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get have_account;

  /// No description provided for @weather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weather;

  /// No description provided for @choosePlant.
  ///
  /// In en, this message translates to:
  /// **'Choose a Plant'**
  String get choosePlant;

  /// No description provided for @calculateFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Calculate Fertilizer'**
  String get calculateFertilizer;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @nutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutrition;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @diseases.
  ///
  /// In en, this message translates to:
  /// **'Diseases'**
  String get diseases;

  /// No description provided for @plantingTime.
  ///
  /// In en, this message translates to:
  /// **'Planting Time'**
  String get plantingTime;

  /// No description provided for @npkFormula.
  ///
  /// In en, this message translates to:
  /// **'NPK Formula'**
  String get npkFormula;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @prevention.
  ///
  /// In en, this message translates to:
  /// **'Prevention'**
  String get prevention;

  /// No description provided for @fetchingWeather.
  ///
  /// In en, this message translates to:
  /// **'Fetching weather...'**
  String get fetchingWeather;

  /// No description provided for @locationRequired.
  ///
  /// In en, this message translates to:
  /// **'Location permission required'**
  String get locationRequired;

  /// No description provided for @enableLocation.
  ///
  /// In en, this message translates to:
  /// **'Enable Location'**
  String get enableLocation;

  /// No description provided for @permanentDenial.
  ///
  /// In en, this message translates to:
  /// **'Location permissions permanently denied. Please enable in settings.'**
  String get permanentDenial;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @gpsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services disabled. Please enable GPS.'**
  String get gpsDisabled;

  /// No description provided for @enableGPS.
  ///
  /// In en, this message translates to:
  /// **'Enable GPS'**
  String get enableGPS;

  /// No description provided for @weatherError.
  ///
  /// In en, this message translates to:
  /// **'Error fetching weather: {error}'**
  String weatherError(Object error);

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @getWeather.
  ///
  /// In en, this message translates to:
  /// **'Get Weather'**
  String get getWeather;

  /// No description provided for @feelsLike.
  ///
  /// In en, this message translates to:
  /// **'Feels like {temp}°C'**
  String feelsLike(Object temp);

  /// No description provided for @weather_details.
  ///
  /// In en, this message translates to:
  /// **'Weather Details'**
  String get weather_details;

  /// No description provided for @current_weather.
  ///
  /// In en, this message translates to:
  /// **'Current Weather'**
  String get current_weather;

  /// No description provided for @feels_like.
  ///
  /// In en, this message translates to:
  /// **'Feels Like'**
  String get feels_like;

  /// No description provided for @wind_speed.
  ///
  /// In en, this message translates to:
  /// **'Wind Speed'**
  String get wind_speed;

  /// No description provided for @pressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get pressure;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @sunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get sunset;

  /// No description provided for @farming_insights.
  ///
  /// In en, this message translates to:
  /// **'Farming Insights'**
  String get farming_insights;

  /// No description provided for @hourly_forecast.
  ///
  /// In en, this message translates to:
  /// **'Hourly Forecast'**
  String get hourly_forecast;

  /// No description provided for @daily_forecast.
  ///
  /// In en, this message translates to:
  /// **'7-Day Forecast'**
  String get daily_forecast;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @soil_temp.
  ///
  /// In en, this message translates to:
  /// **'Soil Temperature'**
  String get soil_temp;

  /// No description provided for @evapotranspiration.
  ///
  /// In en, this message translates to:
  /// **'Evapotranspiration'**
  String get evapotranspiration;

  /// No description provided for @precipitation.
  ///
  /// In en, this message translates to:
  /// **'Precipitation'**
  String get precipitation;

  /// No description provided for @humidity_level.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity_level;

  /// No description provided for @no_insights.
  ///
  /// In en, this message translates to:
  /// **'No specific alerts for today.'**
  String get no_insights;

  /// No description provided for @good_for_farming.
  ///
  /// In en, this message translates to:
  /// **'Good conditions for farming activities.'**
  String get good_for_farming;

  /// No description provided for @warning_farming.
  ///
  /// In en, this message translates to:
  /// **'Use caution with some farming activities.'**
  String get warning_farming;

  /// No description provided for @critical_farming.
  ///
  /// In en, this message translates to:
  /// **'High risk! Take immediate action to protect crops.'**
  String get critical_farming;

  /// No description provided for @recommendation.
  ///
  /// In en, this message translates to:
  /// **'Recommendation'**
  String get recommendation;

  /// No description provided for @weather_trends.
  ///
  /// In en, this message translates to:
  /// **'Weather Trends'**
  String get weather_trends;

  /// No description provided for @temperature_chart.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature_chart;

  /// No description provided for @precipitation_chart.
  ///
  /// In en, this message translates to:
  /// **'Precipitation'**
  String get precipitation_chart;

  /// No description provided for @fertilizerCalculator.
  ///
  /// In en, this message translates to:
  /// **'{emoji} {name} Fertilizer'**
  String fertilizerCalculator(Object emoji, Object name);

  /// No description provided for @plantType.
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String plantType(Object type);

  /// No description provided for @landArea.
  ///
  /// In en, this message translates to:
  /// **'Land Area ({unit}):'**
  String landArea(Object unit);

  /// No description provided for @numberOfTrees.
  ///
  /// In en, this message translates to:
  /// **'Number of Trees'**
  String get numberOfTrees;

  /// No description provided for @treeAge.
  ///
  /// In en, this message translates to:
  /// **'Tree Age (Years)'**
  String get treeAge;

  /// No description provided for @recommendedNpk.
  ///
  /// In en, this message translates to:
  /// **'Recommended NPK Ratio:'**
  String get recommendedNpk;

  /// No description provided for @calculateRequirements.
  ///
  /// In en, this message translates to:
  /// **'Calculate Requirements'**
  String get calculateRequirements;

  /// No description provided for @requiredFertilizers.
  ///
  /// In en, this message translates to:
  /// **'Required Fertilizers ({calculationContext}):'**
  String requiredFertilizers(Object calculationContext);

  /// No description provided for @treeNote.
  ///
  /// In en, this message translates to:
  /// **'Note: Calculations include age factor for {age} year old trees'**
  String treeNote(Object age);

  /// No description provided for @areaNote.
  ///
  /// In en, this message translates to:
  /// **'Note: 1 Dunam = 1000 m² (10,000 sq ft)'**
  String get areaNote;

  /// No description provided for @nitrogen.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen'**
  String get nitrogen;

  /// No description provided for @phosphorus.
  ///
  /// In en, this message translates to:
  /// **'Phosphorus'**
  String get phosphorus;

  /// No description provided for @potassium.
  ///
  /// In en, this message translates to:
  /// **'Potassium'**
  String get potassium;

  /// No description provided for @dunam.
  ///
  /// In en, this message translates to:
  /// **'Dunam'**
  String get dunam;

  /// No description provided for @acre.
  ///
  /// In en, this message translates to:
  /// **'Acre'**
  String get acre;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit:'**
  String get unit;

  /// No description provided for @urea.
  ///
  /// In en, this message translates to:
  /// **'UREA'**
  String get urea;

  /// No description provided for @ssp.
  ///
  /// In en, this message translates to:
  /// **'SSP'**
  String get ssp;

  /// No description provided for @mop.
  ///
  /// In en, this message translates to:
  /// **'MOP'**
  String get mop;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Confirm Sign Out'**
  String get confirmLogout;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your account?'**
  String get logoutMessage;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be left empty'**
  String get nameRequired;

  /// No description provided for @bioRequired.
  ///
  /// In en, this message translates to:
  /// **'Bio must not be empty'**
  String get bioRequired;

  /// No description provided for @countryRequired.
  ///
  /// In en, this message translates to:
  /// **'Country must not be empty'**
  String get countryRequired;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone must not be empty'**
  String get phoneRequired;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed: {error}'**
  String updateFailed(Object error);

  /// No description provided for @namefield.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get namefield;

  /// No description provided for @phoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get phoneOptional;

  /// No description provided for @bioOptional.
  ///
  /// In en, this message translates to:
  /// **'Bio (optional)'**
  String get bioOptional;

  /// No description provided for @countryOptional.
  ///
  /// In en, this message translates to:
  /// **'Country (optional)'**
  String get countryOptional;

  /// No description provided for @bioHint.
  ///
  /// In en, this message translates to:
  /// **'Tell other farmers about yourself...'**
  String get bioHint;

  /// No description provided for @bioCharCount.
  ///
  /// In en, this message translates to:
  /// **'{current}/{max}'**
  String bioCharCount(Object current, Object max);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @detection.
  ///
  /// In en, this message translates to:
  /// **'Detection'**
  String get detection;

  /// No description provided for @profile2.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile2;

  /// No description provided for @verificationSent.
  ///
  /// In en, this message translates to:
  /// **'Verification email resent. Please check your inbox.'**
  String get verificationSent;

  /// No description provided for @verificationError.
  ///
  /// In en, this message translates to:
  /// **'Error sending verification: {error}'**
  String verificationError(Object error);

  /// No description provided for @detectionResults.
  ///
  /// In en, this message translates to:
  /// **'Detection Results'**
  String get detectionResults;

  /// No description provided for @detectionResult.
  ///
  /// In en, this message translates to:
  /// **'Detection Result'**
  String get detectionResult;

  /// No description provided for @recommendedTreatment.
  ///
  /// In en, this message translates to:
  /// **'Recommended Treatment'**
  String get recommendedTreatment;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @noDetectionHistory.
  ///
  /// In en, this message translates to:
  /// **'No Detection History'**
  String get noDetectionHistory;

  /// No description provided for @historyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your plant health scans will appear here'**
  String get historyPlaceholder;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get deleteConfirmation;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @treatmentLabel.
  ///
  /// In en, this message translates to:
  /// **'{treatment}'**
  String treatmentLabel(Object treatment);

  /// No description provided for @treatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get treatment;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @nearestNursery.
  ///
  /// In en, this message translates to:
  /// **'Nearest Plant Nursery'**
  String get nearestNursery;

  /// No description provided for @noStoresFound.
  ///
  /// In en, this message translates to:
  /// **'No nearby stores found'**
  String get noStoresFound;

  /// No description provided for @locationError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String locationError(Object error);

  /// No description provided for @launchError.
  ///
  /// In en, this message translates to:
  /// **'Could not launch maps'**
  String get launchError;

  /// No description provided for @tap_camera_to_scan.
  ///
  /// In en, this message translates to:
  /// **'Tap the camera button below\nto start scanning your plants'**
  String get tap_camera_to_scan;

  /// No description provided for @searchPosts.
  ///
  /// In en, this message translates to:
  /// **'Search posts'**
  String get searchPosts;

  /// No description provided for @newPost.
  ///
  /// In en, this message translates to:
  /// **'New Post'**
  String get newPost;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @write_comment.
  ///
  /// In en, this message translates to:
  /// **'Write a comment...'**
  String get write_comment;

  /// No description provided for @no_posts.
  ///
  /// In en, this message translates to:
  /// **'No posts'**
  String get no_posts;

  /// No description provided for @createPost.
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get createPost;

  /// No description provided for @postButton.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get postButton;

  /// No description provided for @whatsOnMind.
  ///
  /// In en, this message translates to:
  /// **'What\'s on your mind?'**
  String get whatsOnMind;

  /// No description provided for @addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get addPhotos;

  /// No description provided for @positioningTips.
  ///
  /// In en, this message translates to:
  /// **'Positioning Tips'**
  String get positioningTips;

  /// No description provided for @positioningTip1.
  ///
  /// In en, this message translates to:
  /// **'Capture in good natural lighting'**
  String get positioningTip1;

  /// No description provided for @positioningTip2.
  ///
  /// In en, this message translates to:
  /// **'Fill frame with the leaf'**
  String get positioningTip2;

  /// No description provided for @positioningTip3.
  ///
  /// In en, this message translates to:
  /// **'Avoid shadows on the subject'**
  String get positioningTip3;

  /// No description provided for @focusRequirements.
  ///
  /// In en, this message translates to:
  /// **'Focus Requirements'**
  String get focusRequirements;

  /// No description provided for @focusTip1.
  ///
  /// In en, this message translates to:
  /// **'Ensure leaf edges are clear'**
  String get focusTip1;

  /// No description provided for @focusTip2.
  ///
  /// In en, this message translates to:
  /// **'Focus on affected areas'**
  String get focusTip2;

  /// No description provided for @focusTip3.
  ///
  /// In en, this message translates to:
  /// **'Keep camera steady'**
  String get focusTip3;

  /// No description provided for @backgroundTips.
  ///
  /// In en, this message translates to:
  /// **'Background Tips'**
  String get backgroundTips;

  /// No description provided for @backgroundTip1.
  ///
  /// In en, this message translates to:
  /// **'Use plain background'**
  String get backgroundTip1;

  /// No description provided for @backgroundTip2.
  ///
  /// In en, this message translates to:
  /// **'White/light colors preferred'**
  String get backgroundTip2;

  /// No description provided for @backgroundTip3.
  ///
  /// In en, this message translates to:
  /// **'Avoid busy patterns'**
  String get backgroundTip3;

  /// No description provided for @captureGuidelines.
  ///
  /// In en, this message translates to:
  /// **'Capture Guidelines'**
  String get captureGuidelines;

  /// No description provided for @iUnderstand.
  ///
  /// In en, this message translates to:
  /// **'I Understand - Continue'**
  String get iUnderstand;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String errorOccurred(Object error);

  /// No description provided for @unknownDisease.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownDisease;

  /// No description provided for @noDetails.
  ///
  /// In en, this message translates to:
  /// **''**
  String get noDetails;

  /// No description provided for @diseaseNotDetected.
  ///
  /// In en, this message translates to:
  /// **'Disease not recognized'**
  String get diseaseNotDetected;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @avoid.
  ///
  /// In en, this message translates to:
  /// **'Avoid'**
  String get avoid;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed. Restart the app?'**
  String get languageChanged;

  /// No description provided for @irrigation_alert.
  ///
  /// In en, this message translates to:
  /// **'Irrigation Alert'**
  String get irrigation_alert;

  /// No description provided for @irrigation_message.
  ///
  /// In en, this message translates to:
  /// **'Significant rain detected ({value} mm). Do not irrigate today to prevent waterlogging.'**
  String irrigation_message(Object value);

  /// No description provided for @wind_warning.
  ///
  /// In en, this message translates to:
  /// **'Wind Warning'**
  String get wind_warning;

  /// No description provided for @wind_message.
  ///
  /// In en, this message translates to:
  /// **'High wind speeds ({value} km/h). Avoid spraying pesticides as they may drift.'**
  String wind_message(Object value);

  /// No description provided for @ideal_spraying.
  ///
  /// In en, this message translates to:
  /// **'Ideal Spraying'**
  String get ideal_spraying;

  /// No description provided for @ideal_spraying_message.
  ///
  /// In en, this message translates to:
  /// **'Wind conditions are calm. Good time for pest control application.'**
  String get ideal_spraying_message;

  /// No description provided for @frost_risk.
  ///
  /// In en, this message translates to:
  /// **'Frost Risk'**
  String get frost_risk;

  /// No description provided for @frost_message.
  ///
  /// In en, this message translates to:
  /// **'Temperature is low ({value}°C). High risk of frost damage. Protect sensitive crops.'**
  String frost_message(Object value);

  /// No description provided for @high_evaporation.
  ///
  /// In en, this message translates to:
  /// **'High Evaporation'**
  String get high_evaporation;

  /// No description provided for @high_evaporation_message.
  ///
  /// In en, this message translates to:
  /// **'High evapotranspiration rate ({value} mm). Consider increasing irrigation frequency.'**
  String high_evaporation_message(Object value);

  /// No description provided for @soil_condition.
  ///
  /// In en, this message translates to:
  /// **'Soil Condition'**
  String get soil_condition;

  /// No description provided for @soil_condition_message.
  ///
  /// In en, this message translates to:
  /// **'Soil temperature is {value}°C, ideal for most seed germination.'**
  String soil_condition_message(Object value);

  /// No description provided for @analyzingImage.
  ///
  /// In en, this message translates to:
  /// **'Analyzing Image...'**
  String get analyzingImage;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait while AI detects...'**
  String get pleaseWait;

  /// No description provided for @expertAdvice.
  ///
  /// In en, this message translates to:
  /// **'Expert Advice'**
  String get expertAdvice;

  /// No description provided for @findNearestStore.
  ///
  /// In en, this message translates to:
  /// **'Find Nearest Store'**
  String get findNearestStore;

  /// No description provided for @tipsForAccurateDetection.
  ///
  /// In en, this message translates to:
  /// **'Tips for Accurate Detection'**
  String get tipsForAccurateDetection;

  /// No description provided for @healthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthy;

  /// No description provided for @diseaseDetected.
  ///
  /// In en, this message translates to:
  /// **'Disease Detected'**
  String get diseaseDetected;

  /// No description provided for @goodLighting.
  ///
  /// In en, this message translates to:
  /// **'Good lighting'**
  String get goodLighting;

  /// No description provided for @naturalSunlightWorks.
  ///
  /// In en, this message translates to:
  /// **'Natural sunlight works best'**
  String get naturalSunlightWorks;

  /// No description provided for @closeFocus.
  ///
  /// In en, this message translates to:
  /// **'Close focus'**
  String get closeFocus;

  /// No description provided for @distanceFromLeaf.
  ///
  /// In en, this message translates to:
  /// **'Get 15-30cm from the leaf'**
  String get distanceFromLeaf;

  /// No description provided for @clearImage.
  ///
  /// In en, this message translates to:
  /// **'Clear image'**
  String get clearImage;

  /// No description provided for @avoidBlurred.
  ///
  /// In en, this message translates to:
  /// **'Avoid blurred or tilted photos'**
  String get avoidBlurred;

  /// No description provided for @singleLeaf.
  ///
  /// In en, this message translates to:
  /// **'Single leaf'**
  String get singleLeaf;

  /// No description provided for @focusOnDiseased.
  ///
  /// In en, this message translates to:
  /// **'Focus on one diseased leaf'**
  String get focusOnDiseased;

  /// No description provided for @deletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Item deleted successfully'**
  String get deletedSuccessfully;

  /// No description provided for @itemDeleted.
  ///
  /// In en, this message translates to:
  /// **'Your scan has been removed'**
  String get itemDeleted;

  /// No description provided for @startDetection.
  ///
  /// In en, this message translates to:
  /// **'Start Detection'**
  String get startDetection;

  /// No description provided for @tapCameraToDetect.
  ///
  /// In en, this message translates to:
  /// **'Tap the camera button to capture a plant image and start the diagnosis'**
  String get tapCameraToDetect;

  /// No description provided for @tapCamera.
  ///
  /// In en, this message translates to:
  /// **'Tap Camera'**
  String get tapCamera;

  /// No description provided for @followTheseSteps.
  ///
  /// In en, this message translates to:
  /// **'Follow these tips for best results'**
  String get followTheseSteps;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got It'**
  String get gotIt;

  /// No description provided for @quickTipsForBestResults.
  ///
  /// In en, this message translates to:
  /// **'Quick tips for best results'**
  String get quickTipsForBestResults;

  /// No description provided for @goodLightingCapture.
  ///
  /// In en, this message translates to:
  /// **'Good Lighting'**
  String get goodLightingCapture;

  /// No description provided for @naturalLightWorks.
  ///
  /// In en, this message translates to:
  /// **'Natural light works best'**
  String get naturalLightWorks;

  /// No description provided for @closeAndClear.
  ///
  /// In en, this message translates to:
  /// **'Close & Clear'**
  String get closeAndClear;

  /// No description provided for @distanceAndFocus.
  ///
  /// In en, this message translates to:
  /// **'15-30cm from leaf, sharp focus'**
  String get distanceAndFocus;

  /// No description provided for @singleLeafCapture.
  ///
  /// In en, this message translates to:
  /// **'Single Leaf'**
  String get singleLeafCapture;

  /// No description provided for @focusOnOneDiseased.
  ///
  /// In en, this message translates to:
  /// **'Focus on one diseased area'**
  String get focusOnOneDiseased;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Take care of your plants'**
  String get homeSubtitle;

  /// No description provided for @grantLocationPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant location permission to view weather details'**
  String get grantLocationPermission;

  /// No description provided for @locationDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationDenied;

  /// No description provided for @allowAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow Access'**
  String get allowAccess;

  /// No description provided for @weatherErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error loading weather'**
  String get weatherErrorTitle;

  /// No description provided for @checkWeatherPrompt.
  ///
  /// In en, this message translates to:
  /// **'Check the weather in your area'**
  String get checkWeatherPrompt;

  /// No description provided for @clearSky.
  ///
  /// In en, this message translates to:
  /// **'Clear Sky'**
  String get clearSky;

  /// No description provided for @partlyCloudy.
  ///
  /// In en, this message translates to:
  /// **'Partly Cloudy'**
  String get partlyCloudy;

  /// No description provided for @foggy.
  ///
  /// In en, this message translates to:
  /// **'Foggy'**
  String get foggy;

  /// No description provided for @drizzle.
  ///
  /// In en, this message translates to:
  /// **'Drizzle'**
  String get drizzle;

  /// No description provided for @rainy.
  ///
  /// In en, this message translates to:
  /// **'Rainy'**
  String get rainy;

  /// No description provided for @snowy.
  ///
  /// In en, this message translates to:
  /// **'Snowy'**
  String get snowy;

  /// No description provided for @rainShowers.
  ///
  /// In en, this message translates to:
  /// **'Rain Showers'**
  String get rainShowers;

  /// No description provided for @thunderstorm.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm'**
  String get thunderstorm;

  /// No description provided for @noDiseases.
  ///
  /// In en, this message translates to:
  /// **'No diseases recorded'**
  String get noDiseases;

  /// No description provided for @guestProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get guestProfileTitle;

  /// No description provided for @guestJoinTitle.
  ///
  /// In en, this message translates to:
  /// **'Join Plantie'**
  String get guestJoinTitle;

  /// No description provided for @guestJoinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock the full Plantie experience'**
  String get guestJoinSubtitle;

  /// No description provided for @guestBenefit1Title.
  ///
  /// In en, this message translates to:
  /// **'Sync Your History'**
  String get guestBenefit1Title;

  /// No description provided for @guestBenefit1Desc.
  ///
  /// In en, this message translates to:
  /// **'Access your detection history across devices'**
  String get guestBenefit1Desc;

  /// No description provided for @guestBenefit2Title.
  ///
  /// In en, this message translates to:
  /// **'Join the Community'**
  String get guestBenefit2Title;

  /// No description provided for @guestBenefit2Desc.
  ///
  /// In en, this message translates to:
  /// **'Like, comment, and share with other plant lovers'**
  String get guestBenefit2Desc;

  /// No description provided for @guestBenefit3Title.
  ///
  /// In en, this message translates to:
  /// **'Help Improve Plantie'**
  String get guestBenefit3Title;

  /// No description provided for @guestBenefit3Desc.
  ///
  /// In en, this message translates to:
  /// **'Your feedback trains better disease detection for everyone'**
  String get guestBenefit3Desc;

  /// No description provided for @guestCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get guestCreateAccount;

  /// No description provided for @guestSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get guestSignIn;

  /// No description provided for @guestBrowsingNote.
  ///
  /// In en, this message translates to:
  /// **'Browsing as Guest • All detections are stored locally'**
  String get guestBrowsingNote;

  /// No description provided for @guestPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to join'**
  String get guestPromptTitle;

  /// No description provided for @guestPromptDescription.
  ///
  /// In en, this message translates to:
  /// **'Create an account to like, comment, and share with the Plantie community'**
  String get guestPromptDescription;

  /// No description provided for @guestPromptSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get guestPromptSignUp;

  /// No description provided for @guestPromptMaybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get guestPromptMaybeLater;

  /// No description provided for @guestCommunityTitle.
  ///
  /// In en, this message translates to:
  /// **'Share with the community'**
  String get guestCommunityTitle;

  /// No description provided for @guestCommunityDescription.
  ///
  /// In en, this message translates to:
  /// **'Create an account to post, like, and comment with other plant lovers'**
  String get guestCommunityDescription;

  /// No description provided for @noNewNotifications.
  ///
  /// In en, this message translates to:
  /// **'No new notifications'**
  String get noNewNotifications;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @createNewPost.
  ///
  /// In en, this message translates to:
  /// **'Create new post'**
  String get createNewPost;

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @latest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latest;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @trending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get trending;

  /// No description provided for @loadingMorePosts.
  ///
  /// In en, this message translates to:
  /// **'Loading more posts...'**
  String get loadingMorePosts;

  /// No description provided for @beFirstToShare.
  ///
  /// In en, this message translates to:
  /// **'Be the first to share something amazing!'**
  String get beFirstToShare;

  /// No description provided for @searchByPostContent.
  ///
  /// In en, this message translates to:
  /// **'Search by post content'**
  String get searchByPostContent;

  /// No description provided for @noPostsMatch.
  ///
  /// In en, this message translates to:
  /// **'No posts match your search'**
  String get noPostsMatch;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @welcomeToPlantie.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Plantie!'**
  String get welcomeToPlantie;

  /// No description provided for @discoverPlantCare.
  ///
  /// In en, this message translates to:
  /// **'Discover expert plant care tips and join a community of plant lovers'**
  String get discoverPlantCare;

  /// No description provided for @getOtpCode.
  ///
  /// In en, this message translates to:
  /// **'Get OTP Code'**
  String get getOtpCode;

  /// No description provided for @sendOtpSms.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send you a verification code via SMS'**
  String get sendOtpSms;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get phoneHint;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhone;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get selectCountry;

  /// No description provided for @whatsYourName.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get whatsYourName;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get nameHint;

  /// No description provided for @letsStart.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Start 🌱'**
  String get letsStart;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameTooShort;

  /// No description provided for @lettersAndSpacesOnly.
  ///
  /// In en, this message translates to:
  /// **'Letters and spaces only'**
  String get lettersAndSpacesOnly;

  /// No description provided for @noAccountNeeded.
  ///
  /// In en, this message translates to:
  /// **'No account or password needed'**
  String get noAccountNeeded;

  /// No description provided for @offlineTitle.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get offlineTitle;

  /// No description provided for @offlineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please check your network status and try refreshing.'**
  String get offlineSubtitle;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @aboutMe.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get aboutMe;

  /// No description provided for @contactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get contactInfo;

  /// No description provided for @bioPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add a short bio to let people know you...'**
  String get bioPlaceholder;

  /// No description provided for @phonePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add phone number'**
  String get phonePlaceholder;

  /// No description provided for @countryPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add your country'**
  String get countryPlaceholder;

  /// No description provided for @nameField.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get nameField;

  /// No description provided for @bioField.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bioField;

  /// No description provided for @phoneField.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneField;

  /// No description provided for @countryField.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryField;

  /// No description provided for @gallerySource.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get gallerySource;

  /// No description provided for @cameraSource.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get cameraSource;

  /// No description provided for @completeProfilePrompt.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile!'**
  String get completeProfilePrompt;

  /// No description provided for @completeProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fill in your bio, location, and phone details to look official.'**
  String get completeProfileSubtitle;

  /// No description provided for @unsavedChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get unsavedChangesTitle;

  /// No description provided for @unsavedChangesMsg.
  ///
  /// In en, this message translates to:
  /// **'You have modified details. Leaving now will discard all edits.'**
  String get unsavedChangesMsg;

  /// No description provided for @keepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep Editing'**
  String get keepEditing;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @successTitle.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get successTitle;

  /// No description provided for @profileUpdatedMsg.
  ///
  /// In en, this message translates to:
  /// **'Your profile information has been securely updated.'**
  String get profileUpdatedMsg;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccess;

  /// No description provided for @saveAvatar.
  ///
  /// In en, this message translates to:
  /// **'Save Avatar'**
  String get saveAvatar;

  /// No description provided for @plantDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Plant Diagnosis'**
  String get plantDiagnosis;

  /// No description provided for @recentDiagnoses.
  ///
  /// In en, this message translates to:
  /// **'Recent Diagnoses'**
  String get recentDiagnoses;

  /// No description provided for @scanPlantPrompt.
  ///
  /// In en, this message translates to:
  /// **'Identify Plant Diseases'**
  String get scanPlantPrompt;

  /// No description provided for @scanPlantSubPrompt.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of a leaf to get an instant diagnosis and treatment plan.'**
  String get scanPlantSubPrompt;

  /// No description provided for @startScan.
  ///
  /// In en, this message translates to:
  /// **'Start Scan'**
  String get startScan;

  /// No description provided for @analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing Image...'**
  String get analyzing;

  /// No description provided for @notAPlant.
  ///
  /// In en, this message translates to:
  /// **'Not a Plant'**
  String get notAPlant;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @scanAnother.
  ///
  /// In en, this message translates to:
  /// **'Scan Another'**
  String get scanAnother;

  /// No description provided for @noHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistoryYet;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'days ago'**
  String get daysAgo;

  /// No description provided for @postedBy.
  ///
  /// In en, this message translates to:
  /// **'Post by'**
  String get postedBy;

  /// No description provided for @avatar.
  ///
  /// In en, this message translates to:
  /// **'avatar'**
  String get avatar;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get showMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// No description provided for @likes.
  ///
  /// In en, this message translates to:
  /// **'likes'**
  String get likes;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get like;

  /// No description provided for @writeComment.
  ///
  /// In en, this message translates to:
  /// **'Write comment'**
  String get writeComment;

  /// No description provided for @likePost.
  ///
  /// In en, this message translates to:
  /// **'Like post'**
  String get likePost;

  /// No description provided for @unlikePost.
  ///
  /// In en, this message translates to:
  /// **'Unlike post'**
  String get unlikePost;

  /// No description provided for @postActions.
  ///
  /// In en, this message translates to:
  /// **'Post actions'**
  String get postActions;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// No description provided for @postOptions.
  ///
  /// In en, this message translates to:
  /// **'Post options'**
  String get postOptions;

  /// No description provided for @deletePost.
  ///
  /// In en, this message translates to:
  /// **'Delete Post'**
  String get deletePost;

  /// No description provided for @deletePostQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete Post?'**
  String get deletePostQuestion;

  /// No description provided for @deletePostConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this post? This action cannot be undone.'**
  String get deletePostConfirmation;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternet;

  /// No description provided for @checkNetwork.
  ///
  /// In en, this message translates to:
  /// **'Please check your network status and try refreshing.'**
  String get checkNetwork;

  /// No description provided for @errorLoadingPosts.
  ///
  /// In en, this message translates to:
  /// **'Error loading posts'**
  String get errorLoadingPosts;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @postCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Post created successfully!'**
  String get postCreatedSuccessfully;

  /// No description provided for @userDataNotFound.
  ///
  /// In en, this message translates to:
  /// **'User data not found. Please log in again.'**
  String get userDataNotFound;

  /// No description provided for @noCommentsYet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get noCommentsYet;

  /// No description provided for @beFirstToComment.
  ///
  /// In en, this message translates to:
  /// **'Be the first to comment'**
  String get beFirstToComment;

  /// No description provided for @postingComment.
  ///
  /// In en, this message translates to:
  /// **'Posting comment...'**
  String get postingComment;

  /// No description provided for @offlineSaveError.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network and try again.'**
  String get offlineSaveError;

  /// No description provided for @offlineAvatarError.
  ///
  /// In en, this message translates to:
  /// **'Cannot update avatar while offline. Please connect to the internet.'**
  String get offlineAvatarError;

  /// No description provided for @arShort.
  ///
  /// In en, this message translates to:
  /// **'AR'**
  String get arShort;

  /// No description provided for @enShort.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get enShort;

  /// No description provided for @preferencesAndOptions.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES & OPTIONS'**
  String get preferencesAndOptions;

  /// No description provided for @offlineLikeError.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Like will be saved when you\'re back online.'**
  String get offlineLikeError;

  /// No description provided for @offlineCommentError.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Your comment will be saved when you\'re back online.'**
  String get offlineCommentError;

  /// No description provided for @offlineLoadMoreError.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Cannot load more posts.'**
  String get offlineLoadMoreError;

  /// No description provided for @detectionTimeoutError.
  ///
  /// In en, this message translates to:
  /// **'Analysis took too long. Please try again with a clearer image.'**
  String get detectionTimeoutError;

  /// No description provided for @invalidImageError.
  ///
  /// In en, this message translates to:
  /// **'Could not read the image. Please select a valid photo.'**
  String get invalidImageError;

  /// No description provided for @outOfMemoryError.
  ///
  /// In en, this message translates to:
  /// **'Image is too large. Please use a smaller photo.'**
  String get outOfMemoryError;

  /// No description provided for @notAPlantError.
  ///
  /// In en, this message translates to:
  /// **'The image does not appear to contain a plant leaf.'**
  String get notAPlantError;

  /// No description provided for @detectionGenericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get detectionGenericError;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetConnection;

  /// No description provided for @offlinePostMessage.
  ///
  /// In en, this message translates to:
  /// **'You are currently offline. Your post will be saved and uploaded when you regain internet connection.'**
  String get offlinePostMessage;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @commentFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not post comment. Please try again.'**
  String get commentFailed;

  /// No description provided for @failedToLoadPlants.
  ///
  /// In en, this message translates to:
  /// **'Failed to load plants'**
  String get failedToLoadPlants;

  /// No description provided for @failedToLoadPlantsMessage.
  ///
  /// In en, this message translates to:
  /// **'Unable to load plant data. Please check your internet connection and try again.'**
  String get failedToLoadPlantsMessage;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @aiAssistantEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'How can I help you?'**
  String get aiAssistantEmptyTitle;

  /// No description provided for @aiAssistantEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask me anything about plants, farming, or gardening.'**
  String get aiAssistantEmptySubtitle;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// No description provided for @clearChat.
  ///
  /// In en, this message translates to:
  /// **'Clear Chat'**
  String get clearChat;

  /// No description provided for @clearChatConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear this conversation?'**
  String get clearChatConfirmation;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @noFreeMessages.
  ///
  /// In en, this message translates to:
  /// **'No free messages left.'**
  String get noFreeMessages;

  /// No description provided for @noFreeMessagesShort.
  ///
  /// In en, this message translates to:
  /// **'0 free'**
  String get noFreeMessagesShort;

  /// No description provided for @watchAdButton.
  ///
  /// In en, this message translates to:
  /// **'Watch Ad'**
  String get watchAdButton;

  /// No description provided for @freeCount.
  ///
  /// In en, this message translates to:
  /// **'{count} free'**
  String freeCount(int count);

  /// No description provided for @rewardReceived.
  ///
  /// In en, this message translates to:
  /// **'🎉 +1 free chat! You now have {count} remaining.'**
  String rewardReceived(int count);

  /// No description provided for @adFailedToShow.
  ///
  /// In en, this message translates to:
  /// **'Ad failed to show. Please try again.'**
  String get adFailedToShow;

  /// No description provided for @adNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Ad not available. Please try again later.'**
  String get adNotAvailable;

  /// No description provided for @offlineLikeMessage.
  ///
  /// In en, this message translates to:
  /// **'You are offline. Please try again when you have a connection.'**
  String get offlineLikeMessage;

  /// No description provided for @chatOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get chatOfflineTitle;

  /// No description provided for @chatOfflineMessage.
  ///
  /// In en, this message translates to:
  /// **'The AI Assistant needs an internet connection to work. Please connect and try again.'**
  String get chatOfflineMessage;

  /// No description provided for @askAIAssistant.
  ///
  /// In en, this message translates to:
  /// **'Ask AI Assistant'**
  String get askAIAssistant;

  /// No description provided for @askAIAssistantSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get instant farming advice'**
  String get askAIAssistantSubtitle;

  /// No description provided for @weather_permission_title.
  ///
  /// In en, this message translates to:
  /// **'Weather for Your Farm'**
  String get weather_permission_title;

  /// No description provided for @weather_permission_message.
  ///
  /// In en, this message translates to:
  /// **'We need your location to show accurate weather and farming advice for your area.'**
  String get weather_permission_message;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @allow_access.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow_access;

  /// No description provided for @tapToGetWeather.
  ///
  /// In en, this message translates to:
  /// **'Tap to get weather'**
  String get tapToGetWeather;

  /// No description provided for @permission_required.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permission_required;

  /// No description provided for @location_permission_denied_forever.
  ///
  /// In en, this message translates to:
  /// **'Location permission has been permanently denied. Please enable it in your device settings to use weather features.'**
  String get location_permission_denied_forever;

  /// No description provided for @open_settings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get open_settings;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return SAr();
    case 'en':
      return SEn();
  }

  throw FlutterError(
      'S.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
