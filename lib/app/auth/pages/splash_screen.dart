import 'package:flutter/material.dart';
import 'package:moneycart/config/theme/app_pallete.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 200,
              height: MediaQuery.of(context).size.height * 0.58,
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/logo/moneycart_logo.png',
                width: 130,
              ),
            ),
            Container(
              width: 200,
              height: MediaQuery.of(context).size.height * 0.2,
              alignment: Alignment.center,
              child: const Text(
                'Moneycart',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.boldprimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
