import 'package:flutter/material.dart';
import 'package:moneycart/app/common/widgets/loader.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Loader(),
      ),
    );
  }
}
