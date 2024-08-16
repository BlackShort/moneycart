import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/common/widgets/loading_button.dart';
import 'package:moneycart/app/tds/controllers/tds_controller.dart';
import 'package:moneycart/app/tds/pages/tds_bank_otp.dart';
import 'package:moneycart/config/theme/app_pallete.dart';
import 'package:pinput/pinput.dart';

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

    Future<void> _refresh() async {
      await controller.fetchOTPState();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E-Validation',
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
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeaderImage(),
              const SizedBox(height: 16),
              _buildTitleText(),
              const SizedBox(height: 4),
              _buildDescriptionText(),
              const SizedBox(height: 25),
              _buildOtpForm(),
              const SizedBox(height: 50),
              _buildSubmitButton(controller),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: SvgPicture.asset(
          'assets/svgs/tds_otp.svg',
          height: 230,
        ),
      ),
    );
  }

  Widget _buildTitleText() {
    return const Text(
      "Enter OTP",
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
       ),
    );
  }

  Widget _buildDescriptionText() {
    return const Text(
      "Enter the OTP sent to your registered mobile number or email id for the E-Validation.",
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'Poppins',
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildOtpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildOtpInputField(
            controller: phoneController,
            labelText: 'Phone OTP',
            validator: _validateOtp,
          ),
        ],
      ),
    );
  }

  Widget _buildOtpInputField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
        color: Colors.grey[200],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Pinput(
            controller: controller,
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
            validator: validator,
            hapticFeedbackType: HapticFeedbackType.lightImpact,
            onCompleted: (pin) {
              debugPrint('onCompleted: $pin');
            },
            focusedPinTheme: PinTheme(
              width: 50,
              height: 50,
              textStyle: const TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(30, 60, 87, 1),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppPallete.primary),
              ),
            ),
            submittedPinTheme: PinTheme(
              width: 50,
              height: 50,
              textStyle: const TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(30, 60, 87, 1),
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppPallete.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(TdsController controller) {
    return SizedBox(
      width: double.infinity,
      child: Obx(
        () => LoadingButton(
          isLoading: controller.isLoading.value,
          text: 'Submit',
          onPressed: () {
            Get.off(() => const TdsBankOtp(
                  enableOtp: true,
                ));
            // if (widget.enableOtp) {
            //   if (_formKey.currentState!.validate()) {
            //     controller.submitOTPData(
            //       emailOtpController.text.trim(),
            //       phoneOtpController.text.trim(),
            //     );
            //   }
            // } else {
            //   FocusScope.of(context).unfocus();
            //   CustomSnackbar.showFailure(
            //     context: context,
            //     title: "OPPS!",
            //     message: "You cannot submit this until you get the OTP.",
            //   );
            // }
          },
        ),
      ),
    );
  }

  String? _validateOtp(String? val) {
    if (val == null || val.isEmpty) {
      return 'Please fill in this field';
    } else if (val.length != 6) {
      return 'Please enter a valid 6-digit OTP';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
      return 'Please enter a valid OTP';
    }
    return null;
  }
}
