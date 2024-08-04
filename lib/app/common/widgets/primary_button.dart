import 'package:flutter/material.dart';
import 'package:moneycart/config/theme/app_pallete.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const PrimaryButton({
    super.key,
    this.color,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppPallete.white,
        backgroundColor: color ?? AppPallete.boldprimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        elevation: 2,
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
