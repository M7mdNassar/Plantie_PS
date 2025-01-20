import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



Widget defaultButton({
  required VoidCallback function,
  required String text,
  Color backgroundColor = Colors.teal,
  Color textColor = Colors.white,
  double fontSize = 16.0,
  double borderRadius = 30.0,
}) {
  return ElevatedButton(
    onPressed: function,
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      minimumSize: const Size(double.infinity, 50), // Full-width button
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    ),
  );
}



Widget defaultTextButton({
  required VoidCallback function,
  required String text,
  bool isUperCase = false,
  TextStyle? style, // Optional style parameter
}) =>
    TextButton(
      onPressed: function,
      child: Text(
        isUperCase ? text.toUpperCase() : text,
        style: style ??
            const TextStyle(
              color: Color(0xFF00C853), // Default color
              fontWeight: FontWeight.bold,
              fontSize: 16, // Default size
            ),
      ),
    );





Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  IconData? prefixIcon,
  IconData? suffixIcon,
  required String? Function(String?) validate, // Function for validation
  Function(String)? onSubmit,
  Function(String)? onChanged,
  VoidCallback? onTap,
  bool obscureText = false,
  bool enabled = true,
  VoidCallback? onSuffexPressed,
}) =>
    TextFormField(
      keyboardType: type,
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      onTap: onTap,
      onFieldSubmitted: onSubmit,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: onSuffexPressed, // Ensure this is nullable
              )
            : null,
        border: const OutlineInputBorder(),
      ),
      validator: validate,
      enabled: enabled,
    );



void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );




void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) {
        return false;
      },
    );



void showToast({
  required String text,
  required ToastStates state,
  gravity = ToastGravity.BOTTOM,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );



// enum
enum ToastStates { SUCCESS, ERROR, WARNING, INFO }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
    case ToastStates.INFO:
      color = Colors.amber;
      break;
  }

  return color;
}

