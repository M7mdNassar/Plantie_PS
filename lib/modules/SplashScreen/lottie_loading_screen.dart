import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../layout/plantie_layout.dart';

class LottieLoadingScreen extends StatelessWidget {
  const LottieLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AppLayout()),
        );
      }
    });

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Lottie.asset(
            'assets/lottie/loading.json',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
