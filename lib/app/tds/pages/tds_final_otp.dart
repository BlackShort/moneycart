import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/common/widgets/form_field.dart';
import 'package:moneycart/app/common/widgets/primary_button.dart';
import 'package:moneycart/app/tds/controllers/tds_controller.dart';
import 'package:moneycart/config/constants/app_constants.dart';
import 'package:moneycart/core/errors/snackbar.dart';

class TdsFinalOtp extends StatefulWidget {
  final bool? enableOtp;
  const TdsFinalOtp({
    super.key,
    this.enableOtp = false,
  });

  @override
  State<TdsFinalOtp> createState() => _TdsFinalOtpState();
}

class _TdsFinalOtpState extends State<TdsFinalOtp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TdsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E-Validation',
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
              const SizedBox(height: 5),
              const Text(
                "Enter OTP",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Enter the OTP sent to your registered mobile number or email id for the E-Validation.",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 35),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    FormDataInputField(
                      controller: phoneController,
                      hintText: 'Enter OTP',
                      labelText: 'Enter OTP',
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
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : PrimaryButton(
                          text: 'Submit',
                          onPressed: () {
                            if (widget.enableOtp!) {
                              if (_formKey.currentState!.validate()) {
                                controller.eValidation(
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
    );
  }
}
