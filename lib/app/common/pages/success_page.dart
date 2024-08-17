import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/common/pages/payment_page.dart';
import 'package:moneycart/app/referral/pages/redirect_reward.dart';
import 'package:moneycart/config/constants/app_constants.dart';
import 'package:moneycart/core/utils/format_date.dart';
import 'package:screenshot/screenshot.dart';

class SuccessPage extends StatefulWidget {
  final String successMessage;
  final String? buttonText;
  final VoidCallback? callbackAction;
  final bool? redirect;
  final String transactionId;
  final String transactionTo;
  final String transactionFrom;
  final String paymentFrom;

  const SuccessPage({
    super.key,
    required this.successMessage,
    this.callbackAction,
    this.buttonText = 'Done',
    this.redirect = false,
    required this.transactionId,
    required this.transactionTo,
    required this.transactionFrom,
    required this.paymentFrom,
  });

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();

    return Scaffold(
      body: Screenshot(
        controller: screenshotController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
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
                  const SizedBox(height: 20),
                  _buildTransactionDetails(),
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
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildActionButton(
                    text: widget.buttonText ?? 'Done',
                    color: Colors.blue,
                    onPressed: widget.callbackAction ??
                        () {
                          Get.off(() => const PaymentPage());
                        },
                  ),
                  const SizedBox(width: 10),
                  _buildActionButton(
                    text: 'Share',
                    color: Colors.green,
                    icon: Icons.share_rounded,
                    onPressed: () {
                      screenshotController.capture().then((Uint8List? image) {
                        if (image != null) {
                          // Share the screenshot
                          // For example: Share.shareFiles([image.path], text: 'Check out my transaction details!');
                        }
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTransactionDetailRow('UPI ID:', widget.transactionId),
          _buildTransactionDetailRow('Transaction To:', widget.transactionTo),
          _buildTransactionDetailRow(
              'Transaction From:', widget.transactionFrom),
          _buildTransactionDetailRow('Payment Mode:', widget.paymentFrom),
        ],
      ),
    );
  }

  Widget _buildTransactionDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    IconData? icon,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(
              vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        icon: icon != null
            ? Icon(
                icon,
                size: 19,
                color: Colors.white,
              )
            : const SizedBox.shrink(),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
