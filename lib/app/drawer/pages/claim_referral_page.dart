import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneycart/config/theme/app_pallete.dart';
import 'package:moneycart/app/common/widgets/primary_button.dart';

class ClaimReferralPage extends StatefulWidget {
  const ClaimReferralPage({super.key});

  @override
  State<ClaimReferralPage> createState() => _ClaimReferralPageState();
}

class _ClaimReferralPageState extends State<ClaimReferralPage> {
  final TextEditingController _referralController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Referrals',
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
              TextField(
                controller: _referralController,
                decoration: InputDecoration(
                  labelText: 'Enter referral code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                text: 'Submit Referral',
                onPressed: () {
                  // Handle referral submission
                  final referralCode = _referralController.text;
                  if (referralCode.isNotEmpty) {
                    // Submit the referral code to the backend or API
                    Get.snackbar('Referral Submitted', 'Thank you for your referral.');
                    _referralController.clear();
                  } else {
                    Get.snackbar('Error', 'Please enter a referral code.');
                  }
                },
                color: AppPallete.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
