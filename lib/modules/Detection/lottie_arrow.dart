import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieArrow extends StatefulWidget {
  const LottieArrow({super.key});

  @override
  _LottieArrow createState() => _LottieArrow();
}

class _LottieArrow extends State<LottieArrow> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible,
      child: SizedBox.expand(
        // <-- Added SizedBox.expand
        child: Stack(
          children: [
            // Semi-transparent background
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Tap the camera button below\nto start scanning your plants',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  // Lottie animation
                  SizedBox(
                    height: 200,
                    child: Lottie.asset(
                      'assets/lottie/arrow_down.json',
                      fit: BoxFit.contain,
                      repeat: true,
                      animate: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
