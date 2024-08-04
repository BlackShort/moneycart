import 'package:flutter/material.dart';
import 'package:moneycart/config/theme/app_pallete.dart';

class FormDataInputField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final TextCapitalization capitalization;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const FormDataInputField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.capitalization = TextCapitalization.none,
    this.validator,
  });

  @override
  State<FormDataInputField> createState() => _FormDataInputFieldState();
}

class _FormDataInputFieldState extends State<FormDataInputField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_clearError);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_clearError);
    super.dispose();
  }

  void _clearError() {
    if (widget.controller.text.isNotEmpty) {
      setState(() {
        widget.validator?.call(widget.controller.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.capitalization,
          decoration: InputDecoration(
            prefixIcon: Icon(widget.prefixIcon),
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
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
          validator: widget.validator,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
