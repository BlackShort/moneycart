import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: MediaQuery.of(context).size.height * 0.5,
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/moneycart_image.png',
                width: 200,
              ),
            ),
            Container(
              width: 200,
              height: MediaQuery.of(context).size.height * 0.5,
              alignment: Alignment.bottomCenter,
              child: const Text(
                'Moneycart',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF725E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
