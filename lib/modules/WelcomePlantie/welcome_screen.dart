import 'package:flutter/material.dart';
import '../../shared/components/components.dart';
import '../Login/login_screen.dart';
import '../Register/register_screen.dart';
import '../../generated/l10n.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            // Image Section
            Expanded(
              flex: 3,
              child: Center(
                child: Image.asset(
                  'assets/images/farmer.png', // Replace with your image path
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Text Section
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).welcome_title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    S.of(context).welcome_subtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),

            // Buttons Section
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center buttons
                children: [
                  // Login Button using defaultButton from components
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    child: defaultButton(
                      function: () {
                        navigateTo(context, LoginScreen());
                      },
                      text: S.of(context).login_button,
                    ),
                  ),
                  // Register Button using defaultButton from components
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    child: defaultButton(
                      function: () {
                        navigateTo(context, RegisterScreen());
                      },
                      text: S.of(context).register_button,
                    ),
                  ),
                ],
              ),
            ),
            // Terms and Conditions Section
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 20.0), // Adjust padding
              child: Text(
                S.of(context).terms_and_conditions,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
