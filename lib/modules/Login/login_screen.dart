import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';
import '../Register/register_screen.dart';
import '../SplashScreen/lottie_loading_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';
import '../../generated/l10n.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final sendEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginLoadingState) {
            CircularProgressIndicator();
          }

          if (state is LoginSuccessState) {
            CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value) {
              if (context.mounted) {
                navigateAndFinish(context, LottieLoadingScreen());
              }
            });
          }

          if (state is LoginCanceldState) {
            showToast(text: state.msg.toString(), state: ToastStates.warning);
          }

          if (state is LoginErrorState) {
            showToast(text: state.error.toString(), state: ToastStates.error);
          }

          if (state is ResetPasswordSuccessState) {
            showToast(
                text: S.of(context).sent_email_to_update_paassword +sendEmailController.text,
                state: ToastStates.success
            );
          }

          if (state is ResetPasswordErrorState) {
            showToast(
                text: state.error.toString(),
                state: ToastStates.error
            );
          }
        },
        builder: (context, state) {
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
                      Text(
                        S.of(context).welcome,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        S.of(context).welcome_back,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 30),

                      // Email Field
                      defaultFormField(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validate: (String? value) {
                          if (value != null && value.isEmpty) {
                            return S.of(context).enter_email;
                          }
                          return null;
                        },
                        label: S.of(context).email_address,
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
                          LoginCubit.get(context).changePasswordVisibility();
                        },
                        validate: (String? value) {
                          if (value != null && value.isEmpty) {
                            return S.of(context).enter_password;
                          }
                          return null;
                        },
                        label: S.of(context).password,
                        prefixIcon: Icons.lock_outline,
                      ),
                      const SizedBox(height: 15),

                      // Forgot password action
                      Center(
                        child: defaultTextButton(
                          function: () {
                            // Capture the outer context before showing dialog
                            final cubit = LoginCubit.get(context);
                            final s = S.of(context);

                            showDialog(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                title: Text(s.reset_password),
                                content: TextField(
                                  controller: sendEmailController,
                                  decoration: InputDecoration(
                                    labelText: s.email_address,
                                    hintText: s.enter_email,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(dialogContext),
                                    child: Text(s.cancel),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Use the captured cubit instance
                                      cubit.resetPassword(
                                        email: sendEmailController.text,
                                      );
                                      Navigator.pop(dialogContext);
                                    },
                                    child: Text(s.submit),
                                  ),
                                ],
                              ),
                            );
                          },
                          text: S.of(context).forget_password,
                          isUperCase: false,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
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
                          text: S.of(context).login,
                        ),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                      const SizedBox(height: 20),

                      // Register Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Text(S.of(context).create_account),
                          GestureDetector(
                            onTap: () {
                              navigateTo(context, RegisterScreen());
                            },
                            child: Text(
                              S.of(context).register,
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
                        children:  [
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(S.of(context).or_login_by),
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
                              'assets/images/google.png',
                              // Replace with your Google icon asset
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
                              'assets/images/facebook.png',
                              // Replace with your Facebook icon asset
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
