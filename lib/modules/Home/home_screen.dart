import 'package:flutter/cupertino.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(
          "Home",
          style: TextStyle(
            fontSize: 50,
          ),
        ),
      ),
    );
  }
}
