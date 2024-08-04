import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneycart/config/theme/app_pallete.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Widget screen;

  const ServiceCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(screen);
      },
      child: Card(
        color: const Color(0x9BF7F7F7),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppPallete.black,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
