import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/styles/colors.dart';
import '../Register/register_screen.dart';
import '../SplashScreen/lottie_loading_Screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit , LoginStates>(
        listener: (context, state) {
          if (state is LoginLoadingState){
            CircularProgressIndicator();
          }

          if (state is LoginSuccessState) {
            CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value) {
              navigateAndFinish(context, LottieLoadingScreen());
            });
          }

          if (state is LoginCanceldState){
            showToast(text: state.msg.toString(), state: ToastStates.WARNING);
          }

          if (state is LoginErrorState){
            showToast(text: state.error.toString(), state: ToastStates.ERROR);
          }
        },
        builder: (context , state){
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
                      const SizedBox(height: 20),

                      // Welcome Text
                      const Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Hello, Welcome back to Plantie!",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Email Field
                      defaultFormField(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validate: (String? value){
                          if (value != null && value.isEmpty) {
                            return 'please enter your email address';
                          }
                        },
                        label: "Email Address",
                        prefixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      defaultFormField(
                        controller: passwordController,
                        type: TextInputType.visiblePassword,
                        suffixIcon: LoginCubit.get(context).suffix,
                        onSubmit: (value) {
                          if (formKey.currentState!.validate()) {
                            LoginCubit.get(context).userLogin(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                          }
                        },
                        obscureText: LoginCubit.get(context).isPassword,
                        onSuffexPressed: () {
                          LoginCubit.get(context)
                              .changePasswordVisibility();
                        },
                        validate: (String? value) {
                          if (value != null && value.isEmpty) {
                            return 'password is too short';
                          }
                        },
                        label: "Password",
                        prefixIcon: Icons.lock_outline,
                      ),
                      const SizedBox(height: 15),

                      // Forgot Password in Center
                      Center(
                        child: defaultTextButton(
                          function: () {
                            // Forgot password action
                          },
                          text: "Forget Password?",
                          isUperCase: false,
                          style: const TextStyle(
                            color: Colors.blue, // Blue color for the text
                            fontSize: 14, // Smaller font size
                            fontWeight: FontWeight.normal, // Normal weight
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Login Button using defaultButton
                      ConditionalBuilder(
                        condition: state is! LoginLoadingState,
                        builder: (context) => defaultButton(
                          function: () {
                            if (formKey.currentState!.validate()) {
                              LoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          text: 'login',
                          backgroundColor: plantieColor,
                        ),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                      const SizedBox(height: 20),

                      // Register Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("create account? "),
                          GestureDetector(
                            onTap: () {
                              navigateTo(context, RegisterScreen());
                            },
                            child: const Text(
                              "Register?",
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Divider with "Or login by"
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
                            child: Text("or login by"),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Social Login Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              LoginCubit.get(context).signInWithGoogle();
                            },
                            child: Image.asset(
                              'assets/images/google.png', // Replace with your Google icon asset
                              height: 45,
                              width: 45,
                            ),
                          ),
                          const SizedBox(width: 30),
                          GestureDetector(
                            onTap: () {
                              LoginCubit.get(context).signInWithFacebook();
                            },
                            child: Image.asset(
                              'assets/images/facebook.png', // Replace with your Facebook icon asset
                              height: 45,
                              width: 45,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
