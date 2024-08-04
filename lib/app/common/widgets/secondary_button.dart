import 'package:flutter/material.dart';
import 'package:moneycart/config/theme/app_pallete.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppPallete.boldprimary,
        side: const BorderSide(color: AppPallete.boldprimary, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: AppPallete.boldprimary,
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
