import 'package:flutter/material.dart';
import 'package:moneycart/config/theme/app_pallete.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppPallete.primary),
        ),
      ),
    );
  }
}
