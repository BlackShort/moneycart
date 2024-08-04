import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/common/pages/processing_page.dart';
import 'package:moneycart/app/common/widgets/loader.dart';
import 'package:moneycart/app/tds/controllers/tds_controller.dart';
import 'package:moneycart/app/tds/pages/tds_bank_otp.dart';
import 'package:moneycart/app/tds/pages/tds_details.dart';
import 'package:moneycart/app/tds/pages/tds_final_otp.dart';
import 'package:moneycart/app/tds/pages/tds_form.dart';
import 'package:moneycart/app/tds/pages/tds_otp.dart';

class TdsPage extends StatefulWidget {
  const TdsPage({super.key});

  @override
  State<TdsPage> createState() => _TdsPageState();
}

class _TdsPageState extends State<TdsPage> {
  late TdsController otpController;

  @override
  void initState() {
    super.initState();
    otpController = Get.put(TdsController());
  }

  void _navigateToPage(Map<String, dynamic> data) {
    if (data['showOtp']) {
      Get.to(() => TdsOtp(enableOtp: data['enableOtp']));
    } else if (data['bankconfirm']) {
      Get.to(() => TdsBankOtp(enableOtp: data['enableOtp']));
    } else if (data['tdsDetails']) {
      Get.to(() => const TdsDetails());
    } else if (data['finalOtp']) {
      Get.to(() => TdsFinalOtp(enableOtp: data['enableOtp']));
    } else if (data['processing']) {
      Get.to(() => const Processing(
            title: 'TDS Refund',
            subTitle: 'Refund in Progress',
            message:
                "You would get the TDS refund in your bank account in 7-30 working days\n\nThank you for using MoneyCart",
          ));
    } else {
      Get.to(() => const TdsForm());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => otpController.isLoading.value
            ? Container(
                color: Colors.white,
                child: const Loader(),
              )
            : FutureBuilder<Map<String, dynamic>?>(
                future: otpController.fetchOTPState(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      color: Colors.white,
                      child: const Loader(),
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _navigateToPage(data);
                    });
                    return Container(); // Return an empty container or a placeholder
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                              'Something went wrong! \n Please try again.'),
                          ElevatedButton(
                            onPressed: () {
                              setState(
                                  () {}); // Rebuild the widget to fetch data again
                            },
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const TdsForm();
                  }
                },
              ),
      ),
    );
  }
}
