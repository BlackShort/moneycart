import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/common/pages/processing_page.dart';
import 'package:moneycart/app/common/widgets/loader.dart';
import 'package:moneycart/app/pf/controllers/pf_controller.dart';
import 'package:moneycart/app/pf/pages/pf_details.dart';
import 'package:moneycart/app/pf/pages/pf_final_otp.dart';
import 'package:moneycart/app/pf/pages/pf_otp.dart';
import 'package:moneycart/app/pf/pages/pf_transfer.dart';

class PfPage extends StatefulWidget {
  const PfPage({super.key});

  @override
  State<PfPage> createState() => _PfPageState();
}

class _PfPageState extends State<PfPage> {
  late PfController otpController;

  @override
  void initState() {
    super.initState();
    otpController = Get.put(PfController());
  }

  void _navigateToPage(Map<String, dynamic> data) {
    if (data['showOtp']) {
      Get.to(() => PfOtp(enableOtp: data['enableOtp']));
    } else if (data['tdsDetails']) {
      Get.to(() => const PfDetails());
    } else if (data['finalOtp']) {
      Get.to(() => PfFinalOtp(enableOtp: data['enableOtp']));
    } else if (data['processing']) {
      Get.to(() => const Processing(
            title: 'PF Refund',
            subTitle: 'Refund in Progress',
            message:
                "You would get the TDS refund in your bank account in 7-15 working days\n\nThank you for using MoneyCart",
          ));
    } else {
      Get.to(() => const PfTransferForm());
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
                    return const PfTransferForm();
                  }
                },
              ),
      ),
    );
  }
}
