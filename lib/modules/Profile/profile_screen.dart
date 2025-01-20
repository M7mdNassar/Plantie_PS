import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/user/user_model.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = CurrentUser.getUser();

    final nameController = TextEditingController(text: currentUser?.name ?? "");
    final emailController = TextEditingController(text: currentUser?.email ?? "");
    final bioController = TextEditingController(text: currentUser?.bio ?? "");
    final countryController = TextEditingController(text: currentUser?.country ?? "");
    final phoneController = TextEditingController(text: currentUser?.phone ?? "");

    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: BlocConsumer<ProfileCubit, ProfileStates>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccessState) {
            nameController.text = state.user?.name ?? "";
            bioController.text = state.user?.bio ?? "";
            countryController.text = state.user?.country ?? "";
            phoneController.text = state.user?.phone ?? "";

            showToast(
              text: "Profile updated successfully",
              gravity: ToastGravity.TOP,
              state: ToastStates.SUCCESS,
            );
          }
          if (state is ProfileUpdateErrorState) {
            showToast(
              text: state.error.toString(),
              gravity: ToastGravity.TOP,
              state: ToastStates.ERROR,
            );
          }
        },
        builder: (context, state) {
          final cubit = ProfileCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              centerTitle: true,
              actions: [
                // Dark Mode Switch in AppBar
                Switch(
                  value: false,
                  // You can set the initial value here, ideally you'd handle it with a theme management state
                  onChanged: (value) {
                    // Handle dark mode change
                  },
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    // Profile Image with change button
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          // Adjust the size as needed
                          backgroundColor: Colors.grey[200],
                          // Optional background color
                          child: cubit.profileImage != null
                              ? Image.file(cubit.profileImage!)
                              : (currentUser?.image != null
                                  ? CachedNetworkImage(
                                      imageUrl: currentUser!.image!,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        radius: 60,
                                        backgroundImage: imageProvider,
                                      ),
                                    )
                                  : Image.asset('assets/images/user.png')),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 19.0,
                            backgroundColor: Colors.black38,
                            child: IconButton(
                              onPressed: () {
                                cubit.pickProfileImage();
                              },
                              icon: Icon(Icons.camera_alt_rounded),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // User Name
                    defaultFormField(
                      controller: nameController,
                      label: "Name",
                      type: TextInputType.text,
                      validate: (String? value) {
                        if (value != null && value.isEmpty) {
                          return 'User name must be not empty';
                        }
                      },
                    ),
                    const SizedBox(height: 15),

                    // bio
                    defaultFormField(
                      controller: bioController,
                      label: "Bio",
                      type: TextInputType.text,
                      validate: (String? value) {
                        return;
                      },
                    ),
                    const SizedBox(height: 15),

                    // country
                    defaultFormField(
                      controller: countryController,
                      label: "Country",
                      type: TextInputType.text,
                      validate: (String? value) {},
                    ),

                    const SizedBox(height: 15),

                    defaultFormField(
                      controller: phoneController,
                      label: "Phone",
                      type: TextInputType.phone,
                      validate: (String? value) {},
                    ),

                    const SizedBox(height: 15),
                    // Email
                    defaultFormField(
                      controller: emailController,
                      label: "Email",
                      type: TextInputType.emailAddress,
                      enabled: false,
                      validate: (String? value) {},
                    ),
                    const SizedBox(height: 20),

                    ConditionalBuilder(
                      condition: state is! ProfileUpdateLoadingState,
                      builder: (context) => defaultButton(
                        function: () {
                          cubit.updateUserProfile(
                            name: nameController.text,
                            bio: bioController.text,
                            country: countryController.text,
                            phone: phoneController.text,
                          );
                        },
                        text: "Save Changes",
                      ),
                      fallback: (context) =>
                          Center(child: CircularProgressIndicator()),
                    ),

                    const SizedBox(height: 20),

                    // Logout Button
                    defaultButton(
                      function: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirm Logout"),
                              content:
                                  Text("Are you sure you want to log out?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                    signOut(context); // Perform logout
                                  },
                                  child: Text("Logout"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      text: "Logout",
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
