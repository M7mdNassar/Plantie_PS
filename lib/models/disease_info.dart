class DiseaseData {
  final String nameEn;
  final String nameAr;
  final String treatment;
  final String tips;

  const DiseaseData(this.nameEn, this.nameAr, this.treatment, this.tips);
}

class DiseaseInfo {
  static const Map<String, DiseaseData> data = {
    "Apple___Apple_scab": DiseaseData(
      "Apple scab",
      "جرب التفاح",
      "score 250 EC",
      "يجب إزالة الأوراق والفروع المصابة واحتراقها، واستخدام مبيدات الفطريات المناسبة.",
    ),
    "Apple___Black_rot": DiseaseData(
      "Apple black rot",
      "تعفن أسود",
      "score 250 EC",
      "يجب إزالة الفواكه والأوراق المصابة واحتراقها، واستخدام المبيدات الفطرية المناسبة.",
    ),
    "Apple___Cedar_apple_rust": DiseaseData(
      "Cedar apple rust",
      "صدأ تفاح الأرز",
      "score 250 EC",
      "يجب إزالة الأغصان المصابة واستخدام مبيدات الفطريات.",
    ),
    "Apple___healthy": DiseaseData(
      "Healthy",
      "صحي",
      "لا تحتاج الى مبيدات",
      "لا يحتاج إلى علاج.",
    ),
    "Bean___angular_leaf_spot": DiseaseData(
      "Bean angular leaf spot",
      "بقعة الورقة الزاوية",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة والحفاظ على نظافة المزرعة.",
    ),
    "Bean___healthy": DiseaseData(
      "Healthy",
      "صحي",
      "",
      "لا يحتاج إلى علاج.",
    ),
    "Bean___rust": DiseaseData(
      "Bean rust",
      "صدأ الفول",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة.",
    ),
    "Corn___Cercospora_leaf_spot Gray_leaf_spot": DiseaseData(
      "Gray leaf spot",
      "بقعة ورقة سيركوسبورا",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة والحد من الرطوبة.",
    ),
    "Corn___Common_rust": DiseaseData(
      "Common corn rust",
      "صدأ الذرة الشائع",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة.",
    ),
    "Corn___Northern_Leaf_Blight": DiseaseData(
      "Northern leaf blight",
      "اللفحة الشمالية للورقة",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة.",
    ),
    "Corn___healthy": DiseaseData(
      "Healthy",
      "صحي",
      "",
      "لا يحتاج إلى علاج.",
    ),
    "Cucumber___Anthracnose": DiseaseData(
      "Anthracnose",
      "أنثراكنوز",
      "score 250 EC",
      "إزالة الأجزاء المصابة واستخدام مبيدات الفطريات المناسبة.",
    ),
    "Cucumber___Gummy Stem Blight": DiseaseData(
      "Gummy stem blight",
      "اللفحة الجذعية اللزجة",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة وتجنب الرطوبة الزائدة.",
    ),
    "Cucumber___healthy": DiseaseData(
      "Healthy",
      "صحي",
      "",
      "لا يحتاج إلى علاج.",
    ),
    "Grape___Black_rot": DiseaseData(
      "Grape black rot",
      "تعفن أسود العنب",
      "switch",
      "إزالة الأوراق والفواكه المصابة واستخدام مبيدات الفطريات المناسبة.",
    ),
    "Grape___Esca_(Black_Measles)": DiseaseData(
      "Esca (black measles)",
      "إيسكا (حصبة سوداء)",
      "score 250 EC",
      "إزالة الأجزاء المصابة من النبات.",
    ),
    "Grape___Leaf_blight_(Isariopsis_Leaf_Spot)": DiseaseData(
      "Leaf blight",
      "لفحة الورقة (بقعة ورقة إيساريوبيس)",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة.",
    ),
    "Grape___healthy": DiseaseData(
      "Healthy",
      "صحي",
      "",
      "لا يحتاج إلى علاج.",
    ),
    "Pepper_bell___Bacterial_spot": DiseaseData(
      "Bacterial spot",
      "بقعة بكتيرية",
      "score 250 EC",
      "استخدام المبيدات البكتيرية المناسبة.",
    ),
    "Pepper_bell___healthy": DiseaseData(
      "Healthy",
      "صحي",
      "",
      "لا يحتاج إلى علاج.",
    ),
    "Potato___Early_blight": DiseaseData(
      "Early blight",
      "اللفحة المبكرة",
      "score 250 EC",
      "إزالة الأجزاء المصابة واستخدام مبيدات الفطريات المناسبة.",
    ),
    "Potato___Late_blight": DiseaseData(
      "Late blight",
      "اللفحة المتأخرة",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة.",
    ),
    "Potato___healthy": DiseaseData(
      "Healthy",
      "صحي",
      "",
      "لا يحتاج إلى علاج.",
    ),
    "Strawberry___Leaf_scorch": DiseaseData(
      "Leaf scorch",
      "حرق الورقة",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة.",
    ),
    "Strawberry___healthy": DiseaseData(
      "Healthy",
      "صحي",
      "",
      "لا يحتاج إلى علاج.",
    ),
    "Tomato___Bacterial_spot": DiseaseData(
      "Bacterial spot",
      "بقعة بكتيرية",
      "score 250 EC",
      "استخدام المبيدات البكتيرية المناسبة.",
    ),
    "Tomato___Early_blight": DiseaseData(
      "Early blight",
      "اللفحة المبكرة",
      "score 250 EC",
      "إزالة الأوراق المصابة واستخدام مبيدات الفطريات المناسبة.",
    ),
    "Tomato___Late_blight": DiseaseData(
      "Late blight",
      "اللفحة المتأخرة",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة.",
    ),
    "Tomato___Leaf_Mold": DiseaseData(
      "Leaf mold",
      "عفن الأوراق",
      "score 250 EC",
      "إزالة الأوراق المصابة واستخدام مبيدات الفطريات.",
    ),
    "Tomato___Septoria_leaf_spot": DiseaseData(
      "Septoria leaf spot",
      "بقعة أوراق سيبتوريا",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة.",
    ),
    "Tomato___Spider_mites Two-spotted_spider_mite": DiseaseData(
      "Two-spotted spider mite",
      "سوس العنكبوت ذو البقعتين",
      "score 250 EC",
      "استخدام المبيدات الحشرية المناسبة.",
    ),
    "Tomato___Target_Spot": DiseaseData(
      "Target spot",
      "بقعة الهدف",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة.",
    ),
    "Tomato___Tomato_mosaic_virus": DiseaseData(
      "Tomato mosaic virus",
      "فيروس موزاييك الطماطم",
      "score 250 EC",
      "إزالة النباتات المصابة.",
    ),
    "Tomato___healthy": DiseaseData(
      "Healthy",
      "صحي",
      "",
      "لا يحتاج إلى علاج.",
    ),
    "olive_aculus_olearius": DiseaseData(
      "Olive aculus olearius",
      "أكلوس أوليريوس الزيتون",
      "score 250 EC",
      "استخدام المبيدات الحشرية المناسبة.",
    ),
    "olive_healthy": DiseaseData(
      "Olive healthy",
      "صحي",
      "",
      "لا يحتاج إلى علاج.",
    ),
    "olive_peacock_spot": DiseaseData(
      "Olive peacock spot",
      "بقعة الطاووس الزيتون",
      "funguran",
      "استخدام مبيدات الفطريات المناسبة.",
    ),
  };

  /// Returns the localized disease name based on the app's language.
  static String getLocalizedName(String diseaseKey, String languageCode) {
    final data = DiseaseInfo.data[diseaseKey];
    if (data == null) return diseaseKey;
    return languageCode == 'ar' ? data.nameAr : data.nameEn;
  }

  /// Returns the treatment (localized? currently only Arabic).
  static String getTreatment(String diseaseKey) {
    return DiseaseInfo.data[diseaseKey]?.treatment ?? '';
  }

  /// Returns the tips (localized? currently only Arabic).
  static String getTips(String diseaseKey) {
    return DiseaseInfo.data[diseaseKey]?.tips ?? '';
  }
}