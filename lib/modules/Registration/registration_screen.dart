import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/generated/l10n.dart';
import 'package:plantie/layout/plantie_layout.dart';
import 'package:plantie/shared/components/components.dart';
import 'package:plantie/shared/styles/app_colors.dart';
import 'cubit/registration_cubit.dart';
import 'cubit/registration_state.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nameFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  void _handleRegister(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<RegistrationCubit>().register(_nameController.text);
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.of(context).nameRequired;
    }
    if (value.trim().length < 2) {
      return S.of(context).nameTooShort;
    }

    // Use unicode: true and \p{L} to allow letters from ANY language (including Arabic) + spaces
    if (!RegExp(r'^[\p{L}\s]+$', unicode: true).hasMatch(value)) {
      // Note: You might want to move this string to your localization files (S.of(context)) later
      return 'Letters and spaces only';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = S.of(context);
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (_) => RegistrationCubit(),
      child: BlocListener<RegistrationCubit, RegistrationState>(
        listenWhen: (p, c) => p.runtimeType != c.runtimeType,
        listener: (context, state) {
          if (state is RegistrationSuccess) {
            navigateAndFinish(context, const AppLayout());
          } else if (state is RegistrationError) {
            showToast(
              text: state.message,
              state: ToastStates.error,
            );
          }
        },
        child: Scaffold(
          backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          body: Semantics(
            label: 'Registration Screen',
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                      child: Column(
                        children: [
                          // Top Section - Image & Title
                          Semantics(
                            label: 'Farmer illustration',
                            image: true,
                            child: Container(
                              height: size.height * 0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.15),
                                    blurRadius: 30,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/images/farmer.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Semantics(
                            header: true,
                            child: Text(
                              s.welcomeToPlantie,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColors.darkText : AppColors.primary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Semantics(
                            child: Text(
                              s.discoverPlantCare,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (isDark ? Colors.black : AppColors.primary)
                                .withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(32, 40, 32, 24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Semantics(
                                textField: true,
                                label: 'Name input field',
                                hint: 'Enter your full name',
                                child: TextFormField(
                                  controller: _nameController,
                                  focusNode: _nameFocus,
                                  validator: _validateName,
                                  style: TextStyle(
                                    color: isDark ? AppColors.darkText : Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: s.nameHint,
                                    labelText: s.whatsYourName,
                                    filled: true,
                                    fillColor: isDark
                                        ? AppColors.darkBackground
                                        : Colors.grey[50],
                                    prefixIcon: Icon(
                                      Icons.person_rounded,
                                      color: AppColors.primary,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: AppColors.primary.withValues(alpha: 0.1),
                                        width: 1.5,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: AppColors.primary,
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Colors.redAccent,
                                        width: 1.5,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 20,
                                    ),
                                  ),
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _handleRegister(context),
                                ),
                              ),
                              const Spacer(),
                              const SizedBox(height: 24),
                              BlocBuilder<RegistrationCubit, RegistrationState>(
                                buildWhen: (p, c) => p.runtimeType != c.runtimeType,
                                builder: (context, state) {
                                  final isLoading = state is RegistrationLoading;
                                  return Semantics(
                                    button: true,
                                    label: 'Start Registration',
                                    enabled: !isLoading,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: AppColors.greenGradient,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary.withValues(alpha: 0.3),
                                            blurRadius: 15,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: isLoading ? null : () => _handleRegister(context),
                                          borderRadius: BorderRadius.circular(16),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 18),
                                            child: isLoading
                                                ? const SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child: CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<Color>(Colors.white),
                                                    strokeWidth: 2.5,
                                                  ),
                                                )
                                                : Text(
                                                  s.letsStart,
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                        letterSpacing: 1.2,
                                                      ),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

