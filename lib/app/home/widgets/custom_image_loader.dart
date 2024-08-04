import 'package:flutter/material.dart';

class CustomImageLoader extends StatelessWidget {
  const CustomImageLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: 50,
                height: 50,
                child: Image.asset('assets/images/loading_animation.gif'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
