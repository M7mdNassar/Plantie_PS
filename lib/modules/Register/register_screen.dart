import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';
import '../Login/login_screen.dart';
import '../SplashScreen/lottie_loading_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';
import '../../generated/l10n.dart';


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
            if (context.mounted) {
              navigateAndFinish(context, LottieLoadingScreen());
            }
          });
        }

        if (state is RegisterCanceldState) {
          showToast(text: state.msg.toString(), state: ToastStates.warning);
        }

        if (state is RegisterErrorState) {
          showToast(
            text: state.error,
            state: ToastStates.error,
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
                      S.of(context).creat_account2,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                        S.of(context).create_account3,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    SizedBox(height: 30),
                    defaultFormField(
                      controller: userNameController,
                      label: S.of(context).name,
                      prefixIcon: Icons.person_outlined,
                      type: TextInputType.text,
                      validate: (String? value) {
                        if (value != null && value.isEmpty) {
                          return S.of(context).enter_name;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 25),
                    defaultFormField(
                      controller: emailController,
                      label: S.of(context).email_address,
                      prefixIcon: Icons.email_outlined,
                      type: TextInputType.emailAddress,
                      validate: (String? value) {
                        if (value != null && value.isEmpty) {
                          return ;
                        }
                        return null;
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
                          return S.of(context).enter_password;
                        }
                        return null;
                      },
                      label: S.of(context).password,
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
                          text: S.of(context).register,
                        ),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text(S.of(context).have_account),
                        GestureDetector(
                          onTap: () {
                            navigateTo(context, LoginScreen());
                          },
                          child: Text(
                            S.of(context).login,
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
                      children:  [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(S.of(context).or_register_by),
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
