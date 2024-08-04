import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/common/widgets/form_field.dart';
import 'package:moneycart/app/common/widgets/primary_button.dart';
import 'package:moneycart/app/tds/controllers/tds_controller.dart';
import 'package:moneycart/config/constants/app_constants.dart';
import 'package:moneycart/core/errors/snackbar.dart';

class TdsOtp extends StatefulWidget {
  final bool enableOtp;
  const TdsOtp({super.key, required this.enableOtp});

  @override
  State<TdsOtp> createState() => _TdsOtpState();
}

class _TdsOtpState extends State<TdsOtp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TdsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TDS OTP',
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
        child: SingleChildScrollView(
          child: Container(
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
                  "Enter the OTP sent to your registered mobile number and email id.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 25,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: FormDataInputField(
                              controller: phoneController,
                              hintText: 'Phone OTP',
                              labelText: 'Phone OTP',
                              keyboardType: TextInputType.number,
                              prefixIcon: Icons.call_rounded,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please fill in this field';
                                } else if (val.length > 6 || val.length < 6) {
                                  return 'Please enter a valid 6 digit phone number';
                                } else if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                                  return 'Please enter a valid phone number';
                                }
                                return null;
                                // MoneyCart team would connect with you to file the
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: FormDataInputField(
                              controller: emailController,
                              hintText: 'Email OTP',
                              labelText: 'Email OTP',
                              keyboardType: TextInputType.number,
                              prefixIcon: Icons.mail_rounded,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please fill in this field';
                                } else if (val.length > 6 || val.length < 6) {
                                  return 'Please enter a valid 6 digit phone number';
                                } else if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                                  return 'Please enter a valid phone number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Obx(
                  () {
                    return controller.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : PrimaryButton(
                            text: 'Submit',
                            onPressed: () {
                              if (widget.enableOtp) {
                                if (_formKey.currentState!.validate()) {
                                  controller.submitOTPData(
                                      emailController.text.trim(),
                                      phoneController.text.trim());
                                }
                              } else {
                                FocusScope.of(context).unfocus();
                                showCustomSnackbar(
                                    title: "OPPS!",
                                    message:
                                        "You can not submit this until you get the OTP.");
                                // Get.snackbar('Error', AppConstants.tdsotperror);
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
