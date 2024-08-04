import 'package:flutter/material.dart';
import 'package:moneycart/config/theme/app_pallete.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final double? fontSize;
  final double? letterSpacing;
  final bool? enabled;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.fontSize,
    this.letterSpacing = 1,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  Color _labelColor = AppPallete.secondary;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      _labelColor =
          _focusNode.hasFocus ? AppPallete.primary : AppPallete.secondary;
    });
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      focusNode: _focusNode,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(color: _labelColor),
        border: const OutlineInputBorder(),
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: widget.suffixIcon != null
            ? IconButton(
                icon: Icon(_obscureText
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded),
                onPressed: _toggleObscureText,
              )
            : null,
      ),
      keyboardType: widget.keyboardType,
      enabled: widget.enabled,
      style: TextStyle(
        fontSize: widget.fontSize,
        letterSpacing: widget.letterSpacing,
      ),
      textCapitalization: widget.textCapitalization,
      validator: widget.validator, // Apply validation
    );
  }
}
