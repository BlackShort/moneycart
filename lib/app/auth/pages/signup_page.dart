import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/auth/controllers/auth_controller.dart';
import 'package:moneycart/app/common/widgets/custom_text_field.dart';
import 'package:moneycart/app/common/widgets/loading_button.dart';
import 'package:moneycart/config/theme/app_pallete.dart';
import 'package:moneycart/core/utils/country_codes.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _phoneController = TextEditingController();
  final List<Country> countries = CountryCodes.getCountries();
  late Country _selectedCountry = countries[0];
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            Get.back();
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_back_ios_rounded,
                color: AppPallete.secondary,
                size: 19,
              ),
              SizedBox(width: 8),
              Text(
                'Back',
                style: TextStyle(
                  color: AppPallete.secondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 19,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Spacer(flex: 1),
                    Center(
                      child: Column(
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
                                'assets/svgs/signup.svg',
                                height: 230,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Continue with Phone',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IntrinsicWidth(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<Country>(
                              value: _selectedCountry,
                              items: countries
                                  .map((country) => DropdownMenuItem(
                                        value: country,
                                        child: Text(
                                          '${country.flag}  ${country.code}',
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            color: Colors.black,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCountry = value!;
                                });
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                controller: _phoneController,
                                labelText: 'Phone Number',
                                keyboardType: TextInputType.number,
                                letterSpacing: 2,
                                validator: _validatePhoneNumber,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.green,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'By signing up, you agree to the ',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppPallete.secondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Add your terms of service link here
                            },
                            child: const Text(
                              'Terms of service',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppPallete.primary,
                              ),
                            ),
                          ),
                          const Text(
                            ' and ',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppPallete.secondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Add your privacy policy link here
                            },
                            child: const Text(
                              'Privacy policy',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppPallete.primary,
                              ),
                            ),
                          ),
                          const Text(
                            '.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppPallete.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 1),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: LoadingButton(
                          text: 'Continue',
                          isLoading: _authController.isLoading.value,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              String phone = _selectedCountry.code +
                                  _phoneController.text.trim();
                              await _authController.signInWithPhone(phone);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
