import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantie/modules/Profile/cubit/states.dart';
import 'package:plantie/shared/styles/app_colors.dart';
import 'package:plantie/shared/services/notification_service.dart';
import '../../generated/l10n.dart';
import '../../models/user/user_model.dart';
import 'cubit/cubit.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController bioController;
  late final TextEditingController countryController;
  late final TextEditingController phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final currentUser = CurrentUser.getUser();
    final cubit = ProfileCubit.get(context);

    if (currentUser != null) {
      cubit.initializeChangeTracking(currentUser);
      nameController = TextEditingController(text: currentUser.name);
      bioController = TextEditingController(text: currentUser.bio ?? "");
      countryController = TextEditingController(text: currentUser.country ?? "");
      phoneController = TextEditingController(text: currentUser.phone ?? "");
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    countryController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = ProfileCubit.get(context);

    return BlocConsumer<ProfileCubit, ProfileStates>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccessState) {
          NotificationService.success(
            title: S.of(context).successTitle,
            message: S.of(context).profileUpdatedSuccess,
          );
          final updatedUser = CurrentUser.getUser();
          if (updatedUser != null) {
            nameController.text = updatedUser.name;
            bioController.text = updatedUser.bio ?? '';
            countryController.text = updatedUser.country ?? '';
            phoneController.text = updatedUser.phone ?? '';
          }
        } else if (state is ProfileUpdateErrorState) {
          final message = state.error == 'offline_save_error'
              ? S.of(context).offlineSaveError
              : state.error;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: !cubit.hasUnsavedChanges && !cubit.isAnyLoading,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            if (cubit.isAnyLoading) return;
            final shouldLeave = await _showUnsavedChangesWarning();
            if (shouldLeave && context.mounted) {
              cubit.resetChanges();
              Navigator.pop(context);
            }
          },
          child: Scaffold(
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            appBar: _buildAppBar(context, cubit, isDark),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAvatarSection(context, cubit, isDark),
                            const SizedBox(height: 32),
                            
                            Text(
                              Localizations.localeOf(context).languageCode == 'ar' ? "المعلومات الشخصية" : "Personal Information",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            _buildModernTextField(
                              controller: nameController,
                              label: S.of(context).nameField,
                              icon: Icons.person_outline_rounded,
                              isDark: isDark,
                              enabled: !cubit.isSavingFields,
                              onChanged: (val) => cubit.trackFieldChange('name', val),
                              validator: (val) => (val == null || val.trim().isEmpty) ? S.of(context).nameRequired : null,
                            ),
                            const SizedBox(height: 16),
                            _buildModernTextField(
                              controller: bioController,
                              label: S.of(context).bioField,
                              icon: Icons.chat_bubble_outline_rounded,
                              isDark: isDark,
                              enabled: !cubit.isSavingFields,
                              maxLines: 3,
                              onChanged: (val) => cubit.trackFieldChange('bio', val),
                            ),
                            const SizedBox(height: 16),
                            _buildModernTextField(
                              controller: phoneController,
                              label: S.of(context).phoneField,
                              icon: Icons.phone_android_rounded,
                              isDark: isDark,
                              enabled: !cubit.isSavingFields,
                              keyboardType: TextInputType.phone,
                              onChanged: (val) => cubit.trackFieldChange('phone', val),
                            ),
                            const SizedBox(height: 16),
                            _buildModernTextField(
                              controller: countryController,
                              label: S.of(context).countryField,
                              icon: Icons.public_rounded,
                              isDark: isDark,
                              enabled: !cubit.isSavingFields,
                              onChanged: (val) => cubit.trackFieldChange('country', val),
                            ),
                            
                            // Extra padding at bottom for scrolling past keyboard
                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                _buildStickyBottomBar(context, cubit, isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ProfileCubit cubit, bool isDark) {
    return AppBar(
      title: Text(
        S.of(context).editProfile,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: isDark ? Colors.white : Colors.black87),
            onPressed: cubit.isAnyLoading
                ? null
                : () async {
                    if (cubit.hasUnsavedChanges) {
                      final leave = await _showUnsavedChangesWarning();
                      if (leave && context.mounted) {
                        cubit.resetChanges();
                        Navigator.pop(context);
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  },
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Avatar Section (Trendy & Safe)
  // ─────────────────────────────────────────────
  Widget _buildAvatarSection(BuildContext context, ProfileCubit cubit, bool isDark) {
    final currentUser = CurrentUser.getUser();
    final primaryColor = isDark ? AppColors.primaryLight : AppColors.primary;

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: cubit.isUploadingImage ? null : () => _showImageSourceSheet(context, cubit),
            child: SizedBox(
              width: 130,
              height: 130,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: FadeTransition(opacity: animation, child: child)),
                    child: cubit.isUploadingImage
                        ? Container(
                            key: const ValueKey('uploading'),
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? Colors.grey[800] : Colors.grey[200],
                              border: Border.all(color: primaryColor, width: 2),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: primaryColor,
                              ),
                            ),
                          )
                        : Container(
                            key: const ValueKey('idle'),
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: primaryColor.withValues(alpha: 0.5),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withValues(alpha: 0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: cubit.pickedImageFile != null
                                  ? Image.file(cubit.pickedImageFile!, fit: BoxFit.cover)
                                  : (currentUser?.image != null && currentUser!.image!.isNotEmpty)
                                      ? CachedNetworkImage(
                                          imageUrl: currentUser.image!,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(color: Colors.grey[300]),
                                          errorWidget: (context, url, error) => Image.asset('assets/images/default_avatar.png', fit: BoxFit.cover),
                                        )
                                      : Image.asset('assets/images/default_avatar.png', fit: BoxFit.cover),
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: IgnorePointer(
                      ignoring: cubit.isUploadingImage,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: cubit.isUploadingImage ? 0.0 : 1.0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: isDark ? AppColors.darkBackground : AppColors.lightBackground, width: 3),
                          ),
                          child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Image Save/Cancel Buttons
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => SizeTransition(sizeFactor: animation, axisAlignment: -1.0, child: child),
            child: cubit.hasImageChanges && !cubit.isUploadingImage
                ? Padding(
                    key: const ValueKey('buttons'),
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => cubit.cancelImageChange(),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: Text(S.of(context).cancel, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () => cubit.updateAvatar(),
                          icon: const Icon(Icons.cloud_upload_rounded, size: 18, color: Colors.white),
                          label: Text(S.of(context).saveAvatar, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: primaryColor.withValues(alpha: 0.5),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            minimumSize: const Size(0, 48),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('empty')),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Sticky Bottom Bar (Fields Save)
  // ─────────────────────────────────────────────
  Widget _buildStickyBottomBar(BuildContext context, ProfileCubit cubit, bool isDark) {
    final primaryColor = isDark ? AppColors.primaryLight : AppColors.primary;
    
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => SizeTransition(sizeFactor: animation, axisAlignment: 1.0, child: child),
      child: cubit.hasFieldChanges || cubit.isSavingFields
          ? Container(
              key: const ValueKey('bottomBar'),
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  )
                ],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    disabledBackgroundColor: primaryColor.withValues(alpha: 0.6),
                  ),
                  onPressed: cubit.isSavingFields
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            cubit.updateProfileFields();
                          }
                        },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: cubit.isSavingFields
                        ? const SizedBox(
                            key: ValueKey('loading'),
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            S.of(context).saveChanges,
                            key: const ValueKey('text'),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(key: ValueKey('emptyBar')),
    );
  }

  // ─────────────────────────────────────────────
  //  Modern Text Field
  // ─────────────────────────────────────────────
  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    bool enabled = true,
    int maxLines = 1,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    final primaryColor = isDark ? AppColors.primaryLight : AppColors.primary;
    final fillColor = isDark ? AppColors.darkSurfaceVariant : Colors.grey[100]!;
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: enabled
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
        enabled: enabled,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: enabled ? (isDark ? Colors.white : Colors.black87) : Colors.grey,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: enabled ? Colors.grey : Colors.grey.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, size: 22, color: enabled ? Colors.grey : Colors.grey.withValues(alpha: 0.5)),
          filled: true,
          fillColor: enabled ? fillColor : (isDark ? Colors.grey[900] : Colors.grey[200]),
          alignLabelWithHint: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: borderColor, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.redAccent.withValues(alpha: 0.5), width: 1.5),
          ),
        ),
      ),
    );
  }

  void _showImageSourceSheet(BuildContext context, ProfileCubit cubit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: Icon(Icons.photo_library_rounded, color: AppColors.primary),
                  ),
                  title: Text(S.of(context).gallerySource, style: const TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.pop(context);
                    cubit.pickProfileImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: Icon(Icons.camera_enhance_rounded, color: AppColors.secondary),
                  ),
                  title: Text(S.of(context).cameraSource, style: const TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.pop(context);
                    cubit.pickProfileImage(ImageSource.camera);
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showUnsavedChangesWarning() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(S.of(ctx).unsavedChangesTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
            content: Text(S.of(ctx).unsavedChangesMsg),
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(S.of(ctx).keepEditing, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(S.of(ctx).discard, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ) ??
        false;
  }
}
