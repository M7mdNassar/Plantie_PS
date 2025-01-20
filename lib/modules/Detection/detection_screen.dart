import 'package:flutter/cupertino.dart';

class DetectionScreen extends StatelessWidget {
  const DetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(
          "Detection",
          style: TextStyle(
            fontSize: 50,
          ),
        ),
      ),
    );
  }
}
