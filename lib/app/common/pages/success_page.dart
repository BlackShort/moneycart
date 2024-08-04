import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/base/pages/base_page.dart';
import 'package:moneycart/app/common/widgets/primary_button.dart';
import 'package:moneycart/app/referral/pages/redirect_reward.dart';
import 'package:moneycart/config/constants/app_constants.dart';
import 'package:moneycart/core/utils/format_date.dart';

class SuccessPage extends StatefulWidget {
  final String successMessage;
  final String? buttonText;
  final VoidCallback? callbackAction;
  final bool? redirect;

  const SuccessPage({
    super.key,
    required this.successMessage,
    this.callbackAction,
    this.buttonText = 'Done',
    this.redirect = false,
  });

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Success',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: Navigator.of(context).canPop(),
        backgroundColor: const Color(0xFF56c596),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(15), // Adjust padding as needed
                  decoration: BoxDecoration(
                    color: Colors.green, // Background color
                    borderRadius:
                        BorderRadius.circular(50), // Optional: Round corners
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white, // Icon color
                    size: 55,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  widget.successMessage,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                if (widget.redirect == true)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () {
                        Get.off(() => const RedirectReward());
                      },
                      child: const Text(
                        AppConstants.referrlButton,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              '${formatDateByddMMYYYY(now)}, ${formatTime(now)}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: widget.buttonText ?? 'Done',
              onPressed: widget.callbackAction ??
                  () {
                    Get.offAll(() => const BasePage());
                  },
            ),
          ],
        ),
      ),
    );
  }
}
