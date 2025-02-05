import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:plantie/layout/cubit/cubit.dart';
import 'package:plantie/modules/Profile/cubit/states.dart';
import 'package:plantie/shared/styles/colors.dart';
import '../../models/user/user_model.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/icon_broken.dart';
import 'cubit/cubit.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = CurrentUser.getUser();
    final cubit = ProfileCubit.get(context);

    final nameController = TextEditingController(text: currentUser?.name ?? "");
    final emailController =
        TextEditingController(text: currentUser?.email ?? "");
    final bioController = TextEditingController(text: currentUser?.bio ?? "");
    final countryController =
        TextEditingController(text: currentUser?.country ?? "");
    final phoneController =
        TextEditingController(text: currentUser?.phone ?? "");

    return BlocConsumer<ProfileCubit, ProfileStates>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccessState) {
          showToast(
            text: "Profile updated successfully",
            gravity: ToastGravity.TOP,
            state: ToastStates.success,
          );
        }
        if (state is ProfileUpdateErrorState) {
          showToast(
            text: state.error.toString(),
            gravity: ToastGravity.TOP,
            state: ToastStates.error,
          );
        }
      },
      builder: (context, state) {
        // var profileImage = ProfileCubit.get(context).image;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Edit Profile',
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      CircleAvatar(
                        radius: 70.0,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 70.0,
                          backgroundImage: cubit.image == null
                              ? (currentUser!.image!.isNotEmpty)
                                  ? NetworkImage(currentUser.image!)
                                  : const AssetImage('assets/images/user.png')
                              : FileImage(cubit.image!),
                        ),
                      ),
                      IconButton(
                        icon: CircleAvatar(
                          backgroundColor: plantieColor,
                          radius: 19.0,
                          child: Icon(
                            IconBroken.Camera,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          cubit.pickProfileImage(context);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  if (cubit.flagButtons != false)
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: defaultTextButton(
                                function: () {
                                  cubit.uploadProfileImage();
                                },
                                text: 'Save',
                              ),
                            ),
                            Expanded(
                              child: defaultTextButton(
                                function: () {
                                  cubit.setImageToNull();
                                  cubit.updateUserImagePickidButtons();
                                },
                                text: 'Cancel',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  if (state is ProfileImageUpdateLoadingState)
                    const LinearProgressIndicator(),

                  const SizedBox(height: 20),
                  // Form Card
                  Card(
                    color: AppCubit.get(context).isDark
                        ? HexColor("1C1C1E")
                        : HexColor("FFFFFF"),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // Name Field
                          defaultFormField(
                            controller: nameController,
                            type: TextInputType.text,
                            label: 'Name',
                            prefixIcon: Icons.person,
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name must not be empty';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Bio Field
                          defaultFormField(
                            controller: bioController,
                            type: TextInputType.text,
                            label: 'Bio',
                            prefixIcon: Icons.info,
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Bio must not be empty';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Country Field
                          defaultFormField(
                            controller: countryController,
                            type: TextInputType.text,
                            label: 'Country',
                            prefixIcon: Icons.flag,
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Country must not be empty';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Phone Field
                          defaultFormField(
                            controller: phoneController,
                            type: TextInputType.phone,
                            label: 'Phone',
                            prefixIcon: Icons.phone,
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phone must not be empty';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Email Field (Read-Only)
                          defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            label: 'Email',
                            prefixIcon: Icons.email,
                            enabled: false,
                            validate: (value) {
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  ConditionalBuilder(
                    condition: state is! ProfileUpdateLoadingState,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 70,
                      ),
                      child: defaultButton(
                        function: () {
                          cubit.updateUserProfile(
                            name: nameController.text,
                            bio: bioController.text,
                            country: countryController.text,
                            phone: phoneController.text,
                          );
                        },
                        text: 'Save Changes',
                      ),
                    ),
                    fallback: (context) =>
                        Center(child: CircularProgressIndicator()),
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
