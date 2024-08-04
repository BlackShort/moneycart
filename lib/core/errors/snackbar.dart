import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackbar({
  String title = 'Error',
  String message = 'Something went wrong!',
  IconData icon = Icons.error,
  Color iconColor = Colors.white,
  Color bgColor = Colors.redAccent,
  Color borderColor = Colors.red,
}) {
  
  Get.snackbar(
    title, // Title of the snackbar
    message, // Message of the snackbar
    snackPosition: SnackPosition.BOTTOM, // Position of the snackbar
    backgroundColor: bgColor, // Background color of the snackbar
    colorText: Colors.white, // Text color
    icon: Icon(icon, color: iconColor), // Icon to display
    margin: const EdgeInsets.all(16), // Margin around the snackbar
    borderRadius: 8, // Border radius of the snackbar
    borderColor: borderColor, // Border color
    borderWidth: 2, // Border width
    isDismissible: true, // Allow snackbar to be dismissed
    duration: const Duration(seconds: 5), // Duration to show the snackbar
    forwardAnimationCurve: Curves.easeIn, // Forward animation curve
    reverseAnimationCurve: Curves.easeOut, // Reverse animation curve
    animationDuration: const Duration(milliseconds: 400), // Animation duration
  );
}
