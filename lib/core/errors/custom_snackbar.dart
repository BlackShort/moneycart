import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class CustomSnackbar {
  // Show success snackbar
  static void showSuccess({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    _showSnackbar(
      context: context,
      title: title,
      message: message,
      contentType: ContentType.success,
    );
  }

  // Show failure snackbar
  static void showFailure({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    _showSnackbar(
      context: context,
      title: title,
      message: message,
      contentType: ContentType.failure,
    );
  }

  // Show warning snackbar
  static void showWarning({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    _showSnackbar(
      context: context,
      title: title,
      message: message,
      contentType: ContentType.warning,
    );
  }

  // Show info snackbar
  static void showInfo({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    _showSnackbar(
      context: context,
      title: title,
      message: message,
      contentType: ContentType.help,
    );
  }

  // Private method to show snackbar
  static void _showSnackbar({
    required BuildContext context,
    required String title,
    required String message,
    required ContentType contentType,
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
