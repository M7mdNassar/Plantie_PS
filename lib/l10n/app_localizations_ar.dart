// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class SAr extends S {
  SAr([String locale = 'ar']) : super(locale);

  @override
  String get onboardingTitle1 => 'مرحبًا بكم في Plantie!';

  @override
  String get onboardingBody1 =>
      'ابق على اطلاع بآخر التحديثات حول الطقس ونصائح العناية بالنباتات المخصصة لاحتياجاتك، واحسب الكمية المناسبة من الأسمدة لنمو مثالي للنباتات.';

  @override
  String get onboardingTitle2 => 'اكتشف أمراض النباتات';

  @override
  String get onboardingBody2 =>
      'قم بتحميل صورة لنبتتك لتحديد الأمراض والحصول على حلول خبراء فورية.';

  @override
  String get onboardingTitle3 => 'ابحث عن متاجر النباتات القريبة';

  @override
  String get onboardingBody3 =>
      'ابحث بسهولة عن متاجر النباتات القريبة بلمسة واحدة لمساعدتك في العناية بنباتاتك بشكل أفضل.';

  @override
  String get onboardingTitle4 => 'انضم إلى مجتمع Plantie';

  @override
  String get onboardingBody4 =>
      'تواصل مع محبي النباتات الآخرين، شارك النصائح وتعلم من الآخرين لتنمية مساحتك الخضراء معًا.';

  @override
  String get skip => 'تخطي';

  @override
  String get welcome_title => 'بلانتي';

  @override
  String get welcome_subtitle => 'احصل على المزيد من المحاصيل بمساعدة بلانتي!';

  @override
  String get login_button => 'تسجيل الدخول';

  @override
  String get register_button => 'إنشاء حساب';

  @override
  String get terms_and_conditions =>
      'بتسجيل الدخول أو إنشاء حساب، فإنك توافق على شروط الخدمة وسياسة الخصوصية الخاصة بنا';

  @override
  String get welcome => 'مرحباً';

  @override
  String get welcome_back => 'مرحباً، أهلاً بك مجدداً في بلانتي!';

  @override
  String get email_address => 'عنوان البريد الإلكتروني';

  @override
  String get enter_email => 'يرجى إدخال عنوان البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get enter_password => 'كلمة المرور قصيرة جداً';

  @override
  String get forget_password => 'هل نسيت كلمة المرور؟';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get create_account => 'إنشاء حساب؟';

  @override
  String get register => 'تسجيل';

  @override
  String get or_login_by => 'أو تسجيل الدخول بواسطة';

  @override
  String get reset_password => 'إعادة تعيين كلمة المرور';

  @override
  String get sent_email_to_update_paassword =>
      'تم ارسال رابط اعاده كلمه المرور علي الايميل';

  @override
  String get submit => 'إرسال';

  @override
  String get cancel => 'إلغاء';

  @override
  String get name => 'الإسم';

  @override
  String get creat_account2 => 'إنشاء حساب';

  @override
  String get create_account3 => 'أكمل معلوماتك للبدء';

  @override
  String get enter_name => 'الرجاء إدخال إسم المستخدم';

  @override
  String get email_valid => 'الرجاء إدخال بريد إلكتروني صالح';

  @override
  String get or_register_by => 'أو التسجيل بواسطة';

  @override
  String get have_account => 'هل لديك حساب ؟';

  @override
  String get weather => 'الطقس';

  @override
  String get choosePlant => 'اختر نبتة';

  @override
  String get calculateFertilizer => 'حساب السماد';

  @override
  String get description => 'الوصف';

  @override
  String get nutrition => 'التغذية';

  @override
  String get storage => 'التخزين';

  @override
  String get diseases => 'الأمراض';

  @override
  String get plantingTime => 'وقت الزراعة';

  @override
  String get npkFormula => 'تركيبة NPK';

  @override
  String get temperature => 'درجة الحرارة';

  @override
  String get humidity => 'الرطوبة';

  @override
  String get prevention => 'الوقاية';

  @override
  String get fetchingWeather => 'جاري جلب بيانات الطقس...';

  @override
  String get locationRequired => 'يطلب إذن الموقع';

  @override
  String get enableLocation => 'تفعيل الموقع';

  @override
  String get permanentDenial =>
      'تم رفض إذن الموقع بشكل دائم. يرجى التفعيل من الإعدادات.';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get gpsDisabled => 'خدمة الموقع معطلة. يرجى تفعيل GPS.';

  @override
  String get enableGPS => 'تفعيل GPS';

  @override
  String weatherError(Object error) {
    return 'خطأ في جلب بيانات الطقس: $error';
  }

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get getWeather => 'احصل على الطقس';

  @override
  String feelsLike(Object temp) {
    return 'تشعر بـ $temp°م';
  }

  @override
  String get weather_details => 'تفاصيل الطقس';

  @override
  String get current_weather => 'الطقس الحالي';

  @override
  String get feels_like => 'الحرارة المحسوسة';

  @override
  String get wind_speed => 'سرعة الرياح';

  @override
  String get pressure => 'الضغط الجوي';

  @override
  String get sunrise => 'شروق الشمس';

  @override
  String get sunset => 'غروب الشمس';

  @override
  String get farming_insights => 'نصائح زراعية';

  @override
  String get hourly_forecast => 'توقعات الساعات القادمة';

  @override
  String get daily_forecast => 'توقعات ٧ أيام';

  @override
  String get today => 'اليوم';

  @override
  String get soil_temp => 'درجة حرارة التربة';

  @override
  String get evapotranspiration => 'التبخر والنتح';

  @override
  String get precipitation => 'هطول الأمطار';

  @override
  String get humidity_level => 'الرطوبة';

  @override
  String get no_insights => 'لا توجد تنبيهات محددة اليوم.';

  @override
  String get good_for_farming => 'الظروف جيدة للأنشطة الزراعية.';

  @override
  String get warning_farming =>
      'يرجى توخي الحذر عند القيام ببعض الأنشطة الزراعية.';

  @override
  String get critical_farming =>
      'خطر عالٍ! اتخذ إجراءات فورية لحماية المحاصيل.';

  @override
  String get recommendation => 'توصية';

  @override
  String get weather_trends => 'اتجاهات الطقس';

  @override
  String get temperature_chart => 'درجة الحرارة';

  @override
  String get precipitation_chart => 'هطول الأمطار';

  @override
  String fertilizerCalculator(Object emoji, Object name) {
    return '$emoji $name سماد';
  }

  @override
  String plantType(Object type) {
    return 'النوع: $type';
  }

  @override
  String landArea(Object unit) {
    return 'المساحة ($unit):';
  }

  @override
  String get numberOfTrees => 'عدد الأشجار';

  @override
  String get treeAge => 'عمر الشجرة (سنوات)';

  @override
  String get recommendedNpk => 'نسبة NPK الموصى بها:';

  @override
  String get calculateRequirements => 'حساب المتطلبات';

  @override
  String requiredFertilizers(Object calculationContext) {
    return 'السماد المطلوب ($calculationContext):';
  }

  @override
  String treeNote(Object age) {
    return 'ملاحظة: الحسابات تشمل عامل العمر لأشجار عمرها $age سنوات';
  }

  @override
  String get areaNote => 'ملاحظة: 1 دونم = 1000 متر مربع (10,000 قدم مربع)';

  @override
  String get nitrogen => 'النيتروجين';

  @override
  String get phosphorus => 'الفوسفور';

  @override
  String get potassium => 'البوتاسيوم';

  @override
  String get dunam => 'دونم';

  @override
  String get acre => 'فدان';

  @override
  String get unit => 'الوحدة:';

  @override
  String get urea => 'يوريا';

  @override
  String get ssp => 'سوبر فوسفات';

  @override
  String get mop => 'كلوريد البوتاسيوم';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get darkMode => 'الوضع الليلي';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get confirmLogout => 'تأكيد الخروج';

  @override
  String get logoutMessage => 'هل أنت متأكد من رغبتك في تسجيل الخروج؟';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get save => 'حفظ';

  @override
  String get bio => 'السيرة الذاتية';

  @override
  String get country => 'الدولة';

  @override
  String get phone => 'الهاتف';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get nameRequired => 'الاسم مطلوب';

  @override
  String get bioRequired => 'السيرة الذاتية مطلوبة';

  @override
  String get countryRequired => 'الدولة مطلوبة';

  @override
  String get phoneRequired => 'الهاتف مطلوب';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String updateFailed(Object error) {
    return 'فشل التحديث: $error';
  }

  @override
  String get namefield => 'الاسم';

  @override
  String get phoneOptional => 'الهاتف (اختياري)';

  @override
  String get bioOptional => 'نبذة عني (اختياري)';

  @override
  String get countryOptional => 'الدولة (اختياري)';

  @override
  String get bioHint => 'أخبر المزارعين الآخرين عن نفسك...';

  @override
  String bioCharCount(Object current, Object max) {
    return '$current/$max';
  }

  @override
  String get settings => 'الإعدادات';

  @override
  String get logoutConfirm => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get refresh => 'تحديث';

  @override
  String get home => 'الرئيسية';

  @override
  String get community => 'المجتمع';

  @override
  String get detection => 'الكشف';

  @override
  String get profile2 => 'ملفي';

  @override
  String get verificationSent =>
      'تم إعادة إرسال البريد التأكيدي. يرجى فحص صندوق الوارد.';

  @override
  String verificationError(Object error) {
    return 'خطأ في إرسال التأكيد: $error';
  }

  @override
  String get detectionResults => 'نتائج الكشف';

  @override
  String get detectionResult => 'نتيجة الكشف';

  @override
  String get recommendedTreatment => 'العلاج الموصى به';

  @override
  String get history => 'السجل';

  @override
  String get noDetectionHistory => 'لا يوجد سجل كشف';

  @override
  String get historyPlaceholder => 'سيظهر هنا مسحات صحة النبات الخاصة بك';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get deleteConfirmation => 'هل أنت متأكد من رغبتك في حذف هذا العنصر؟';

  @override
  String get delete => 'حذف';

  @override
  String treatmentLabel(Object treatment) {
    return '$treatment';
  }

  @override
  String get treatment => 'العلاج';

  @override
  String get tips => 'النصائح';

  @override
  String get date => 'التاريخ';

  @override
  String get nearestNursery => 'أقرب مشتل نباتات';

  @override
  String get noStoresFound => 'لم يتم العثور على مشاتل قريبة';

  @override
  String locationError(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get launchError => 'تعذر فتح الخرائط';

  @override
  String get tap_camera_to_scan =>
      'اضغط على زر الكاميرا أدناه\nلبدء فحص نباتاتك';

  @override
  String get searchPosts => 'البحث في المنشورات';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get comments => 'التعليقات';

  @override
  String get write_comment => 'أكتب تعليق ...';

  @override
  String get no_posts => 'لا يوجد منشورات';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get postButton => 'نشر';

  @override
  String get whatsOnMind => 'ما الذي يدور في ذهنك؟';

  @override
  String get addPhotos => 'إضافة صور';

  @override
  String get positioningTips => 'نصائح حول الوضعية';

  @override
  String get positioningTip1 => 'التقط الصورة في إضاءة طبيعية جيدة';

  @override
  String get positioningTip2 => 'املأ الإطار بالورقة';

  @override
  String get positioningTip3 => 'تجنب الظلال على الورقة';

  @override
  String get focusRequirements => 'متطلبات التركيز';

  @override
  String get focusTip1 => 'تأكد من وضوح حواف الورقة';

  @override
  String get focusTip2 => 'ركز على المناطق المصابة';

  @override
  String get focusTip3 => 'حافظ على ثبات الكاميرا';

  @override
  String get backgroundTips => 'نصائح حول الخلفية';

  @override
  String get backgroundTip1 => 'استخدم خلفية بسيطة';

  @override
  String get backgroundTip2 => 'يُفضل الألوان البيضاء أو الفاتحة';

  @override
  String get backgroundTip3 => 'تجنب الخلفيات المزخرفة';

  @override
  String get captureGuidelines => 'إرشادات الالتقاط';

  @override
  String get iUnderstand => 'فهمت - المتابعة';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get chooseFromGallery => 'اختر من المعرض';

  @override
  String errorOccurred(Object error) {
    return 'حدث خطأ: $error';
  }

  @override
  String get unknownDisease => 'غير معروف';

  @override
  String get noDetails => '';

  @override
  String get diseaseNotDetected => 'لم يتم التعرف على المرض';

  @override
  String get good => 'جيد';

  @override
  String get avoid => 'تجنب';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get languageChanged => 'تم تغيير اللغة. أعد تشغيل التطبيق؟';

  @override
  String get irrigation_alert => 'تنبيه الري';

  @override
  String irrigation_message(Object value) {
    return 'تم رصد أمطار غزيرة ($value ملم). لا تقم بالري اليوم لتجنب تشبع التربة بالماء.';
  }

  @override
  String get wind_warning => 'تحذير الرياح';

  @override
  String wind_message(Object value) {
    return 'سرعة رياح عالية ($value كم/ساعة). تجنب رش المبيدات لأنها قد تتطاير.';
  }

  @override
  String get ideal_spraying => 'رش مثالي';

  @override
  String get ideal_spraying_message => 'الرياح هادئة. وقت جيد لرش المبيدات.';

  @override
  String get frost_risk => 'خطر الصقيع';

  @override
  String frost_message(Object value) {
    return 'درجة الحرارة منخفضة ($value°م). خطر كبير لحدوث الصقيع. قم بحماية المحاصيل الحساسة.';
  }

  @override
  String get high_evaporation => 'تبخر عالٍ';

  @override
  String high_evaporation_message(Object value) {
    return 'معدل التبخر والنتح مرتفع ($value ملم). فكر في زيادة عدد مرات الري.';
  }

  @override
  String get soil_condition => 'حالة التربة';

  @override
  String soil_condition_message(Object value) {
    return 'درجة حرارة التربة $value°م، مثالية لإنبات معظم البذور.';
  }

  @override
  String get analyzingImage => 'جاري تحليل الصورة...';

  @override
  String get pleaseWait => 'يرجى الانتظار بينما يكتشف الذكاء الاصطناعي...';

  @override
  String get expertAdvice => 'نصيحة الخبير';

  @override
  String get findNearestStore => 'ابحث عن أقرب متجر';

  @override
  String get tipsForAccurateDetection => 'نصائح للكشف الدقيق';

  @override
  String get healthy => 'صحي';

  @override
  String get diseaseDetected => 'تم اكتشاف مرض';

  @override
  String get goodLighting => 'إضاءة جيدة';

  @override
  String get naturalSunlightWorks => 'أشعة الشمس الطبيعية تعمل بشكل أفضل';

  @override
  String get closeFocus => 'تركيز قريب';

  @override
  String get distanceFromLeaf => 'احصل على 15-30 سم من الورقة';

  @override
  String get clearImage => 'صورة واضحة';

  @override
  String get avoidBlurred => 'تجنب الصور الضبابية أو المائلة';

  @override
  String get singleLeaf => 'ورقة واحدة';

  @override
  String get focusOnDiseased => 'ركز على ورقة مريضة واحدة';

  @override
  String get deletedSuccessfully => 'تم الحذف بنجاح';

  @override
  String get itemDeleted => 'تم إزالة المسح الخاص بك';

  @override
  String get startDetection => 'ابدأ الكشف';

  @override
  String get tapCameraToDetect =>
      'اضغط على زر الكاميرا لالتقاط صورة نبات وبدء التشخيص';

  @override
  String get tapCamera => 'اضغط الكاميرا';

  @override
  String get followTheseSteps => 'اتبع هذه النصائح للحصول على أفضل النتائج';

  @override
  String get gotIt => 'فهمت';

  @override
  String get quickTipsForBestResults => 'نصائح سريعة للحصول على أفضل النتائج';

  @override
  String get goodLightingCapture => 'إضاءة جيدة';

  @override
  String get naturalLightWorks => 'الضوء الطبيعي يعمل بشكل أفضل';

  @override
  String get closeAndClear => 'قريب وواضح';

  @override
  String get distanceAndFocus => '15-30 سم من الورقة، تركيز حاد';

  @override
  String get singleLeafCapture => 'ورقة واحدة';

  @override
  String get focusOnOneDiseased => 'ركز على منطقة مريضة واحدة';

  @override
  String get continueButton => 'متابعة';

  @override
  String get homeSubtitle => 'اعتنِ بنباتاتك';

  @override
  String get grantLocationPermission => 'يرجى منح إذن الموقع لعرض تفاصيل الطقس';

  @override
  String get locationDenied => 'تم رفض إذن الموقع';

  @override
  String get allowAccess => 'السماح بالوصول';

  @override
  String get weatherErrorTitle => 'خطأ في تحميل الطقس';

  @override
  String get checkWeatherPrompt => 'تحقق من حالة الطقس في منطقتك';

  @override
  String get clearSky => 'سماء صافية';

  @override
  String get partlyCloudy => 'غائم جزئياً';

  @override
  String get foggy => 'ضبابي';

  @override
  String get drizzle => 'رذاذ';

  @override
  String get rainy => 'ممطر';

  @override
  String get snowy => 'ثلجي';

  @override
  String get rainShowers => 'زخات مطر';

  @override
  String get thunderstorm => 'عاصفة رعدية';

  @override
  String get noDiseases => 'لا توجد أمراض مسجلة';

  @override
  String get guestProfileTitle => 'الملف الشخصي';

  @override
  String get guestJoinTitle => 'انضم إلى Plantie';

  @override
  String get guestJoinSubtitle => 'اكتشف تجربة Plantie الكاملة';

  @override
  String get guestBenefit1Title => 'مزامنة سجلّك';

  @override
  String get guestBenefit1Desc => 'الوصول إلى سجل الفحوصات من أي جهاز';

  @override
  String get guestBenefit2Title => 'انضم إلى المجتمع';

  @override
  String get guestBenefit2Desc => 'أعجب وعلّق وشارك مع محبي النباتات';

  @override
  String get guestBenefit3Title => 'ساعد في تطوير Plantie';

  @override
  String get guestBenefit3Desc => 'ملاحظاتك تُحسّن دقة اكتشاف الأمراض للجميع';

  @override
  String get guestCreateAccount => 'إنشاء حساب';

  @override
  String get guestSignIn => 'تسجيل الدخول';

  @override
  String get guestBrowsingNote => 'تصفح كضيف • جميع الفحوصات محفوظة محلياً';

  @override
  String get guestPromptTitle => 'سجّل للانضمام';

  @override
  String get guestPromptDescription =>
      'أنشئ حسابًا للإعجاب والتعليق والمشاركة مع مجتمع Plantie';

  @override
  String get guestPromptSignUp => 'إنشاء حساب';

  @override
  String get guestPromptMaybeLater => 'ربما لاحقًا';

  @override
  String get guestCommunityTitle => 'شارك مع المجتمع';

  @override
  String get guestCommunityDescription =>
      'أنشئ حسابًا للنشر والإعجاب والتعليق مع محبي النباتات';

  @override
  String get noNewNotifications => 'لا توجد إشعارات جديدة';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get createNewPost => 'إنشاء منشور جديد';

  @override
  String get post => 'منشور';

  @override
  String get latest => 'الأحدث';

  @override
  String get popular => 'الأكثر شهرة';

  @override
  String get trending => 'الرائج';

  @override
  String get loadingMorePosts => 'جاري تحميل المزيد...';

  @override
  String get beFirstToShare => 'كن أول من يشارك شيئًا رائعًا!';

  @override
  String get searchByPostContent => 'ابحث باستخدام محتوى المنشور';

  @override
  String get noPostsMatch => 'لا توجد منشورات تطابق بحثك';

  @override
  String get clearSearch => 'مسح البحث';

  @override
  String get welcomeToPlantie => 'مرحباً بك في Plantie';

  @override
  String get discoverPlantCare => 'اكتشف فن العناية بالنباتات';

  @override
  String get getOtpCode => 'إرسال رمز التحقق';

  @override
  String get sendOtpSms => 'سنرسل لك رمز التحقق عبر SMS';

  @override
  String get continueAsGuest => 'المتابعة كضيف';

  @override
  String get phoneHint => 'أدخل رقم الهاتف';

  @override
  String get invalidPhone => 'رقم الهاتف غير صحيح';

  @override
  String get requiredField => 'هذا الحقل مطلوب';

  @override
  String get selectCountry => 'اختر الدولة';

  @override
  String get whatsYourName => 'ما اسمك؟';

  @override
  String get nameHint => 'اسمك';

  @override
  String get letsStart => 'لنبدأ 🌱';

  @override
  String get nameTooShort => 'الاسم يجب أن يكون حرفين على الأقل';

  @override
  String get lettersAndSpacesOnly => 'يسمح بالأحرف والمسافات فقط';

  @override
  String get noAccountNeeded => 'لا حاجة لحساب أو كلمة مرور';

  @override
  String get offlineTitle => 'لا يوجد اتصال بالإنترنت';

  @override
  String get offlineSubtitle =>
      'يرجى التحقق من حالة الشبكة والمحاولة مرة أخرى.';

  @override
  String get retryButton => 'إعادة المحاولة';

  @override
  String get aboutMe => 'نبذة عني';

  @override
  String get contactInfo => 'تفاصيل الاتصال';

  @override
  String get bioPlaceholder => 'أضف نبذة قصيرة ليعرفك الآخرون...';

  @override
  String get phonePlaceholder => 'أضف رقم الهاتف';

  @override
  String get countryPlaceholder => 'أضف بلد الإقامة';

  @override
  String get nameField => 'الاسم الكامل';

  @override
  String get bioField => 'النبذة الشخصية';

  @override
  String get phoneField => 'رقم الهاتف';

  @override
  String get countryField => 'البلد';

  @override
  String get gallerySource => 'اختيار من معرض الصور';

  @override
  String get cameraSource => 'التقاط صورة بالكاميرا';

  @override
  String get completeProfilePrompt => 'أكمل ملفك الشخصي!';

  @override
  String get completeProfileSubtitle =>
      'أضف نبذتك، موقعك، ورقم هاتفك ليصبح حسابك موثقاً.';

  @override
  String get unsavedChangesTitle => 'تغييرات غير محفوظة';

  @override
  String get unsavedChangesMsg =>
      'لقد قمت بتعديل البيانات. الخروج الآن سيؤدي إلى فقدان جميع التعديلات.';

  @override
  String get keepEditing => 'متابعة التعديل';

  @override
  String get discard => 'تجاهل التغييرات';

  @override
  String get successTitle => 'تم بنجاح';

  @override
  String get profileUpdatedMsg => 'تم تحديث بيانات ملفك الشخصي بأمان.';

  @override
  String get errorTitle => 'حدث خطأ ما';

  @override
  String get profileUpdatedSuccess => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get saveAvatar => 'حفظ الصورة';

  @override
  String get plantDiagnosis => 'تشخيص النباتات';

  @override
  String get recentDiagnoses => 'التشخيصات السابقة';

  @override
  String get scanPlantPrompt => 'اكتشف أمراض النباتات';

  @override
  String get scanPlantSubPrompt =>
      'التقط صورة لورقة النبتة للحصول على تشخيص فوري وخطة علاج.';

  @override
  String get startScan => 'بدء الفحص';

  @override
  String get analyzing => 'جاري تحليل الصورة...';

  @override
  String get notAPlant => 'ليست نبتة';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get scanAnother => 'فحص نبتة أخرى';

  @override
  String get noHistoryYet => 'لا يوجد سجل تشخيصات بعد';

  @override
  String get yesterday => 'أمس';

  @override
  String get daysAgo => 'أيام مضت';

  @override
  String get postedBy => 'منشور بواسطة';

  @override
  String get avatar => 'الصورة الشخصية';

  @override
  String get showMore => 'أظهر المزيد';

  @override
  String get showLess => 'إخفاء';

  @override
  String get likes => 'إعجاب';

  @override
  String get comment => 'تعليق';

  @override
  String get like => 'إعجاب';

  @override
  String get writeComment => 'اكتب تعليقاً';

  @override
  String get likePost => 'أعجبني المنشور';

  @override
  String get unlikePost => 'إلغاء الإعجاب';

  @override
  String get postActions => 'إجراءات المنشور';

  @override
  String get moreOptions => 'خيارات إضافية';

  @override
  String get postOptions => 'خيارات المنشور';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get deletePostQuestion => 'حذف المنشور؟';

  @override
  String get deletePostConfirmation =>
      'هل أنت متأكد من حذف هذا المنشور؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get noInternet => 'لا يوجد اتصال بالإنترنت';

  @override
  String get checkNetwork => 'يرجى التحقق من حالة الشبكة والمحاولة مرة أخرى.';

  @override
  String get errorLoadingPosts => 'خطأ في تحميل المنشورات';

  @override
  String get photos => 'الصور';

  @override
  String get postCreatedSuccessfully => 'تم إنشاء المنشور بنجاح!';

  @override
  String get userDataNotFound =>
      'لم يتم العثور على بيانات المستخدم. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get noCommentsYet => 'لا توجد تعليقات بعد';

  @override
  String get beFirstToComment => 'كن أول من يعلق';

  @override
  String get postingComment => 'جاري نشر التعليق...';

  @override
  String get offlineSaveError =>
      'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة والمحاولة مرة أخرى.';

  @override
  String get offlineAvatarError =>
      'لا يمكن تحديث الصورة الشخصية دون اتصال بالإنترنت. يرجى الاتصال بالإنترنت.';

  @override
  String get arShort => 'ع';

  @override
  String get enShort => 'إ';

  @override
  String get preferencesAndOptions => 'التفضيلات والإعدادات';

  @override
  String get offlineLikeError =>
      'لا يوجد اتصال بالإنترنت. سيتم حفظ الإعجاب عند عودة الاتصال.';

  @override
  String get offlineCommentError =>
      'لا يوجد اتصال بالإنترنت. سيتم حفظ تعليقك عند عودة الاتصال.';

  @override
  String get offlineLoadMoreError =>
      'لا يوجد اتصال بالإنترنت. لا يمكن تحميل المزيد من المنشورات.';

  @override
  String get detectionTimeoutError =>
      'استغرق التحليل وقتًا طويلاً. يرجى المحاولة مرة أخرى بصورة أوضح.';

  @override
  String get invalidImageError =>
      'لا يمكن قراءة الصورة. يرجى اختيار صورة صالحة.';

  @override
  String get outOfMemoryError => 'الصورة كبيرة جدًا. يرجى استخدام صورة أصغر.';

  @override
  String get notAPlantError => 'لا يبدو أن الصورة تحتوي على ورقة نبات.';

  @override
  String get detectionGenericError => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get offlinePostMessage =>
      'أنت غير متصل بالإنترنت حاليًا. سيتم حفظ مشاركتك وتحميلها عندما تستعيد الاتصال.';

  @override
  String get ok => 'حسنًا';

  @override
  String get commentFailed => 'لم يتم نشر التعليق. يرجى المحاولة مرة أخرى.';

  @override
  String get failedToLoadPlants => 'فشل تحميل النباتات';

  @override
  String get failedToLoadPlantsMessage =>
      'تعذر تحميل بيانات النباتات. يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.';

  @override
  String get aiAssistant => 'المساعد الذكي';

  @override
  String get aiAssistantEmptyTitle => 'كيف يمكنني مساعدتك؟';

  @override
  String get aiAssistantEmptySubtitle =>
      'اسألني أي شيء عن النباتات، الزراعة، أو البستنة.';

  @override
  String get typeMessage => 'اكتب رسالة...';

  @override
  String get clearChat => 'مسح المحادثة';

  @override
  String get clearChatConfirmation =>
      'هل أنت متأكد من رغبتك في مسح هذه المحادثة؟';

  @override
  String get clear => 'مسح';

  @override
  String get noFreeMessages => 'لا توجد رسائل مجانية متبقية.';

  @override
  String get noFreeMessagesShort => '0 مجانية';

  @override
  String get watchAdButton => 'شاهد الإعلان';

  @override
  String freeCount(int count) {
    return '$count مجانية';
  }

  @override
  String rewardReceived(int count) {
    return '🎉 +1 رسالة مجانية! الآن لديك $count متبقية.';
  }

  @override
  String get adFailedToShow => 'فشل عرض الإعلان. يرجى المحاولة مرة أخرى.';

  @override
  String get adNotAvailable => 'الإعلان غير متوفر. يرجى المحاولة لاحقاً.';

  @override
  String get offlineLikeMessage =>
      'أنت غير متصل. يرجى المحاولة مرة أخرى عند توفر الاتصال.';

  @override
  String get chatOfflineTitle => 'غير متصل بالإنترنت';

  @override
  String get chatOfflineMessage =>
      'المساعد الذكي يحتاج إلى اتصال بالإنترنت للعمل. يرجى الاتصال والمحاولة مرة أخرى.';

  @override
  String get askAIAssistant => 'اسأل المساعد الذكي';

  @override
  String get askAIAssistantSubtitle => 'احصل على نصائح زراعية فورية';

  @override
  String get weather_permission_title => 'الطقس لمزرعتك';

  @override
  String get weather_permission_message =>
      'نحتاج إلى موقعك لعرض الطقس الدقيق ونصائح الزراعة لمنطقتك.';

  @override
  String get notNow => 'ليس الآن';

  @override
  String get allow_access => 'السماح';

  @override
  String get tapToGetWeather => 'اضغط للحصول على الطقس';

  @override
  String get permission_required => 'الصلاحية مطلوبة';

  @override
  String get location_permission_denied_forever =>
      'تم رفض صلاحية الموقع بشكل دائم. يرجى تمكينها من إعدادات الجهاز لاستخدام ميزات الطقس.';

  @override
  String get open_settings => 'فتح الإعدادات';

  @override
  String get followers => 'المتابعون';

  @override
  String get following => 'المتابعة';

  @override
  String get follow => 'متابعة';

  @override
  String get unfollow => 'إلغاء المتابعة';

  @override
  String get joinDate => 'تاريخ الانضمام';

  @override
  String get userNotFound => 'المستخدم غير موجود';

  @override
  String get noPostsYet => 'لا توجد منشورات بعد';

  @override
  String get hasNoPosts => 'ليس لديه منشورات بعد';

  @override
  String get about => 'عن';

  @override
  String get posts => 'المنشورات';

  @override
  String get searchUsers => 'بحث عن مستخدمين';

  @override
  String get searchUsersHint => 'ابحث بالاسم...';

  @override
  String get searchUsersEmpty => 'اكتب اسماً للبحث';

  @override
  String get noUsersFound => 'لم يتم العثور على مستخدمين';

  @override
  String get viewProfile => 'عرض الملف';

  @override
  String get postDetails => 'تفاصيل المنشور';

  @override
  String get postNotFound => 'المنشور غير موجود';

  @override
  String get weather_unavailable_title => 'ميزة الطقس غير متاحة مؤقتاً.';

  @override
  String get weather_unavailable_subtitle => 'يرجى العودة لاحقاً.';

  @override
  String get community_unavailable_title => 'ميزة المجتمع غير متاحة مؤقتاً.';

  @override
  String get community_unavailable_subtitle => 'يرجى العودة لاحقاً.';

  @override
  String get update_required_title => 'تحديث مطلوب';

  @override
  String get update_required_message =>
      'يتوفر إصدار جديد من Plantie. يرجى التحديث لمواصلة استخدام التطبيق.';

  @override
  String get update_now => 'تحديث الآن';

  @override
  String get pendingUploadsTitle => 'مرفوعات معلقة';

  @override
  String pendingUploadsMessage(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عناصر',
      one: 'عنصر',
    );
    return 'لديك $count $_temp0 معلقة للمزامنة.';
  }

  @override
  String get syncNow => 'مزامنة الآن';

  @override
  String get offlineSyncWait => 'في انتظار الاتصال...';

  @override
  String get fetchingLocation => 'جاري جلب الموقع...';

  @override
  String get unknownLocation => 'موقع غير معروف';

  @override
  String get chat_unavailable_title => 'المساعد الذكي غير متاح';

  @override
  String get chat_unavailable_subtitle =>
      'خدمة المحادثة معطلة حالياً. يرجى المحاولة لاحقاً.';
}
