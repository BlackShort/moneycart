import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/common/widgets/primary_button.dart';
import 'package:moneycart/app/tds/controllers/tds_controller.dart';
import 'package:moneycart/config/constants/app_constants.dart';

class TdsPayment extends StatefulWidget {
  const TdsPayment({super.key});

  @override
  State<TdsPayment> createState() => _TdsPaymentState();
}

class _TdsPaymentState extends State<TdsPayment> {
  final controller = Get.put(TdsController());
  final paymentSuccessful = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment',
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          height: MediaQuery.of(context).size.height * 0.87,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top section with logo, QR (if applicable), and UPI ID
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        AppConstants.applogo,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  const Text(
                    'Pay to MoneyCart',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Image.asset(
                    AppConstants.payment,
                    height: 250,
                  ),
                  const SizedBox(height: 5.0),
                  GestureDetector(
                    onTap: () async {
                      // Copy the UPI ID to clipboard
                      await Clipboard.setData(
                          const ClipboardData(text: '9958223598@pthdfc'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('UPI ID copied to clipboard!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.content_copy),
                          onPressed: null,
                        ),
                        Text(
                          '9958223598@pthdfc',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20.0),
              Obx(
                () => controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : PrimaryButton(
                        text: 'Pay Now',
                        onPressed: () {
                          Navigator.pop(context);
                          controller.makePayment();
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}