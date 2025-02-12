import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantie/shared/components/constants.dart';
import '../../../generated/l10n.dart';
import '../../../layout/cubit/cubit.dart';
import '../../../models/disease_info.dart';
import '../../../shared/components/components.dart';
import '../../../shared/network/local/image_storage_helper.dart';
import '../../../shared/styles/colors.dart';
import '../cubit/cubit.dart';
import 'model_handler.dart';

class ImagePickerHandler {
  static Future<void> processImage(BuildContext context) async {
    try {
      final cubit = DetectionCubit.get(context);

      // 1. First select image source
      final imageSource = await _showImageSourceSelector(context);
      if (imageSource == null) return;

      // 2. Show instructions BEFORE capturing image
      final confirmed = await _showImageGuidance(context);
      if (!confirmed) return;

      // 3. Now capture/select image
      final originalImage = await _pickImage(context, imageSource);
      if (originalImage == null) return;

      // Rest of processing remains same...
      final permanentImage =
          await ImageStorageHelper.saveImagePermanently(originalImage);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const _LoadingOverlay(),
      );

      final result = await ModelHandler.classifyImage(permanentImage);
      Navigator.pop(context);

      if (result != null) {
        final diseaseInfo = DiseaseInfo.data[result] ??
            DiseaseData(S.of(context).unknownDisease, S.of(context).noDetails,
                S.of(context).diseaseNotDetected);
        await cubit.addDetectionToHistory(permanentImage, result);
        cubit.setDetectionResult(permanentImage, diseaseInfo.name);
      }
    } catch (e) {
      Navigator.pop(context);
      showToast(
          text: S.of(context).errorOccurred(e.toString()),
          state: ToastStates.error);
    }
  }

  static Future<bool> _showImageGuidance(BuildContext context) async {
    return await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => const _PreCaptureGuidanceScreen(),
          ),
        ) ??
        false;
  }

  static Future<ImageSource?> _showImageSourceSelector(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => const _ImageSourceSelector(),
    );
  }

  static Future<File?> _pickImage(BuildContext context, ImageSource source) {
    return source == ImageSource.camera
        ? ImagePickerHandler.pickImageFromCamera(context)
        : ImagePickerHandler.pickImageFromGallery(context);
  }

  static Future<File?> pickImageFromGallery(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  static Future<File?> pickImageFromCamera(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}

class _ImageSourceSelector extends StatelessWidget {
  const _ImageSourceSelector();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(
            Icons.camera_alt,
            color: plantieColor,
          ),
          title: Text(
            S.of(context).takePhoto,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          onTap: () => Navigator.pop(context, ImageSource.camera),
        ),
        SizedBox(
          height: 8,
        ),
        ListTile(
          leading: Icon(
            Icons.photo_library,
            color: plantieColor,
          ),
          title: Text(
            S.of(context).chooseFromGallery,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          onTap: () => Navigator.pop(context, ImageSource.gallery),
        ),
        SizedBox(
          height: 35,
        ),
      ],
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _PreCaptureGuidanceScreen extends StatelessWidget {
  const _PreCaptureGuidanceScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).captureGuidelines)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInstructionList(context),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: Text(
                S.of(context).iUnderstand,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: plantieColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              onPressed: () => Navigator.pop(context, true),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionList(context) {
    final localizations = S.of(context);

    return Column(
      children: [
        _buildInstructionItem(
          icon: Icons.photo_camera,
          title: localizations.positioningTips,
          points: [
            localizations.positioningTip1,
            localizations.positioningTip2,
            localizations.positioningTip3,
          ],
          context: context,
        ),
        _buildInstructionItem(
          icon: Icons.zoom_in,
          title: localizations.focusRequirements,
          points: [
            localizations.focusTip1,
            localizations.focusTip2,
            localizations.focusTip3,
          ],
          context: context,
        ),
        _buildInstructionItem(
          icon: Icons.palette,
          title: localizations.backgroundTips,
          points: [
            localizations.backgroundTip1,
            localizations.backgroundTip2,
            localizations.backgroundTip3,
          ],
          context: context,
        ),
        const SizedBox(height: 20),
        _buildExampleComparison(context),
      ],
    );
  }

  Widget _buildInstructionItem(
      {required IconData icon,
      required String title,
      required List<String> points,
      context}) {
    return Card(
      color: AppCubit.get(context).isDark
          ? HexColor("1C1C1E")
          : HexColor("FFFFFF"),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: plantieColor, size: 40),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...points.map((point) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.fiber_manual_record, size: 8),
                            const SizedBox(width: 8),
                            Expanded(child: Text(point)),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleComparison(context) {
    return Column(
      children: [
        Text(
          isArabic() ? "الصح | الخطآ" : 'Good vs Bad Examples:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            _buildExampleImage(
                'assets/images/good_leaf.heic', S.of(context).good),
            _buildExampleImage(
                'assets/images/bad_leaf.heic', S.of(context).avoid),
          ],
        ),
      ],
    );
  }

  Widget _buildExampleImage(String asset, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: plantieColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  asset,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: plantieColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
