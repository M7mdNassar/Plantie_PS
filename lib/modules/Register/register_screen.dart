
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/styles/colors.dart';
import '../Login/login_screen.dart';
import '../SplashScreen/lottie_loading_Screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
          listener: (context, state) {

            if (state is CreateUserSuccessState) {
              CacheHelper.saveData(
                key: 'uId',
                value: state.uId,
              ).then((value) {
                navigateAndFinish(context, LottieLoadingScreen());
              });
            }

            if (state is RegisterCanceldState){
              showToast(text: state.msg.toString(), state: ToastStates.WARNING);
            }

            if (state is RegisterErrorState){
              showToast(
                text: state.error,
                state: ToastStates.ERROR,
              );
            }
          }, builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Complete your information to get started!",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 30),
                    defaultFormField(
                      controller: userNameController,
                      label: "Username",
                      prefixIcon: Icons.person_outlined,
                      type: TextInputType.text,
                      validate: (String? value) {
                        if (value != null && value.isEmpty) {
                          return 'please enter a user name';
                        }
                      },
                    ),
                    SizedBox(height: 25),
                    defaultFormField(
                      controller: emailController,
                      label: "Email",
                      prefixIcon: Icons.email_outlined,
                      type: TextInputType.emailAddress,
                      validate: (String? value) {
                        if (value != null && value.isEmpty) {
                          return 'please enter a valid email';
                        }
                      },
                    ),
                    SizedBox(height: 25),
                    defaultFormField(
                      controller: passwordController,
                      type: TextInputType.visiblePassword,
                      suffixIcon: RegisterCubit.get(context).suffix,
                      onSubmit: (value) {},
                      obscureText: RegisterCubit.get(context).isPassword,
                      onSuffexPressed: () {
                        RegisterCubit.get(context).changePasswordVisibility();
                      },
                      validate: (String? value) {
                        if (value != null && value.isEmpty) {
                          return 'please enter your password';
                        }
                      },
                      label: 'Password',
                      prefixIcon: Icons.lock_outline,
                    ),
                    SizedBox(height: 35),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: ConditionalBuilder(
                        condition: state is! RegisterLoadingState,
                        builder: (context) => defaultButton(
                          function: () {
                            if (formKey.currentState!.validate()) {
                              RegisterCubit.get(context).userRegister(
                                name: userNameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          text: 'Register',
                          backgroundColor: plantieColor,
                        ),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            navigateTo(context, LoginScreen());
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: const [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("Or register by"),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            RegisterCubit.get(context).signInWithGoogle();
                          },
                          child: Image.asset(
                            'assets/images/google.png',
                            // Replace with your Google icon asset
                            height: 45,
                            width: 45,
                          ),
                        ),
                        const SizedBox(width: 30),
                        GestureDetector(
                          onTap: () {
                            RegisterCubit.get(context).signInWithFacebook();
                          },
                          child: Image.asset(
                            'assets/images/facebook.png',
                            // Replace with your Facebook icon asset
                            height: 45,
                            width: 45,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}