import 'package:moneycart/app/common/widgets/loading_button.dart';
import 'package:moneycart/app/tds/pages/tds_details.dart';
import 'package:moneycart/config/theme/app_pallete.dart';
import 'package:pinput/pinput.dart';
import 'package:moneycart/app/tds/controllers/tds_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Add this import for SVG support

class TdsBankOtp extends StatefulWidget {
  final bool? enableOtp;
  const TdsBankOtp({
    super.key,
    this.enableOtp = false,
  });

  @override
  State<TdsBankOtp> createState() => _TdsBankOtpState();
}

class _TdsBankOtpState extends State<TdsBankOtp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TdsController controller = Get.put(TdsController());
  Map<String, dynamic>? bankData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBankDetails();
  }

  Future<void> fetchBankDetails() async {
    final data = await controller.fetchBankData();
    setState(() {
      bankData = data;
      isLoading = false;
    });
  }

  Widget _buildBankDetailsCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/bank.svg',
              height: 45,
              width: 45,
              colorFilter: const ColorFilter.mode(
                AppPallete.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Account No.: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: bankData!['bank_account'] ?? 'N/A',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'IFSC Code: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: bankData!['bank_ifsc'] ?? 'N/A',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Confirm Bank Account',
          style: TextStyle(
            color: AppPallete.secondary,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppPallete.secondary,
            size: 19,
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/refresh.svg',
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                AppPallete.secondary,
                BlendMode.srcIn,
              ),
            ),
            onPressed: fetchBankDetails,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: RefreshIndicator(
          onRefresh: fetchBankDetails,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: SvgPicture.asset(
                      'assets/svgs/bank_confim.svg',
                      height: 230,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Enter OTP",
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter the OTP sent to your registered mobile number or email.",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                if (isLoading)
                  const CircularProgressIndicator()
                else if (bankData == null)
                  const Text('No bank details found.'),
                if (!isLoading && bankData != null) _buildBankDetailsCard(),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Enter Confirmation OTP",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 16),
                      Pinput(
                        controller: phoneController,
                        length: 6,
                        defaultPinTheme: PinTheme(
                          width: 50,
                          height: 50,
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(30, 60, 87, 1),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please fill in this field';
                          } else if (val.length != 6) {
                            return 'Please enter a valid 6 digit OTP';
                          } else if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                            return 'Please enter a valid OTP';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => LoadingButton(
                      isLoading: controller.isLoading.value,
                      text: 'Submit',
                      onPressed: () {
                        Get.off(() => const TdsDetails());
                        // if (widget.enableOtp!) {
                        //   if (_formKey.currentState!.validate()) {
                        //     controller.confirmBank(
                        //       phoneController.text.trim(),
                        //     );
                        //   }
                        // } else {
                        //   FocusScope.of(context).unfocus();
                        //   showCustomSnackbar(
                        //     title: "Oops!",
                        //     message:
                        //         "You cannot submit this until you get the OTP.",
                        //   );
                        // }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
