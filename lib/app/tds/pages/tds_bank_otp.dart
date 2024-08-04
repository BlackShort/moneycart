import 'package:moneycart/app/common/widgets/custom_text_field.dart';
import 'package:moneycart/app/common/widgets/loader.dart';
import 'package:moneycart/app/common/widgets/primary_button.dart';
import 'package:moneycart/app/tds/controllers/tds_controller.dart';
import 'package:moneycart/config/constants/app_constants.dart';
import 'package:moneycart/core/errors/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Account No.: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
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
                      fontWeight: FontWeight.bold,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Confirm Bank Account',
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
                Image.asset(
                  AppConstants.otpImg,
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
                const Text(
                  "Enter OTP",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Enter the OTP sent to your registered mobile number or email id.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
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
                      CustomTextField(
                        controller: phoneController,
                        labelText: 'Enter OTP',
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.call_rounded,
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
                const SizedBox(height: 50),
                Obx(
                  () {
                    return controller.isLoading.value
                        ? const Center(
                            child: Loader(),
                          )
                        : PrimaryButton(
                            text: 'Submit',
                            onPressed: () {
                              if (widget.enableOtp!) {
                                if (_formKey.currentState!.validate()) {
                                  controller.confirmBank(
                                    phoneController.text.trim(),
                                  );
                                }
                              } else {
                                FocusScope.of(context).unfocus();
                                showCustomSnackbar(
                                  title: "Oops!",
                                  message:
                                      "You cannot submit this until you get the OTP.",
                                );
                              }
                            },
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
