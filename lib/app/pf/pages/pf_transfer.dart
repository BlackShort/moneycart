import 'package:moneycart/app/common/widgets/form_field.dart';
import 'package:moneycart/app/common/widgets/loading_button.dart';
import 'package:moneycart/app/pf/controllers/pf_controller.dart';
import 'package:moneycart/app/pf/pages/pf_otp.dart';
import 'package:moneycart/config/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class PfTransferForm extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const PfTransferForm(),
      );
  const PfTransferForm({super.key});

  @override
  State<PfTransferForm> createState() => _PfTransferFormState();
}

class _PfTransferFormState extends State<PfTransferForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final panRegExp = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
  DateTime? selectedDate;
  final TextEditingController _currentUanController = TextEditingController();
  final TextEditingController _previousUanController = TextEditingController();
  final TextEditingController _exitdateController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _confirmBankAccountController =
      TextEditingController();
  final TextEditingController _bankIFSCController = TextEditingController();

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
    setState(() {
      selectedDate = pickedDate;
      _exitdateController.text = DateFormat('dd-MM-yyyy').format(pickedDate!);
    });
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
    _currentUanController.dispose();
    _previousUanController.dispose();
    _exitdateController.dispose();
    _aadharController.dispose();
    _pinCodeController.dispose();
    _addressController.dispose();
    _bankAccountController.dispose();
    _confirmBankAccountController.dispose();
    _bankIFSCController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PfController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PF Transfer',
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
                  _buildFormHeader(),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Employee Identification'),
                  _buildSectionContainer([
                    FormDataInputField(
                      labelText: 'Current UAN',
                      hintText: 'Enter UAN Number',
                      prefixIcon: Icons.person,
                      controller: _currentUanController,
                      keyboardType: TextInputType.name,
                      validator: ValidationBuilder()
                          .minLength(3)
                          .maxLength(20)
                          .build(),
                    ),
                    const SizedBox(height: 12),
                    FormDataInputField(
                      labelText: 'Previous UAN',
                      hintText: 'Enter UAN Number',
                      prefixIcon: Icons.person,
                      controller: _previousUanController,
                      keyboardType: TextInputType.name,
                      validator: ValidationBuilder()
                          .minLength(3)
                          .maxLength(20)
                          .build(),
                    ),
                  ]),
                  const SizedBox(height: 14),
                  _buildSectionTitle('Employment Details'),
                  _buildSectionContainer([
                    _buildDateField(context, 'Exit Date (Previous Company)'),
                  ]),
                  _buildSectionTitle('Identification Details'),
                  _buildSectionContainer([
                    FormDataInputField(
                      labelText: 'Aadhar Number',
                      hintText: 'Enter Aadhar number',
                      prefixIcon: Icons.credit_card,
                      controller: _aadharController,
                      keyboardType: TextInputType.number,
                      validator: ValidationBuilder()
                          .minLength(12)
                          .maxLength(12)
                          .build(),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _buildSectionTitle('Address Details'),
                  _buildSectionContainer([
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
                  ]),
                  const SizedBox(height: 12),
                  _buildSectionTitle('Bank Details'),
                  _buildSectionContainer([
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
                          return 'Account numbers do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    FormDataInputField(
                      labelText: 'IFSC Code',
                      hintText: 'Enter IFSC code',
                      prefixIcon: Icons.account_balance,
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
                  ]),
                  const SizedBox(height: 40),
                  Obx(
                    () => LoadingButton(
                      isLoading: controller.isLoading.value,
                      text: 'Submit',
                      onPressed: () {
                        Get.off(() => const PfOtp(
                              enableOtp: true,
                            ));
                        // if (_formKey.currentState!.validate()) {
                        //   controller.submitFormData(
                        //     _currentUanController.text.trim(),
                        //     _previousUanController.text.trim(),
                        //     _exitdateController.text.trim(),
                        //     _aadharController.text.trim(),
                        //     _pinCodeController.text.trim(),
                        //     _addressController.text.trim(),
                        //     _bankAccountController.text.trim(),
                        //     _bankIFSCController.text.trim(),
                        //   );
                        // }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormHeader() {
    return Card(
      color: Colors.grey[200]!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.description,
              size: 90,
              color: AppPallete.primary,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Registration Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Please provide accurate information for PF Transfer.',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _buildSectionContainer(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildDateField(BuildContext context, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          onTap: () => selectDate(context),
          readOnly: true,
          controller: _exitdateController,
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
    );
  }
}
