import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import '../../../generated/l10n.dart';
import '../../../layout/cubit/cubit.dart';
import '../../../models/disease_info.dart';
import '../../../shared/components/components.dart';
import '../../../shared/network/local/image_storage_helper.dart';
import '../../../shared/styles/app_colors.dart';
import '../cubit/cubit.dart';
import 'plant_disease_pipeline.dart';

class ImagePickerHandler {
  static String _text(BuildContext context, {required String en, required String ar}) {
    return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
  }

  static Future<void> processImage(BuildContext context) async {
    print('🎯 [Handler] processImage started');
    final cubit = DetectionCubit.get(context);

    // Pre‑fetch the language direction once before any modals close
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final notAPlantMessage = isArabic ? 'ليست نبتة' : 'Not a plant';

    try {
      // 1. Select image source
      print('📱 [Handler] Showing image source selector');
      final imageSource = await _showImageSourceSelector(context);
      if (imageSource == null) {
        print('⚠️ [Handler] Image source not selected');
        return;
      }
      print('📸 [Handler] Source selected: $imageSource');

      // 2. Show capture guidance
      print('📖 [Handler] Showing capture guidance');
      final confirmed = await _showImageGuidance(context);
      if (!confirmed) {
        print('⚠️ [Handler] User cancelled guidance');
        return;
      }
      print('✅ [Handler] User confirmed guidance');

      // 3. Pick image
      print('🖼️ [Handler] Picking image from $imageSource');
      final originalImage = await _pickImage(context, imageSource);
      if (originalImage == null) {
        print('⚠️ [Handler] No image picked');
        return;
      }
      print('📁 [Handler] Image picked: ${originalImage.path}');

      // 4. Start loading UI
      print('🔄 [Handler] Calling startDetectionLoading');
      cubit.startDetectionLoading(originalImage);
      print('✅ [Handler] startDetectionLoading completed');

      // 5. Analyze plant disease (with built-in timeout)
      print('🔬 [Handler] Starting plant disease analysis...');
      final analysis = await PlantDiseasePipeline.analyzePlantDisease(originalImage);
      print('✅ [Handler] Analysis completed');
      print('   - isPlant: ${analysis.isPlant}');
      print('   - rejected: ${analysis.rejected}');
      print('   - diseaseLabel: ${analysis.diseaseLabel}');
      print('   - confidence: ${analysis.confidence}');
      print('   - isUncertain: ${analysis.isUncertain}');
      print('   - plantName: ${analysis.plantName}');

      // 6. Store confidence & uncertainty
      cubit.detectionConfidence = analysis.confidence;
      cubit.detectionUncertain = analysis.isUncertain;
      print('📊 [Handler] Stored confidence: ${analysis.confidence}');

      // 7. Handle non‑plant case
      if (analysis.rejected) {
        print('🚫 [Handler] Image rejected – not a plant');
        cubit.setNonPlantResult(originalImage, notAPlantMessage, analysis.confidence);
        print('✅ [Handler] setNonPlantResult called, exiting');
        return;
      }

      // 8. It is a plant – save permanently and add to history
      print('🌱 [Handler] Image is a plant – saving permanently');
      final permanentImage = await ImageStorageHelper.saveImagePermanently(originalImage);
      print('💾 [Handler] Permanent image saved at: ${permanentImage.path}');
      final diseaseKey = analysis.diseaseLabel!;
      cubit.currentPlantName = analysis.plantName;
      final diseaseInfo = DiseaseInfo.data[diseaseKey] ??
          DiseaseData(
            isArabic ? "مرض غير معروف" : "Unknown Disease",
            isArabic ? "لا توجد تفاصيل" : "No details",
            isArabic ? "لم يتم اكتشاف المرض" : "Disease not detected",
          );

      await cubit.addDetectionToHistory(permanentImage, diseaseKey);
      cubit.setDetectionResult(permanentImage, diseaseInfo.name);
      print('✅ [Handler] Detection result set, process complete');
    } catch (e, stack) {
      print('❌ [Handler] Exception caught: $e');
      print('📚 Stack trace: $stack');
      final errorMsg = _getUserFriendlyErrorMessage(e, isArabic);
      print('💬 [Handler] User-friendly error: $errorMsg');
      cubit.emitErrorState(errorMsg);
      if (context.mounted) {
        showToast(text: errorMsg, state: ToastStates.error);
      }
      try { Navigator.pop(context); } catch (_) {}
      print('🏁 [Handler] Error handling complete');
    }
  }



  static String _getUserFriendlyErrorMessage(dynamic e, bool isArabic) {
    final errorStr = e.toString().toLowerCase();

    if (errorStr.contains('timeout')) {
      return isArabic
          ? "استغرق التحليل وقتًا طويلاً. يرجى المحاولة مرة أخرى بصورة أوضح."
          : "Analysis took too long. Please try again with a clearer image.";
    }
    if (errorStr.contains('decode') || errorStr.contains('image')) {
      return isArabic
          ? "لا يمكن قراءة الصورة. يرجى اختيار صورة صالحة."
          : "Could not read the image. Please select a valid photo.";
    }
    if (errorStr.contains('memory')) {
      return isArabic
          ? "الصورة كبيرة جدًا. يرجى استخدام صورة أصغر."
          : "Image is too large. Please use a smaller photo.";
    }
    if (errorStr.contains('plant') && errorStr.contains('not')) {
      return isArabic
          ? "لا يبدو أن الصورة تحتوي على ورقة نبات."
          : "The image does not appear to contain a plant leaf.";
    }
    return isArabic
        ? "حدث خطأ ما. يرجى المحاولة مرة أخرى."
        : "Something went wrong. Please try again.";
  }
  static Future<bool> _showImageGuidance(BuildContext context) async {
    return await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const _ConciseCaptureGuideModal(),
    ) ?? false;
  }

  static Future<ImageSource?> _showImageSourceSelector(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => const _ImageSourceSelector(),
    );
  }

  static Future<File?> _pickImage(BuildContext context, ImageSource source) {
    return source == ImageSource.camera
        ? pickImageFromCamera(context)
        : pickImageFromGallery(context);
  }

  static Future<File?> pickImageFromGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) return File(pickedFile.path);
    return null;
  }

  static Future<File?> pickImageFromCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) return File(pickedFile.path);
    return null;
  }
}

// ─────────────────────────────────────────────
//  Image source selector modal (unchanged)
// ─────────────────────────────────────────────
class _ImageSourceSelector extends StatelessWidget {
  const _ImageSourceSelector();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(Icons.camera_alt, color: AppColors.primary),
          title: Text(S.of(context).takePhoto, style: Theme.of(context).textTheme.labelLarge),
          onTap: () => Navigator.pop(context, ImageSource.camera),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: Icon(Icons.photo_library, color: AppColors.primary),
          title: Text(S.of(context).chooseFromGallery, style: Theme.of(context).textTheme.labelLarge),
          onTap: () => Navigator.pop(context, ImageSource.gallery),
        ),
        const SizedBox(height: 35),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Capture guidance modal (unchanged)
// ─────────────────────────────────────────────
class _ConciseCaptureGuideModal extends StatelessWidget {
  const _ConciseCaptureGuideModal();

  @override
  Widget build(BuildContext context) {
    final isDark = AppCubit.get(context).isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? HexColor("1C1C1E") : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).captureGuidelines,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          S.of(context).quickTipsForBestResults,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildCompactTip(
                context,
                Icons.wb_sunny_outlined,
                S.of(context).goodLightingCapture,
                S.of(context).naturalLightWorks,
                AppColors.primary,
                isDark,
              ),
              const SizedBox(height: 12),
              _buildCompactTip(
                context,
                Icons.zoom_in,
                S.of(context).closeAndClear,
                S.of(context).distanceAndFocus,
                HexColor("FF9500"),
                isDark,
              ),
              const SizedBox(height: 12),
              _buildCompactTip(
                context,
                Icons.crop_square,
                S.of(context).singleLeafCapture,
                S.of(context).focusOnOneDiseased,
                Colors.red,
                isDark,
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: Material(
                      child: InkWell(
                        onTap: () => Navigator.pop(context, false),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                            ),
                          ),
                          child: Text(
                            S.of(context).cancel,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Material(
                      child: InkWell(
                        onTap: () => Navigator.pop(context, true),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 1,
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check, color: Colors.white, size: 20),
                              const SizedBox(width: 6),
                              Text(
                                S.of(context).continueButton,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactTip(
      BuildContext context,
      IconData icon,
      String title,
      String description,
      Color accentColor,
      bool isDark,
      ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: accentColor.withOpacity(0.08),
        border: Border.all(color: accentColor.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor.withOpacity(0.25),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}