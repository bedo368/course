import 'package:flutter/material.dart';

class CustomTextField1 extends StatelessWidget {
  const CustomTextField1({
    required this.controller,
    required this.hintText,
    this.hintStyle,
    this.validator,
    this.readOnly = false,
    this.filled = false,
    this.fillColor,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.overriderValidator = false,
    super.key,
  }) : super();

  final String? Function(String?)? validator;
  final TextEditingController controller;
  final String hintText;
  final bool filled;
  final bool readOnly;
  final Color? fillColor;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final bool overriderValidator;
  final TextStyle? hintStyle;

  @override
  TextFormField build(BuildContext context) {
    return TextFormField(
      onTapOutside: (_) {
        FocusScope.of(context).unfocus();
      },
      controller: controller,
      validator: overriderValidator
          ? validator
          : (v) {
              if (v == null) return 'this field is required';
              return null;
            },
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(90),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(90),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(90),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        filled: filled,
        fillColor: fillColor,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: hintStyle ??
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }
}
