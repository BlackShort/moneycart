import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneycart/config/theme/app_pallete.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Settings',
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                leading:
                    const Icon(Icons.notifications, color: AppPallete.primary),
                title: const Text('Notifications'),
                trailing: Switch(
                  value: true, // Replace with actual value
                  onChanged: (value) {
                    // Handle toggle
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.language, color: AppPallete.primary),
                title: const Text('Language'),
                onTap: () {
                  // Navigate to language selection page
                  Get.toNamed('/language');
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock, color: AppPallete.primary),
                title: const Text('Privacy'),
                onTap: () {
                  // Navigate to privacy settings page
                  Get.toNamed('/privacy');
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.description, color: AppPallete.primary),
                title: const Text('Terms & Conditions'),
                onTap: () {
                  // Navigate to terms and conditions page
                  Get.toNamed('/terms');
                },
              ),
              ListTile(
                leading: const Icon(Icons.feedback, color: AppPallete.primary),
                title: const Text('Feedback'),
                onTap: () {
                  // Navigate to feedback page
                  Get.toNamed('/feedback');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
