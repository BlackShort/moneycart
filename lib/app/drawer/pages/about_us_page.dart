import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
            fontFamily: 'Poppins',
          ),
        ),
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 19,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'About Our App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Our app aims to revolutionize the way people travel by providing a seamless and convenient ride-sharing experience. With our state-of-the-art technology and user-friendly interface, we are committed to making your journey as comfortable and efficient as possible.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Our Team',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'We are a dedicated team of professionals with a passion for innovation and excellence. Our team brings together expertise from various fields to create a product that is both functional and delightful to use.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
