class DiseaseData {
  final String name;
  final String treatment;
  final String tips;

  const DiseaseData(this.name, this.treatment, this.tips);
}

class DiseaseInfo {
  static const Map<String, DiseaseData> data = {
    "Apple___Apple_scab": DiseaseData(
      "جرب التفاح",
      "score 250 EC",
      "يجب إزالة الأوراق والفروع المصابة واحتراقها، واستخدام مبيدات الفطريات المناسبة.",
    ),
    "Apple___Black_rot": DiseaseData(
      "تعفن أسود",
      "score 250 EC",
      "يجب إزالة الفواكه والأوراق المصابة واحتراقها، واستخدام المبيدات الفطرية المناسبة.",
    ),
    "Apple___Cedar_apple_rust": DiseaseData(
      "صدأ تفاح الأرز",
      "score 250 EC",
      "يجب إزالة الأغصان المصابة واستخدام مبيدات الفطريات.",
    ),
    "Apple___healthy": DiseaseData(
      "صحي",
      "لا تحتاج الى مبيدات",
      "لا يحتاج إلى علاج.",
    ),
    "Bean___angular_leaf_spot": DiseaseData(
      "بقعة الورقة الزاوية",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة والحفاظ على نظافة المزرعة.",
    ),
    "Bean___healthy": DiseaseData(
      "صحي",
      "",
      "لا يحتاج إلى علاج.",
    ),
    "Bean___rust": DiseaseData(
      "صدأ الفول",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة.",
    ),
    "Corn___Cercospora_leaf_spot Gray_leaf_spot": DiseaseData(
      "بقعة ورقة سيركوسبورا",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة والحد من الرطوبة.",
    ),
    "Corn___Common_rust": DiseaseData(
      "صدأ الذرة الشائع",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة.",
    ),
    "Corn___Northern_Leaf_Blight": DiseaseData(
      "اللفحة الشمالية للورقة",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة.",
    ),
    "Corn___healthy": DiseaseData(
      "صحي",
      "",
      "لا يحتاج إلى علاج.",
    ),
    "Cucumber___Anthracnose": DiseaseData(
      "أنثراكنوز",
      "score 250 EC",
      "إزالة الأجزاء المصابة واستخدام مبيدات الفطريات المناسبة.",
    ),
    "Cucumber___Gummy Stem Blight": DiseaseData(
      "اللفحة الجذعية اللزجة",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة وتجنب الرطوبة الزائدة.",
    ),
    "Cucumber___healthy": DiseaseData(
      "صحي",
      "",
      "لا يحتاج إلى علاج.",
    ),
    "Grape___Black_rot": DiseaseData(
      "تعفن أسود العنب",
      "switch",
      "إزالة الأوراق والفواكه المصابة واستخدام مبيدات الفطريات المناسبة.",
    ),
    "Grape___Esca_(Black_Measles)": DiseaseData(
      "إيسكا (حصبة سوداء)",
      "score 250 EC",
      "إزالة الأجزاء المصابة من النبات.",
    ),
    "Grape___Leaf_blight_(Isariopsis_Leaf_Spot)": DiseaseData(
      "لفحة الورقة (بقعة ورقة إيساريوبيس)",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة.",
    ),
    "Grape___healthy": DiseaseData(
      "صحي",
      "",
      "لا يحتاج إلى علاج.",
    ),
    "Pepper_bell___Bacterial_spot": DiseaseData(
      "بقعة بكتيرية",
      "score 250 EC",
      "استخدام المبيدات البكتيرية المناسبة.",
    ),
    "Pepper_bell___healthy": DiseaseData(
      "صحي",
      "",
      "لا يحتاج إلى علاج.",
    ),
    "Potato___Early_blight": DiseaseData(
      "اللفحة المبكرة",
      "score 250 EC",
      "إزالة الأجزاء المصابة واستخدام مبيدات الفطريات المناسبة.",
    ),
    "Potato___Late_blight": DiseaseData(
      "اللفحة المتأخرة",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة.",
    ),
    "Potato___healthy": DiseaseData(
      "صحي",
      "",
      "لا يحتاج إلى علاج.",
    ),
    "Strawberry___Leaf_scorch": DiseaseData(
      "حرق الورقة",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة.",
    ),
    "Strawberry___healthy": DiseaseData(
      "صحي",
      "",
      "لا يحتاج إلى علاج.",
    ),
    "Tomato___Bacterial_spot": DiseaseData(
      "بقعة بكتيرية",
      "score 250 EC",
      "استخدام المبيدات البكتيرية المناسبة.",
    ),
    "Tomato___Early_blight": DiseaseData(
      "اللفحة المبكرة",
      "score 250 EC",
      "إزالة الأوراق المصابة واستخدام مبيدات الفطريات المناسبة.",
    ),
    "Tomato___Late_blight": DiseaseData(
      "اللفحة المتأخرة",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة.",
    ),
    "Tomato___Leaf_Mold": DiseaseData(
      "عفن الأوراق",
      "score 250 EC",
      "إزالة الأوراق المصابة واستخدام مبيدات الفطريات.",
    ),
    "Tomato___Septoria_leaf_spot": DiseaseData(
      "بقعة أوراق سيبتوريا",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة.",
    ),
    "Tomato___Spider_mites Two-spotted_spider_mite": DiseaseData(
      "سوس العنكبوت ذو البقعتين",
      "score 250 EC",
      "استخدام المبيدات الحشرية المناسبة.",
    ),
    "Tomato___Target_Spot": DiseaseData(
      "بقعة الهدف",
      "score 250 EC",
      "استخدام مبيدات الفطريات المناسبة.",
    ),
    "Tomato___Tomato_mosaic_virus": DiseaseData(
      "فيروس موزاييك الطماطم",
      "score 250 EC",
      "إزالة النباتات المصابة.",
    ),
    "Tomato___healthy": DiseaseData(
      "صحي",
      "",
      "لا يحتاج إلى علاج.",
    ),
    "olive_aculus_olearius": DiseaseData(
      "أكلوس أوليريوس الزيتون",
      "score 250 EC",
      "استخدام المبيدات الحشرية المناسبة.",
    ),
    "olive_healthy": DiseaseData(
      "صحي",
      "",
      "لا يحتاج إلى علاج.",
    ),
    "olive_peacock_spot": DiseaseData(
      "بقعة الطاووس الزيتون",
      "funguran",
      "استخدام مبيدات الفطريات المناسبة.",
    ),
  };
}

