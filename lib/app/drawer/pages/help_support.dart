import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneycart/config/theme/app_pallete.dart';
import 'package:moneycart/app/common/widgets/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupportPage extends StatelessWidget {
  const HelpAndSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help & Support',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFAQSection(),
            const SizedBox(height: 32),
            _buildContactSupportSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Frequently Asked Questions (FAQs)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 16),
        _buildFAQItem(
          question: 'How do I reset my password?',
          answer:
              'You can reset your password by going to the settings and selecting "Reset Password". You will receive a link to create a new password.',
        ),
        _buildFAQItem(
          question: 'How do I contact support?',
          answer:
              'You can contact our support team through the "Contact Support" section below or email us at support@example.com.',
        ),
        _buildFAQItem(
          question: 'What should I do if I encounter a bug?',
          answer:
              'If you encounter a bug, please report it using the feedback option or contact our support team with details about the issue.',
        ),
      ],
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Contact Support',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 16),
        PrimaryButton(
          text: 'Chat with Us',
          onPressed: () {
            // Navigate to the chat screen or show chat interface
            Get.toNamed('/chat');
          },
          color: AppPallete.primary,
        ),
        const SizedBox(height: 16),
        PrimaryButton(
          text: 'Email Us',
          onPressed: () async {
            final Uri emailUri = Uri(
              scheme: 'mailto',
              path: 'support@example.com',
              queryParameters: {'subject': 'Support Request'},
            );
            if (await canLaunchUrl(emailUri)) {
              await launchUrl(emailUri);
            } else {
              // Handle the error if the email client cannot be opened
              Get.snackbar('Error', 'Could not open email client');
            }
          },
          color: AppPallete.secondary,
        ),
        const SizedBox(height: 16),
        PrimaryButton(
          text: 'Call Us',
          onPressed: () async {
            final Uri phoneUri = Uri(
              scheme: 'tel',
              path: '1234567890',
            );
            if (await canLaunchUrl(phoneUri)) {
              await launchUrl(phoneUri);
            } else {
              // Handle the error if the phone dialer cannot be opened
              Get.snackbar('Error', 'Could not open phone dialer');
            }
          },
        ),
      ],
    );
  }
}
