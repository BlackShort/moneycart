import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneycart/config/theme/app_pallete.dart';
import 'package:moneycart/core/errors/custom_snackbar.dart';
import 'package:moneycart/core/utils/format_date.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final ScreenshotController screenshotController = ScreenshotController();
  final DateTime now = DateTime.now();

  Future<void> _captureAndShareScreenshot() async {
    try {
      // Capture the screenshot
      final Uint8List? image = await screenshotController.capture(
        delay: const Duration(milliseconds: 200), // Ensure rendering completes
        pixelRatio: 2.0, // Higher quality image
      );

      if (image == null) {
        CustomSnackbar.showFailure(
          context: context,
          title: 'Screenshot Failed',
          message: 'Could not capture screenshot.',
        );
        return;
      }

      // Get a temporary directory
      final directory = await getTemporaryDirectory();
      final imagePath = File('${directory.path}/screenshot.png');

      // Write the screenshot data to the file
      await imagePath.writeAsBytes(image);

      // Ensure file exists before sharing
      if (await imagePath.exists()) {
        final XFile xfile = XFile(imagePath.path);
        await Share.shareXFiles([xfile],
            text: 'Check out my transaction details!');
      } else {
        throw 'Screenshot file does not exist!';
      }
    } catch (e) {
      CustomSnackbar.showFailure(
        context: context,
        title: 'Screenshot Failed',
        message: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screenshot(
        controller: screenshotController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
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
                      size: 65,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  const Text(
                    '₹1000.00',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Paid to MoneyCart Team',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'UPI ID: TXN9876543210',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Text(
                    '${formatDateByddMMYYYY(now)}, ${formatTime(now)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Transaction ID: TXN9876543210',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(
                    text: 'Share Screenshot',
                    color: AppPallete.boldprimary,
                    icon: Icons.share_rounded,
                    onPressed: _captureAndShareScreenshot,
                  ),
                  const SizedBox(width: 16),
                  _buildActionButton(
                    text: 'Done',
                    color: AppPallete.boldprimary,
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    IconData? icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: icon == null ? color : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: color, width: 2),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, size: 19, color: color),
          if (icon != null) const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: icon == null ? Colors.white : color,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
