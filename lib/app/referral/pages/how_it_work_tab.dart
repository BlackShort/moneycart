import 'package:flutter/material.dart';
import 'package:moneycart/config/constants/app_constants.dart';
import 'package:moneycart/config/theme/app_pallete.dart';

class HowItWorksPage extends StatelessWidget {
  const HowItWorksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildStep(
              stepNumber: "Step 1",
              description: AppConstants.step1,
            ),
            _buildStep(
              stepNumber: "Step 2",
              description: AppConstants.step2,
            ),
            _buildStep(
              stepNumber: "Step 3",
              description: AppConstants.step3,
            ),
            const SizedBox(height: 16),
            const Text(
              'So keep referring and start earning unlimited cashback!!!',
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({required String stepNumber, required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stepNumber,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: AppPallete.secondary,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
