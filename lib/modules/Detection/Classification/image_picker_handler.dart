import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import '../../../generated/l10n.dart';
import '../../../layout/cubit/cubit.dart';
import '../../../shared/components/components.dart';
import '../../../shared/network/local/image_storage_helper.dart';
import '../../../shared/styles/app_colors.dart';
import '../cubit/cubit.dart';
import 'plant_disease_pipeline.dart';

class ImagePickerHandler {

  static Future<void> processImage(BuildContext context) async {
    print('🎯 [Handler] processImage started');
    final cubit = DetectionCubit.get(context);

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final notAPlantMessage = isArabic ? 'ليست نبتة' : 'Not a plant';

    try {
      // 1. Select image source
      print('📱 [Handler] Showing enhanced image source selector');
      final imageSource = await _showImageSourceSheet(context);
      if (imageSource == null) {
        print('⚠️ [Handler] Image source not selected');
        return;
      }
      print('📸 [Handler] Source selected: $imageSource');

      // 2. Show enhanced capture guidance with illustration
      print('📖 [Handler] Showing enhanced capture guidance');
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

      // 5. Analyze plant disease
      print('🔬 [Handler] Starting plant disease analysis...');
      final analysis = await PlantDiseasePipeline.analyzePlantDisease(originalImage);
      print('✅ [Handler] Analysis completed');
      print('   - isPlant: ${analysis.isPlant}');
      print('   - rejected: ${analysis.rejected}');
      print('   - diseaseLabel: ${analysis.diseaseLabel}');
      print('   - confidence: ${analysis.confidence}');
      print('   - isUncertain: ${analysis.isUncertain}');
      print('   - plantName: ${analysis.plantName}');

      cubit.detectionConfidence = analysis.confidence;
      cubit.detectionUncertain = analysis.isUncertain;
      print('📊 [Handler] Stored confidence: ${analysis.confidence}');

      if (analysis.rejected) {
        print('🚫 [Handler] Image rejected – not a plant');
        cubit.setNonPlantResult(originalImage, notAPlantMessage, analysis.confidence);
        print('✅ [Handler] setNonPlantResult called, exiting');
        return;
      }

      print('🌱 [Handler] Image is a plant – saving permanently');
      final permanentImage = await ImageStorageHelper.saveImagePermanently(originalImage);
      print('💾 [Handler] Permanent image saved at: ${permanentImage.path}');
      final diseaseKey = analysis.diseaseLabel!;
      cubit.currentPlantName = analysis.plantName;

      await cubit.addDetectionToHistory(permanentImage, diseaseKey);
      cubit.setDetectionResult(permanentImage, diseaseKey);

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

  // ─────────────────────────────────────────────────────────────
  //  ENHANCED IMAGE SOURCE SHEET (same as edit profile)
  // ─────────────────────────────────────────────────────────────
  static Future<ImageSource?> _showImageSourceSheet(BuildContext context) {
    final isDark = AppCubit.get(context).isDark;

    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.photo_library_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(
                    S.of(context).gallerySource,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_enhance_rounded,
                      color: AppColors.secondary,
                    ),
                  ),
                  title: Text(
                    S.of(context).cameraSource,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  ENHANCED CAPTURE GUIDANCE MODAL (with illustration)
  // ─────────────────────────────────────────────────────────────
  static Future<bool> _showImageGuidance(BuildContext context) async {
    return await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const _EnhancedCaptureGuideModal(),
    ) ?? false;
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

// ─────────────────────────────────────────────────────────────
//  ENHANCED CAPTURE GUIDE MODAL (with illustration)
// ─────────────────────────────────────────────────────────────
class _EnhancedCaptureGuideModal extends StatelessWidget {
  const _EnhancedCaptureGuideModal();

  @override
  Widget build(BuildContext context) {
    final isDark = AppCubit.get(context).isDark;
    final s = S.of(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? HexColor("1C1C1E") : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
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

              // ─── Header ───
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.captureGuidelines,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          s.quickTipsForBestResults,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ─── Illustration ───
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [HexColor("2A2A2E"), HexColor("1A1A1E")]
                        : [Colors.grey[50]!, Colors.white],
                  ),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.08) : Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // The illustration – you can replace with your asset
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/capture_guide.png', // ← Your asset image
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Container(
                          height: 180,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[800] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_camera_front,
                                size: 48,
                                color: isDark ? Colors.grey[600] : Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '📸 Position the leaf in the frame',
                                style: TextStyle(
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ─── Tip label below illustration (FIXED OVERFLOW) ───
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Will expand to content width
                        children: [
                          Icon(Icons.lightbulb, size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              s.positionTheLeaf,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                              softWrap: true, // allow wrapping
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ─── Tips list ───
              _buildTipItem(
                context,
                Icons.wb_sunny_outlined,
                s.goodLightingCapture,
                s.naturalLightWorks,
                AppColors.primary,
                isDark,
              ),
              const SizedBox(height: 12),
              _buildTipItem(
                context,
                Icons.zoom_in,
                s.closeAndClear,
                s.distanceAndFocus,
                HexColor("FF9500"),
                isDark,
              ),
              const SizedBox(height: 12),
              _buildTipItem(
                context,
                Icons.crop_square,
                s.singleLeafCapture,
                s.focusOnOneDiseased,
                Colors.red,
                isDark,
              ),
              const SizedBox(height: 12),
              _buildTipItem(
                context,
                Icons.high_quality,
                s.steadyShot,
                s.avoidBlur,
                Colors.purple,
                isDark,
              ),

              const SizedBox(height: 28),

              // ─── Buttons ───
              Row(
                children: [
                  Expanded(
                    child: Material(
                      child: InkWell(
                        onTap: () => Navigator.pop(context, false),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            s.cancel,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
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
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 12,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                s.continueButton,
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
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipItem(
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
        color: accentColor.withOpacity(isDark ? 0.08 : 0.04),
        border: Border.all(
          color: accentColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor.withOpacity(0.15),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 12,
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