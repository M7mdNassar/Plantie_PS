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
