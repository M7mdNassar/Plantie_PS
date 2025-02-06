import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/models/user/user_model.dart';
import 'package:plantie/shared/components/components.dart';
import 'package:plantie/shared/styles/colors.dart';
import 'package:plantie/shared/styles/icon_broken.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components/constants.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
      listener: (context, state) {
        // Handle state changes if needed
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Profile',
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildAvatar(
                    radius: 70,
                    localImage: null,
                    networkImage: CurrentUser.user?.image,
                    placeholderAsset: 'assets/images/user.png',
                  ),

                  const SizedBox(height: 15.0),
                  Text(
                    CurrentUser.user?.name ?? "",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 20.0),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 70,
                    ),
                    child: defaultButton(
                      function: () {
                        navigateTo(context, EditProfileScreen());
                      },
                      text: 'Edit Profile',
                      icon: IconBroken.Edit,
                    ),
                  ),

                  const SizedBox(height: 70.0),

                  // Dark Mode Card
                  SizedBox(
                    height: 75,
                    child: buildCard(
                      context: context,
                      icon: Icons.dark_mode_outlined,
                      title: "Dark Mode",
                      trailing: BlocBuilder<AppCubit, AppStates>(
                        builder: (context, state) {
                          return Switch.adaptive(
                            value: AppCubit.get(context).isDark,
                            onChanged: (value) {
                              AppCubit.get(context).changeAppMode();
                            },
                            activeColor: plantieColor,
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey[300],
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20.0),

                  // Language Card
                  SizedBox(
                    height: 75,
                    child: buildCard(
                      context: context,
                      icon: Icons.language,
                      title: "Language",
                      trailing: Row(
                        children: [
                          Text(
                            "English",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  SizedBox(
                    height: 75,
                    child: buildCard(
                      context: context,
                      icon: Icons.logout,
                      title: "Logout",
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 20.0,
                      ),
                      onTap: () {
                        showCustomDialog(
                          context: context,
                          backgroundColor: plantieColor,
                          title: "Confirm Logout",
                          content: "Are you sure you want to log out?",
                          cancelText: "Cancel",
                          onCancel: () => Navigator.pop(context),
                          confirmText: "Logout",
                          onConfirm: () {
                            signOut(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
