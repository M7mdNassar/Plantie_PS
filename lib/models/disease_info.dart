
class DiseaseData {
  final String nameEn;
  final String nameAr;
  final String treatment;
  final String tipsAr;
  final String tipsEn;

  const DiseaseData({
    required this.nameEn,
    required this.nameAr,
    required this.treatment,
    required this.tipsAr,
    required this.tipsEn,
  });
}

class DiseaseInfo {
  static const Map<String, DiseaseData> data = {
    // ============ APPLE ============
    "Apple___Apple_scab": DiseaseData(
      nameEn: "Apple scab",
      nameAr: "جرب التفاح",
      treatment: "🌟 Fungicide (score 250 EC) + Preventive measures",
      tipsAr: "⬇️ إزالة الأوراق والفروع المصابة فوراً وحرقها خارج الحديقة.\n"
          "💧 تجنب الري العلوي، ويفضل الري بالتنقيط.\n"
          "🧪 رش مبيد فطري وقائي في بداية الموسم.\n"
          "🌿 زراعة أصناف مقاومة للجرب.\n"
          "🔍 مراقبة مستمرة لتحديد الإصابة مبكراً.",
      tipsEn: "⬇️ Remove infected leaves and branches immediately and burn them away from the garden.\n"
          "💧 Avoid overhead watering; drip irrigation is preferred.\n"
          "🧪 Apply preventive fungicide at the start of the season.\n"
          "🌿 Plant scab-resistant varieties.\n"
          "🔍 Monitor regularly for early detection.",
    ),
    "Apple___Black_rot": DiseaseData(
      nameEn: "Apple black rot",
      nameAr: "تعفن أسود",
      treatment: "🌟 Fungicide (score 250 EC) + Cultural control",
      tipsAr: "🍎 إزالة الفواكه والأوراق المصابة فوراً.\n"
          "✂️ تقليم الأغصان الميتة والمصابة.\n"
          "💨 تحسين التهوية بين الأشجار.\n"
          "🌧️ تجنب الإفراط في الري والرطوبة العالية.\n"
          "🧪 الرش الوقائي بالمبيدات الفطرية في الربيع.",
      tipsEn: "🍎 Remove infected fruits and leaves immediately.\n"
          "✂️ Prune dead and infected branches.\n"
          "💨 Improve air circulation between trees.\n"
          "🌧️ Avoid overwatering and high humidity.\n"
          "🧪 Apply preventive fungicide sprays in spring.",
    ),
    "Apple___Cedar_apple_rust": DiseaseData(
      nameEn: "Cedar apple rust",
      nameAr: "صدأ تفاح الأرز",
      treatment: "🌟 Fungicide (score 250 EC)",
      tipsAr: "🌲 إزالة أشجار العرعر القريبة إن أمكن.\n"
          "🧪 رش مبيد فطري متخصص عند ظهور الأعراض.\n"
          "✂️ تقليم الأغصان المصابة.\n"
          "🍃 جمع الأوراق المتساقطة وحرقها.\n"
          "📋 زراعة أنواع مقاومة للصدأ.",
      tipsEn: "🌲 Remove nearby cedar trees if possible.\n"
          "🧪 Apply specialized fungicide when symptoms appear.\n"
          "✂️ Prune infected branches.\n"
          "🍃 Collect and burn fallen leaves.\n"
          "📋 Plant rust-resistant varieties.",
    ),
    "Apple___healthy": DiseaseData(
      nameEn: "Healthy Apple",
      nameAr: "تفاح صحي",
      treatment: "✅ No treatment needed – keep up the good care!",
      tipsAr: "🌱 استمر في العناية المنتظمة.\n"
          "💧 ري منتظم دون إفراط.\n"
          "🌿 تسميد عضوي متوازن.\n"
          "🔍 فحص دوري للكشف المبكر عن أي أمراض.\n"
          "✂️ تقليم سنوي لتحسين التهوية والإنتاج.",
      tipsEn: "🌱 Continue regular care.\n"
          "💧 Regular watering without overdoing it.\n"
          "🌿 Balanced organic fertilization.\n"
          "🔍 Regular inspection for early disease detection.\n"
          "✂️ Annual pruning to improve air circulation and yield.",
    ),

    // ============ BEAN ============
    "Bean___angular_leaf_spot": DiseaseData(
      nameEn: "Bean angular leaf spot",
      nameAr: "بقعة الورقة الزاوية",
      treatment: "🌟 Fungicide (score 250 EC)",
      tipsAr: "🌱 زراعة بذور معتمدة خالية من الأمراض.\n"
          "💧 تجنب الري العلوي، ويفضل الري بالتنقيط.\n"
          "🧪 الرش الوقائي بالمبيدات الفطرية.\n"
          "🌿 إزالة النباتات المصابة وتدميرها.\n"
          "🔄 دورة زراعية لمدة 2-3 سنوات.",
      tipsEn: "🌱 Plant certified disease-free seeds.\n"
          "💧 Avoid overhead watering; use drip irrigation.\n"
          "🧪 Apply preventive fungicide sprays.\n"
          "🌿 Remove and destroy infected plants.\n"
          "🔄 Rotate crops for 2-3 years.",
    ),
    "Bean___healthy": DiseaseData(
      nameEn: "Healthy Bean",
      nameAr: "فول صحي",
      treatment: "✅ No treatment needed – keep up the good care!",
      tipsAr: "🌱 استمر في العناية المنتظمة.\n"
          "💧 ري مناسب دون إغراق.\n"
          "🌿 تسميد متوازن.\n"
          "🔍 مراقبة دورية للأمراض والآفات.\n"
          "🌞 ضمان تعرض كافٍ لأشعة الشمس.",
      tipsEn: "🌱 Continue regular care.\n"
          "💧 Water appropriately without waterlogging.\n"
          "🌿 Balanced fertilization.\n"
          "🔍 Regular pest and disease monitoring.\n"
          "🌞 Ensure adequate sunlight exposure.",
    ),
    "Bean___rust": DiseaseData(
      nameEn: "Bean rust",
      nameAr: "صدأ الفول",
      treatment: "🌟 Fungicide (score 250 EC)",
      tipsAr: "🌿 إزالة الأوراق المصابة.\n"
          "💧 الري في الصباح الباكر لتجفيف الأوراق.\n"
          "🧪 رش مبيد فطري متخصص.\n"
          "🌾 زراعة أصناف مقاومة للصدأ.\n"
          "📋 تجنب الزراعة الكثيفة.",
      tipsEn: "🌿 Remove infected leaves.\n"
          "💧 Water early in the morning so leaves dry out.\n"
          "🧪 Apply specialized fungicide.\n"
          "🌾 Plant rust-resistant varieties.\n"
          "📋 Avoid dense planting.",
    ),

    // ============ CORN ============
    "Corn___Cercospora_leaf_spot Gray_leaf_spot": DiseaseData(
      nameEn: "Gray leaf spot",
      nameAr: "بقعة ورقة سيركوسبورا",
      treatment: "🌟 Fungicide (score 250 EC)",
      tipsAr: "🌽 زراعة أصناف مقاومة.\n"
          "💧 تجنب الري العلوي.\n"
          "🧪 رش مبيد فطري عند ظهور الأعراض.\n"
          "🌿 إزالة بقايا المحاصيل بعد الحصاد.\n"
          "🔄 دورة زراعية لمنع تراكم المسببات.",
      tipsEn: "🌽 Plant resistant varieties.\n"
          "💧 Avoid overhead watering.\n"
          "🧪 Apply fungicide when symptoms appear.\n"
          "🌿 Remove crop residues after harvest.\n"
          "🔄 Crop rotation to prevent pathogen buildup.",
    ),
    "Corn___Common_rust": DiseaseData(
      nameEn: "Common corn rust",
      nameAr: "صدأ الذرة الشائع",
      treatment: "🌟 Fungicide (score 250 EC)",
      tipsAr: "🌽 زراعة أصناف مقاومة.\n"
          "🧪 رش مبيد فطري في بداية الإصابة.\n"
          "💧 تجنب الرطوبة العالية.\n"
          "🌿 إزالة الأوراق المصابة.\n"
          "📋 مراقبة الحقل بانتظام.",
      tipsEn: "🌽 Plant resistant varieties.\n"
          "🧪 Apply fungicide at the first sign of infection.\n"
          "💧 Avoid high humidity conditions.\n"
          "🌿 Remove infected leaves.\n"
          "📋 Monitor the field regularly.",
    ),
    "Corn___Northern_Leaf_Blight": DiseaseData(
      nameEn: "Northern leaf blight",
      nameAr: "اللفحة الشمالية للورقة",
      treatment: "🌟 Fungicide (score 250 EC)",
      tipsAr: "🌽 زراعة أصناف مقاومة.\n"
          "🧪 رش مبيد فطري وقائي.\n"
          "🌿 إزالة بقايا المحاصيل.\n"
          "💧 تجنب الري المفرط.\n"
          "🔄 دورة زراعية لمدة عامين.",
      tipsEn: "🌽 Plant resistant varieties.\n"
          "🧪 Apply preventive fungicide.\n"
          "🌿 Remove crop residues.\n"
          "💧 Avoid excessive watering.\n"
          "🔄 Two-year crop rotation.",
    ),
    "Corn___healthy": DiseaseData(
      nameEn: "Healthy Corn",
      nameAr: "ذرة صحية",
      treatment: "✅ No treatment needed – keep up the good care!",
      tipsAr: "🌽 استمر في العناية المنتظمة.\n"
          "💧 ري منتظم.\n"
          "🌿 تسميد متوازن.\n"
          "🔍 فحص دوري.\n"
          "🌞 ضمان تعرض كافٍ لأشعة الشمس.",
      tipsEn: "🌽 Continue regular care.\n"
          "💧 Regular watering.\n"
          "🌿 Balanced fertilization.\n"
          "🔍 Regular inspection.\n"
          "🌞 Ensure adequate sunlight.",
    ),

    // ============ CUCUMBER ============
    "Cucumber___Anthracnose": DiseaseData(
      nameEn: "Anthracnose",
      nameAr: "أنثراكنوز",
      treatment: "🌟 Fungicide (score 250 EC)",
      tipsAr: "🥒 إزالة الأجزاء المصابة فوراً.\n"
          "🧪 رش مبيد فطري متخصص.\n"
          "💧 تجنب الري العلوي.\n"
          "🌱 زراعة بذور معتمدة خالية من الأمراض.\n"
          "🔄 دورة زراعية لمدة 2-3 سنوات.",
      tipsEn: "🥒 Remove infected parts immediately.\n"
          "🧪 Apply specialized fungicide.\n"
          "💧 Avoid overhead watering.\n"
          "🌱 Plant certified disease-free seeds.\n"
          "🔄 Rotate crops for 2-3 years.",
    ),
    "Cucumber___Gummy Stem Blight": DiseaseData(
      nameEn: "Gummy stem blight",
      nameAr: "اللفحة الجذعية اللزجة",
      treatment: "🌟 Fungicide (score 250 EC)",
      tipsAr: "🥒 إزالة النباتات المصابة وتدميرها.\n"
          "🧪 رش مبيد فطري وقائي.\n"
          "💧 تجنب الرطوبة الزائدة.\n"
          "🌿 تحسين التهوية بين النباتات.\n"
          "🔄 دورة زراعية.",
      tipsEn: "🥒 Remove and destroy infected plants.\n"
          "🧪 Apply preventive fungicide.\n"
          "💧 Avoid excessive moisture.\n"
          "🌿 Improve air circulation between plants.\n"
          "🔄 Crop rotation.",
    ),
    "Cucumber___healthy": DiseaseData(
      nameEn: "Healthy Cucumber",
      nameAr: "خيار صحي",
      treatment: "✅ No treatment needed – keep up the good care!",
      tipsAr: "🥒 استمر في العناية المنتظمة.\n"
          "💧 ري مناسب.\n"
          "🌿 تسميد متوازن.\n"
          "🔍 فحص دوري.\n"
          "🌞 تعرض جيد لأشعة الشمس.",
      tipsEn: "🥒 Continue regular care.\n"
          "💧 Appropriate watering.\n"
          "🌿 Balanced fertilization.\n"
          "🔍 Regular inspection.\n"
          "🌞 Good sun exposure.",
    ),

    // ============ GRAPE ============
    "Grape___Black_rot": DiseaseData(
      nameEn: "Grape black rot",
      nameAr: "تعفن أسود العنب",
      treatment: "🌟 Fungicide (switch)",
      tipsAr: "🍇 إزالة العناقيد والأوراق المصابة.\n"
          "✂️ تقليم الأغصان المصابة.\n"
          "🧪 رش مبيد فطري مناسب.\n"
          "💧 تجنب الرطوبة الزائدة.\n"
          "🌿 تحسين التهوية بين الكروم.",
      tipsEn: "🍇 Remove infected clusters and leaves.\n"
          "✂️ Prune infected branches.\n"
          "🧪 Apply appropriate fungicide.\n"
          "💧 Avoid excessive moisture.\n"
          "🌿 Improve air circulation between vines.",
    ),
    "Grape___Esca_(Black_Measles)": DiseaseData(
      nameEn: "Esca (black measles)",
      nameAr: "إيسكا (حصبة سوداء)",
      treatment: "🌟 Fungicide (score 250 EC)",
      tipsAr: "🍇 إزالة الأجزاء المصابة من النبات.\n"
          "✂️ تقليم جيد لتحسين التهوية.\n"
          "🌿 تجنب الإجهاد المائي.\n"
          "🧪 رش وقائي بمبيدات فطرية.\n"
          "📋 زراعة أصناف مقاومة.",
      tipsEn: "🍇 Remove infected parts of the plant.\n"
          "✂️ Prune well to improve air circulation.\n"
          "🌿 Avoid water stress.\n"
          "🧪 Apply preventive fungicide sprays.\n"
          "📋 Plant resistant varieties.",
    ),
    "Grape___Leaf_blight_(Isariopsis_Leaf_Spot)": DiseaseData(
      nameEn: "Leaf blight",
      nameAr: "لفحة الورقة (بقعة ورقة إيساريوبيس)",
      treatment: "🌟 Fungicide (score 250 EC)",
      tipsAr: "🍇 جمع الأوراق المصابة وحرقها.\n"
          "🧪 رش مبيد فطري متخصص.\n"
          "💧 تجنب الري العلوي.\n"
          "🌿 تحسين التهوية.\n"
          "🔄 دورة زراعية إذا أمكن.",
      tipsEn: "🍇 Collect and burn infected leaves.\n"
          "🧪 Apply specialized fungicide.\n"
          "💧 Avoid overhead watering.\n"
          "🌿 Improve air circulation.\n"
          "🔄 Crop rotation if possible.",
    ),
    "Grape___healthy": DiseaseData(
      nameEn: "Healthy Grape",
      nameAr: "عنب صحي",
      treatment: "✅ No treatment needed – keep up the good care!",
      tipsAr: "🍇 استمر في العناية المنتظمة.\n"
          "💧 ري مناسب.\n"
          "🌿 تسميد متوازن.\n"
          "✂️ تقليم سنوي.\n"
          "🔍 مراقبة دورية.",
      tipsEn: "🍇 Continue regular care.\n"
          "💧 Appropriate watering.\n"
          "🌿 Balanced fertilization.\n"
          "✂️ Annual pruning.\n"
          "🔍 Regular monitoring.",
    ),

    // ============ PEPPER ============
    "Pepper_bell___Bacterial_spot": DiseaseData(
      nameEn: "Bacterial spot",
      nameAr: "بقعة بكتيرية",
      treatment: "🌟 Bactericide (score 250 EC)",
      tipsAr: "🌶️ إزالة الأوراق المصابة.\n"
          "🧪 رش مبيد بكتيري مناسب.\n"
          "💧 تجنب الري العلوي.\n"
          "🌱 استخدام بذور معتمدة خالية من الأمراض.\n"
          "🔄 دورة زراعية.",
      tipsEn: "🌶️ Remove infected leaves.\n"
          "🧪 Apply appropriate bactericide.\n"
          "💧 Avoid overhead watering.\n"
          "🌱 Use certified disease-free seeds.\n"
          "🔄 Crop rotation.",
    ),
    "Pepper_bell___healthy": DiseaseData(
      nameEn: "Healthy Bell Pepper",
      nameAr: "فلفل حلو صحي",
      treatment: "✅ No treatment needed – keep up the good care!",
      tipsAr: "🌶️ استمر في العناية المنتظمة.\n"
          "💧 ري مناسب.\n"
          "🌿 تسميد متوازن.\n"
          "🔍 فحص دوري.\n"
          "🌞 تعرض جيد لأشعة الشمس.",
      tipsEn: "🌶️ Continue regular care.\n"
          "💧 Appropriate watering.\n"
          "🌿 Balanced fertilization.\n"
          "🔍 Regular inspection.\n"
          "🌞 Good sun exposure.",
    ),

    // ============ POTATO ============
    "Potato___Early_blight": DiseaseData(
      nameEn: "Early blight",
      nameAr: "اللفحة المبكرة",
      treatment: "🌟 Fungicide (score 250 EC)",
      tipsAr: "🥔 إزالة الأوراق المصابة وتدميرها.\n"
          "🧪 رش مبيد فطري وقائي.\n"
          "💧 تجنب الرطوبة الزائدة.\n"
          "🌿 تحسين التهوية بين النباتات.\n"
          "🔄 دورة زراعية لمدة 3 سنوات.",
      tipsEn: "🥔 Remove and destroy infected leaves.\n"
          "🧪 Apply preventive fungicide.\n"
          "💧 Avoid excessive moisture.\n"
          "🌿 Improve air circulation between plants.\n"
          "🔄 3-year crop rotation.",
    ),
    "Potato___Late_blight": DiseaseData(
      nameEn: "Late blight",
      nameAr: "اللفحة المتأخرة",
      treatment: "🌟 Fungicide (score 250 EC)",
      tipsAr: "🥔 إزالة النباتات المصابة فوراً.\n"
          "🧪 رش مبيد فطري متخصص.\n"
          "💧 تجنب الري المفرط.\n"
          "🌿 استخدام درنات معتمدة خالية من الأمراض.\n"
          "📋 مراقبة الحقل يومياً.",
      tipsEn: "🥔 Remove infected plants immediately.\n"
          "🧪 Apply specialized fungicide.\n"
          "💧 Avoid overwatering.\n"
          "🌿 Use certified disease-free tubers.\n"
          "📋 Monitor the field daily.",
    ),
    "Potato___healthy": DiseaseData(
      nameEn: "Healthy Potato",
      nameAr: "بطاطس صحية",
      treatment: "✅ No treatment needed – keep up the good care!",
      tipsAr: "🥔 استمر في العناية المنتظمة.\n"
          "💧 ري مناسب.\n"
          "🌿 تسميد متوازن.\n"
          "🔍 فحص دوري.\n"
          "🌞 تعرض جيد لأشعة الشمس.",
      tipsEn: "🥔 Continue regular care.\n"
          "💧 Appropriate watering.\n"
          "🌿 Balanced fertilization.\n"
          "🔍 Regular inspection.\n"
          "🌞 Good sun exposure.",
    ),

    // ============ STRAWBERRY ============
    "Strawberry___Leaf_scorch": DiseaseData(
      nameEn: "Leaf scorch",
      nameAr: "حرق الورقة",
      treatment: "🌟 Fungicide (score 250 EC)",
      tipsAr: "🍓 إزالة الأوراق المصابة.\n"
          "🧪 رش مبيد فطري مناسب.\n"
          "💧 تجنب الري العلوي.\n"
          "🌿 تحسين التهوية.\n"
          "🔄 زراعة أصناف مقاومة.",
      tipsEn: "🍓 Remove infected leaves.\n"
          "🧪 Apply appropriate fungicide.\n"
          "💧 Avoid overhead watering.\n"
          "🌿 Improve air circulation.\n"
          "🔄 Plant resistant varieties.",
    ),
    "Strawberry___healthy": DiseaseData(
      nameEn: "Healthy Strawberry",
      nameAr: "فراولة صحية",
      treatment: "✅ No treatment needed – keep up the good care!",
      tipsAr: "🍓 استمر في العناية المنتظمة.\n"
          "💧 ري مناسب.\n"
          "🌿 تسميد متوازن.\n"
          "🔍 فحص دوري.\n"
          "🌞 تعرض جيد لأشعة الشمس.",
      tipsEn: "🍓 Continue regular care.\n"
          "💧 Appropriate watering.\n"
          "🌿 Balanced fertilization.\n"
          "🔍 Regular inspection.\n"
          "🌞 Good sun exposure.",
    ),

    // ============ TOMATO ============
    "Tomato___Bacterial_spot": DiseaseData(
      nameEn: "Bacterial spot",
      nameAr: "بقعة بكتيرية",
      treatment: "🌟 Bactericide (score 250 EC)",
      tipsAr: "🍅 إزالة الأوراق المصابة فوراً.\n"
          "🧪 رش مبيد بكتيري مناسب.\n"
          "💧 تجنب الري العلوي.\n"
          "🌱 استخدام بذور معتمدة خالية من الأمراض.\n"
          "🔄 دورة زراعية.",
      tipsEn: "🍅 Remove infected leaves immediately.\n"
          "🧪 Apply appropriate bactericide.\n"
          "💧 Avoid overhead watering.\n"
          "🌱 Use certified disease-free seeds.\n"
          "🔄 Crop rotation.",
    ),
    "Tomato___Early_blight": DiseaseData(
      nameEn: "Early blight",
      nameAr: "اللفحة المبكرة",
      treatment: "🌟 Fungicide (score 250 EC)",
      tipsAr: "🍅 إزالة الأوراق المصابة وتدميرها.\n"
          "🧪 رش مبيد فطري وقائي.\n"
          "💧 تجنب الري المفرط.\n"
          "🌿 تحسين التهوية.\n"
          "🔄 دورة زراعية لمدة 3 سنوات.",
      tipsEn: "🍅 Remove and destroy infected leaves.\n"
          "🧪 Apply preventive fungicide.\n"
          "💧 Avoid overwatering.\n"
          "🌿 Improve air circulation.\n"
          "🔄 3-year crop rotation.",
    ),
    "Tomato___Late_blight": DiseaseData(
      nameEn: "Late blight",
      nameAr: "اللفحة المتأخرة",
      treatment: "🌟 Fungicide (score 250 EC)",
      tipsAr: "🍅 إزالة النباتات المصابة فوراً.\n"
          "🧪 رش مبيد فطري متخصص.\n"
          "💧 تجنب الري العلوي.\n"
          "🌱 زراعة شتلات سليمة.\n"
          "📋 مراقبة يومية.",
      tipsEn: "🍅 Remove infected plants immediately.\n"
          "🧪 Apply specialized fungicide.\n"
          "💧 Avoid overhead watering.\n"
          "🌱 Plant healthy seedlings.\n"
          "📋 Daily monitoring.",
    ),
    "Tomato___Leaf_Mold": DiseaseData(
      nameEn: "Leaf mold",
      nameAr: "عفن الأوراق",
      treatment: "🌟 Fungicide (score 250 EC)",
      tipsAr: "🍅 إزالة الأوراق المصابة.\n"
          "🧪 رش مبيد فطري مناسب.\n"
          "💧 تجنب الرطوبة الزائدة.\n"
          "🌿 تحسين التهوية.\n"
          "📋 مراقبة النباتات بانتظام.",
      tipsEn: "🍅 Remove infected leaves.\n"
          "🧪 Apply appropriate fungicide.\n"
          "💧 Avoid excessive moisture.\n"
          "🌿 Improve air circulation.\n"
          "📋 Monitor plants regularly.",
    ),
    "Tomato___Septoria_leaf_spot": DiseaseData(
      nameEn: "Septoria leaf spot",
      nameAr: "بقعة أوراق سيبتوريا",
      treatment: "🌟 Fungicide (score 250 EC)",
      tipsAr: "🍅 إزالة الأوراق المصابة وتدميرها.\n"
          "🧪 رش مبيد فطري وقائي.\n"
          "💧 تجنب الري العلوي.\n"
          "🌿 تحسين التهوية.\n"
          "🔄 دورة زراعية.",
      tipsEn: "🍅 Remove and destroy infected leaves.\n"
          "🧪 Apply preventive fungicide.\n"
          "💧 Avoid overhead watering.\n"
          "🌿 Improve air circulation.\n"
          "🔄 Crop rotation.",
    ),
    "Tomato___Spider_mites Two-spotted_spider_mite": DiseaseData(
      nameEn: "Two-spotted spider mite",
      nameAr: "سوس العنكبوت ذو البقعتين",
      treatment: "🌟 Insecticide (score 250 EC)",
      tipsAr: "🍅 رش المبيد الحشري المناسب.\n"
          "💧 الحفاظ على رطوبة معتدلة.\n"
          "🌿 إزالة الأوراق المصابة بشدة.\n"
          "🔍 فحص النباتات بانتظام.\n"
          "🔄 استخدام مكافحة بيولوجية إن أمكن.",
      tipsEn: "🍅 Apply appropriate insecticide.\n"
          "💧 Maintain moderate humidity.\n"
          "🌿 Remove heavily infested leaves.\n"
          "🔍 Inspect plants regularly.\n"
          "🔄 Use biological control if possible.",
    ),
    "Tomato___Target_Spot": DiseaseData(
      nameEn: "Target spot",
      nameAr: "بقعة الهدف",
      treatment: "🌟 Fungicide (score 250 EC)",
      tipsAr: "🍅 إزالة الأوراق المصابة.\n"
          "🧪 رش مبيد فطري مناسب.\n"
          "💧 تجنب الرطوبة الزائدة.\n"
          "🌿 تحسين التهوية.\n"
          "📋 مراقبة النباتات بانتظام.",
      tipsEn: "🍅 Remove infected leaves.\n"
          "🧪 Apply appropriate fungicide.\n"
          "💧 Avoid excessive moisture.\n"
          "🌿 Improve air circulation.\n"
          "📋 Monitor plants regularly.",
    ),
    "Tomato___Tomato_mosaic_virus": DiseaseData(
      nameEn: "Tomato mosaic virus",
      nameAr: "فيروس موزاييك الطماطم",
      treatment: "🌟 No cure – prevention & removal",
      tipsAr: "🍅 إزالة النباتات المصابة وتدميرها.\n"
          "🧤 تعقيم الأدوات بين كل نبات وآخر.\n"
          "🌱 زراعة أصناف مقاومة.\n"
          "🚫 تجنب التدخين أو التعامل مع النباتات بأيدٍ ملوثة.\n"
          "🔄 دورة زراعية لمدة 3 سنوات.",
      tipsEn: "🍅 Remove and destroy infected plants.\n"
          "🧤 Sterilize tools between plants.\n"
          "🌱 Plant resistant varieties.\n"
          "🚫 Avoid smoking or handling plants with contaminated hands.\n"
          "🔄 3-year crop rotation.",
    ),
    "Tomato___healthy": DiseaseData(
      nameEn: "Healthy Tomato",
      nameAr: "طماطم صحية",
      treatment: "✅ No treatment needed – keep up the good care!",
      tipsAr: "🍅 استمر في العناية المنتظمة.\n"
          "💧 ري مناسب.\n"
          "🌿 تسميد متوازن.\n"
          "🔍 فحص دوري.\n"
          "🌞 تعرض جيد لأشعة الشمس.",
      tipsEn: "🍅 Continue regular care.\n"
          "💧 Appropriate watering.\n"
          "🌿 Balanced fertilization.\n"
          "🔍 Regular inspection.\n"
          "🌞 Good sun exposure.",
    ),

    // ============ OLIVE ============
    "olive_aculus_olearius": DiseaseData(
      nameEn: "Olive aculus olearius",
      nameAr: "أكلوس أوليريوس الزيتون",
      treatment: "🌟 Insecticide (score 250 EC)",
      tipsAr: "🌿 رش المبيد الحشري المناسب.\n"
          "✂️ تقليم الأغصان المصابة.\n"
          "💧 الحفاظ على صحة الشجرة.\n"
          "🔍 مراقبة مستمرة.\n"
          "🌱 زراعة أصناف مقاومة إن وجدت.",
      tipsEn: "🌿 Apply appropriate insecticide.\n"
          "✂️ Prune infected branches.\n"
          "💧 Maintain tree health.\n"
          "🔍 Continuous monitoring.\n"
          "🌱 Plant resistant varieties if available.",
    ),
    "olive_healthy": DiseaseData(
      nameEn: "Healthy Olive",
      nameAr: "زيتون صحي",
      treatment: "✅ No treatment needed – keep up the good care!",
      tipsAr: "🌿 استمر في العناية المنتظمة.\n"
          "💧 ري مناسب.\n"
          "🌿 تسميد متوازن.\n"
          "✂️ تقليم سنوي.\n"
          "🔍 مراقبة دورية.",
      tipsEn: "🌿 Continue regular care.\n"
          "💧 Appropriate watering.\n"
          "🌿 Balanced fertilization.\n"
          "✂️ Annual pruning.\n"
          "🔍 Regular monitoring.",
    ),
    "olive_peacock_spot": DiseaseData(
      nameEn: "Olive peacock spot",
      nameAr: "بقعة الطاووس الزيتون",
      treatment: "🌟 Fungicide (funguran)",
      tipsAr: "🌿 جمع الأوراق المتساقطة وحرقها.\n"
          "🧪 رش مبيد فطري مناسب.\n"
          "💧 تجنب الري العلوي.\n"
          "✂️ تقليم لتحسين التهوية.\n"
          "🌱 زراعة أصناف مقاومة.",
      tipsEn: "🌿 Collect and burn fallen leaves.\n"
          "🧪 Apply appropriate fungicide.\n"
          "💧 Avoid overhead watering.\n"
          "✂️ Prune to improve air circulation.\n"
          "🌱 Plant resistant varieties.",
    ),
  };

  // ─── Helper methods ──────────────────────────────────────────

  static DiseaseData? getData(String diseaseKey) => data[diseaseKey];

  static String getLocalizedName(String diseaseKey, String languageCode) {
    final entry = data[diseaseKey];
    if (entry == null) return diseaseKey;
    return languageCode == 'ar' ? entry.nameAr : entry.nameEn;
  }

  static String getTreatment(String diseaseKey) {
    return data[diseaseKey]?.treatment ?? '';
  }

  static String getTips(String diseaseKey, String languageCode) {
    final entry = data[diseaseKey];
    if (entry == null) return '';
    return languageCode == 'ar' ? entry.tipsAr : entry.tipsEn;
  }

  static bool isHealthy(String diseaseKey) {
    return diseaseKey.toLowerCase().contains('healthy');
  }
}

// ─── Plant Name Helper ──────────────────────────────────────────

class PlantNameHelper {
  static const Map<String, String> _en = {
    'Apple': 'Apple',
    'Bean': 'Bean',
    'Corn': 'Corn',
    'Cucumber': 'Cucumber',
    'Grape': 'Grape',
    'Pepper_bell': 'Bell Pepper',
    'Potato': 'Potato',
    'Strawberry': 'Strawberry',
    'Tomato': 'Tomato',
    'olive': 'Olive',
  };

  static const Map<String, String> _ar = {
    'Apple': 'تفاح',
    'Bean': 'فول',
    'Corn': 'ذرة',
    'Cucumber': 'خيار',
    'Grape': 'عنب',
    'Pepper_bell': 'فلفل حلو',
    'Potato': 'بطاطس',
    'Strawberry': 'فراولة',
    'Tomato': 'طماطم',
    'olive': 'زيتون',
  };

  static String getLocalizedName(String? plantKey, String languageCode) {
    if (plantKey == null || plantKey.isEmpty) return '';
    return languageCode == 'ar'
        ? _ar[plantKey] ?? plantKey
        : _en[plantKey] ?? plantKey;
  }
}