import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:plantie/models/user/user_model.dart';
import 'package:plantie/shared/components/components.dart';
import 'package:plantie/shared/styles/app_colors.dart';
import 'package:plantie/shared/utils/animations.dart';
import '../../generated/l10n.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components/constants.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileStates>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccessState) {
          setState(() {});
        }
      },
      child: BlocBuilder<AppCubit, AppStates>(
        builder: (context, appState) {
          final appCubit = AppCubit.get(context);
          final isDark = appCubit.isDark;
          final user = CurrentUser.user;

          return Scaffold(
            backgroundColor: isDark ? AppColors.darkBackground : HexColor("F8F9FA"),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: FadeInAnimation(
                  duration: AnimationConstants.normalDuration,
                  slideBegin: const Offset(0, 0.06),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row with AR/EN Switch
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.of(context).profile,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                fontSize: 26,
                              ),
                            ),
                            ScaleInAnimation(
                              child: GestureDetector(
                                onTap: () {
                                  appCubit.changeLanguage(appCubit.currentLanguage == 'ar' ? 'en' : 'ar');
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkSurface : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: (isDark ? Colors.white : Colors.black).withOpacity(0.06),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(isDark ? 0.15 : 0.03),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        S.of(context).arShort,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: appCubit.currentLanguage == 'ar' ? FontWeight.bold : FontWeight.w600,
                                          color: appCubit.currentLanguage == 'ar'
                                              ? (isDark ? AppColors.primaryLight : AppColors.primary)
                                              : Colors.grey[500],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                          width: 1.5,
                                          height: 12,
                                          color: (isDark ? Colors.white : Colors.black).withOpacity(0.1)),
                                      const SizedBox(width: 8),
                                      Text(
                                        S.of(context).enShort,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: appCubit.currentLanguage == 'en' ? FontWeight.bold : FontWeight.w600,
                                          color: appCubit.currentLanguage == 'en'
                                              ? (isDark ? AppColors.primaryLight : AppColors.primary)
                                              : Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Profile Card
                        ScaleInAnimation(
                          duration: AnimationConstants.normalDuration,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurface : Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                )
                              ],
                            ),
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: (isDark ? AppColors.primaryLight : AppColors.primary).withOpacity(0.25),
                                      width: 2,
                                    ),
                                  ),
                                  child: buildAvatar(
                                    radius: 52,
                                    localImage: null,
                                    networkImage: user.image,
                                    placeholderAsset: 'assets/images/default_avatar.png',
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  user.name,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                    fontSize: 20,
                                  ),
                                ),
                                if (user.bio != null && user.bio!.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      user.bio!,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                        height: 1.4,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 16),
                                InkWell(
                                  onTap: () => navigateTo(context, const EditProfileScreen()),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: (isDark ? AppColors.primaryLight : AppColors.primary).withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: (isDark ? AppColors.primaryLight : AppColors.primary).withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.edit_rounded,
                                          size: 16,
                                          color: isDark ? AppColors.primaryLight : AppColors.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          S.of(context).editProfile,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: isDark ? AppColors.primaryLight : AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if ((user.phone != null && user.phone!.isNotEmpty) ||
                                    (user.country != null && user.country!.isNotEmpty)) ...[
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Divider(height: 1),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (user.phone != null && user.phone!.isNotEmpty)
                                        _buildMetaChip(context,
                                            icon: Icons.phone_android_rounded,
                                            label: user.phone!,
                                            isDark: isDark),
                                      if ((user.phone != null && user.phone!.isNotEmpty) &&
                                          (user.country != null && user.country!.isNotEmpty))
                                        Container(
                                          height: 12,
                                          width: 1,
                                          color: isDark ? Colors.grey[700] : Colors.grey[300],
                                          margin: const EdgeInsets.symmetric(horizontal: 12),
                                        ),
                                      if (user.country != null && user.country!.isNotEmpty)
                                        _buildMetaChip(context,
                                            icon: Icons.public_rounded,
                                            label: user.country!,
                                            isDark: isDark),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Preferences Header
                        Padding(
                          padding: const EdgeInsets.only(left: 6, right: 6, bottom: 12),
                          child: Text(
                            S.of(context).preferencesAndOptions,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: isDark ? Colors.grey[500] : Colors.grey[600],
                            ),
                          ),
                        ),

                        // Settings Cards
                        StaggerAnimation(
                          delayBetween: const Duration(milliseconds: 80),
                          duration: AnimationConstants.normalDuration,
                          children: [
                            _buildSettingCard(
                              context,
                              icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                              title: S.of(context).darkMode,
                              trailing: Switch.adaptive(
                                value: appCubit.isDark,
                                onChanged: (value) => appCubit.changeAppMode(),
                                activeColor: isDark ? AppColors.primaryLight : AppColors.primary,
                              ),
                              isDark: isDark,
                            ),
                            const SizedBox(height: 12),
                            _buildSettingCard(
                              context,
                              icon: Icons.logout_rounded,
                              title: S.of(context).logout,
                              iconColor: AppColors.error,
                              onTap: () => _showLogoutDialog(context),
                              isDark: isDark,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetaChip(BuildContext context,
      {required IconData icon, required String label, required bool isDark}) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isDark ? Colors.grey[400] : Colors.grey[500]),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard(BuildContext context,
      {required IconData icon,
        required String title,
        Widget? trailing,
        Color? iconColor,
        VoidCallback? onTap,
        required bool isDark}) {
    return ScaleInAnimation(
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.12 : 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: (iconColor ?? (isDark ? AppColors.primaryLight : AppColors.primary)).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      icon,
                      color: iconColor ?? (isDark ? AppColors.primaryLight : AppColors.primary),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 12),
                    trailing,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final outerContext = context;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          S.of(dialogContext).confirmLogout,
          style: Theme.of(dialogContext).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Text(S.of(dialogContext).logoutMessage),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              S.of(dialogContext).cancel,
              style: TextStyle(
                color: isDark ? AppColors.primaryLight : AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              Future.delayed(const Duration(milliseconds: 200), () {
                signOut(outerContext);
              });
            },
            child: Text(S.of(dialogContext).logout, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}