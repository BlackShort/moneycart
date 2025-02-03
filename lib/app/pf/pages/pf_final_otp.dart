import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/common/pages/payment_page.dart';
import 'package:moneycart/app/common/widgets/loading_button.dart';
import 'package:moneycart/app/pf/controllers/pf_controller.dart';
import 'package:moneycart/config/theme/app_pallete.dart';
import 'package:pinput/pinput.dart';

class PfFinalOtp extends StatefulWidget {
  final bool? enableOtp;
  const PfFinalOtp({
    super.key,
    this.enableOtp = false,
  });
  @override
  State<PfFinalOtp> createState() => _PfFinalOtpState();
}

class _PfFinalOtpState extends State<PfFinalOtp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PfController());

    Future<void> refresh() async {
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
            onPressed: refresh,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: RefreshIndicator(
          color: AppPallete.boldprimary,
          onRefresh: refresh,
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
      "Enter the OTP sent to your registered mobile number for the validation.",
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
            validator: _validateOtp,
          ),
        ],
      ),
    );
  }

  Widget _buildOtpInputField({
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Pinput(
          controller: controller,
          length: 6,
          defaultPinTheme: PinTheme(
            width: 45,
            height: 45,
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
    );
  }

  Widget _buildSubmitButton(PfController controller) {
    return SizedBox(
      width: double.infinity,
      child: Obx(
        () => LoadingButton(
          isLoading: controller.isLoading.value,
          text: 'Submit',
          onPressed: () {
            Get.off(() => const PaymentPage());

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
