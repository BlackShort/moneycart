import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/common/widgets/primary_button.dart';
import 'package:moneycart/config/routes/route_names.dart';
import 'package:moneycart/config/theme/app_pallete.dart';

class OnboardPage extends StatelessWidget {
  const OnboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(flex: 2),
            SvgPicture.asset(
              'assets/svgs/business_deal3.svg',
              height: 280,
            ),
            const Text(
              'Welcome to MoneyCart!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              'Apna Paisa haq se Mango!',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                color: AppPallete.boldprimary,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 2),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'Get Started',
                onPressed: () {
                  Get.toNamed(AppRoute.signup);
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
