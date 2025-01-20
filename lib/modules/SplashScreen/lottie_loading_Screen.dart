import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../layout/plantie_layout.dart';

class LottieLoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AppLayout()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
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
