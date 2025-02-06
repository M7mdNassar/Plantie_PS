import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/components/components.dart';
import '../cubit/cubit.dart';
import 'model_handler.dart';

class ImagePickerHandler {


  static Future<void> processImage(BuildContext context) async {
    try {
      final cubit = DetectionCubit.get(context);

      final imageSource = await _showImageSourceSelector(context);
      if (imageSource == null) return;

      final imageFile = await _pickImage(context, imageSource);
      if (imageFile == null) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const _LoadingOverlay(),
      );

      final result = await ModelHandler.classifyImage(imageFile);
      Navigator.pop(context);

      if (result != null) {
        // Add to both database and local list
        await cubit.addDetectionToHistory(imageFile, result);
        cubit.setDetectionResult(imageFile, result);
      }
    } catch (e) {
      Navigator.pop(context); // Ensure loading dialog is dismissed
      showToast(
        text: 'Error: ${e.toString()}',
        state: ToastStates.error,
      );
    }
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
          leading: const Icon(Icons.camera_alt),
          title: const Text('Take Photo'),
          onTap: () => Navigator.pop(context, ImageSource.camera),
        ),
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text('Choose from Gallery'),
          onTap: () => Navigator.pop(context, ImageSource.gallery),
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
