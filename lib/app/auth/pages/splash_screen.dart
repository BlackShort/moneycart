import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      // Get.offNamed(RouteNames.select);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            Image.asset(
              'assets/images/splash_sawaari_logo.png',
              width: 200,
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Sawaari',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF725E),
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
