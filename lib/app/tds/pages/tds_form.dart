import 'package:moneycart/app/common/widgets/form_field.dart';
import 'package:moneycart/app/common/widgets/primary_button.dart';
import 'package:moneycart/app/tds/controllers/tds_controller.dart';
import 'package:moneycart/config/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class TdsForm extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const TdsForm(),
      );
  const TdsForm({super.key});

  @override
  State<TdsForm> createState() => _TdsFormState();
}

class _TdsFormState extends State<TdsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final panRegExp = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
  DateTime? selectedDate;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _confirmBankAccountController =
      TextEditingController();
  final TextEditingController _bankIFSCController = TextEditingController();
  final TextEditingController _panController = TextEditingController();

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      dateFormat: "dd-MMMM-yyyy",
      locale: DateTimePickerLocale.en_us,
      looping: true,
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        _dobController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your date of birth';
    }
    final DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(value);
    if (parsedDate.isAfter(DateTime.now())) {
      return 'Date of birth cannot be in the future';
    }
    return null;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _aadharController.dispose();
    _pinCodeController.dispose();
    _addressController.dispose();
    _bankAccountController.dispose();
    _confirmBankAccountController.dispose();
    _bankIFSCController.dispose();
    _panController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TdsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TDS Filing',
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
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Income Tax Registration Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 20),
                  FormDataInputField(
                    labelText: 'First Name',
                    hintText: 'First name as per PAN',
                    prefixIcon: Icons.person,
                    controller: _firstNameController,
                    keyboardType: TextInputType.name,
                    validator:
                        ValidationBuilder().minLength(3).maxLength(20).build(),
                  ),
                  const SizedBox(height: 12),
                  FormDataInputField(
                    labelText: 'Last Name',
                    hintText: 'Last name as per PAN',
                    prefixIcon: Icons.person,
                    controller: _lastNameController,
                    keyboardType: TextInputType.name,
                    validator:
                        ValidationBuilder().minLength(3).maxLength(20).build(),
                  ),
                  const SizedBox(height: 12),
                  FormDataInputField(
                    labelText: 'Email',
                    hintText: 'email@example.com',
                    prefixIcon: Icons.email,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: ValidationBuilder().email().build(),
                  ),
                  const SizedBox(height: 12),
                  FormDataInputField(
                    labelText: 'Phone',
                    hintText: 'Linked with Aadhar',
                    prefixIcon: Icons.phone,
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    validator:
                        ValidationBuilder().minLength(10).maxLength(10).build(),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date of Birth',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        onTap: () => selectDate(context),
                        readOnly: true,
                        controller: _dobController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.calendar_today),
                          hintText: 'dd-mm-yyyy',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppPallete.primary,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: validateDate,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                  const SizedBox(height: 14),
                  FormDataInputField(
                    labelText: 'Aadhar Number',
                    hintText: 'Enter Aadhar number',
                    prefixIcon: Icons.credit_card,
                    controller: _aadharController,
                    keyboardType: TextInputType.number,
                    validator:
                        ValidationBuilder().minLength(12).maxLength(12).build(),
                  ),
                  const SizedBox(height: 14),
                  FormDataInputField(
                    labelText: 'PAN Number',
                    hintText: 'Enter PAN number',
                    prefixIcon: Icons.credit_card,
                    capitalization: TextCapitalization.characters,
                    controller: _panController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'PAN number cannot be empty';
                      }
                      if (!panRegExp.hasMatch(value)) {
                        return 'Enter a valid PAN number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  FormDataInputField(
                    labelText: 'Address',
                    hintText: 'Enter full address',
                    prefixIcon: Icons.location_on,
                    controller: _addressController,
                    keyboardType: TextInputType.streetAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Address cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  FormDataInputField(
                    labelText: 'PIN Code',
                    hintText: 'Same as in Aadhar Card',
                    prefixIcon: Icons.location_on,
                    controller: _pinCodeController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'PIN code cannot be empty';
                      }
                      if (value.length != 6) {
                        return 'Enter a valid 6-digit PIN code';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  FormDataInputField(
                    labelText: 'Account Number',
                    hintText: 'Linked with PAN Card',
                    prefixIcon: Icons.account_balance,
                    controller: _bankAccountController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Account number cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  FormDataInputField(
                    labelText: 'Confirm Account',
                    hintText: 'Confirm account number',
                    prefixIcon: Icons.account_balance,
                    controller: _confirmBankAccountController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm account number cannot be empty';
                      }
                      if (value != _bankAccountController.text) {
                        return 'Confirm account number does not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  FormDataInputField(
                    labelText: 'IFSC Code',
                    hintText: '11 digit code',
                    prefixIcon: Icons.dialpad,
                    controller: _bankIFSCController,
                    capitalization: TextCapitalization.characters,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'IFSC code cannot be empty';
                      }
                      if (value.length != 11) {
                        return 'Enter a valid 11-digit IFSC code';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  Obx(
                    () {
                      return controller.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator.adaptive(),
                            )
                          : PrimaryButton(
                              text: 'Submit',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  controller.submitFormData(
                                    _firstNameController.text.trim(),
                                    _lastNameController.text.trim(),
                                    _emailController.text.trim(),
                                    _phoneController.text.trim(),
                                    _dobController.text.trim(),
                                    _aadharController.text.trim(),
                                    _pinCodeController.text.trim(),
                                    _addressController.text.trim(),
                                    _bankAccountController.text.trim(),
                                    _bankIFSCController.text.trim(),
                                    _panController.text.trim(),
                                  );
                                }
                              },
                            );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
