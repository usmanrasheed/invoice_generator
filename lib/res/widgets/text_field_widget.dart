import 'package:flutter/material.dart';
import 'package:invoice/res/colors/app_color.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final IconData? prefixIcon;
  final bool isOptional;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType keyboardType;
  final String? errorText;
  final Widget? suffixIcon;
  final Color? fillColor;

  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.isOptional = false,
    this.suffixIcon,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 10, right: 5),
          hintText: hintText,
          labelText: labelText,
          errorText: errorText,
          filled: fillColor != null,
          fillColor: fillColor,
          border: const OutlineInputBorder(),
          prefixIcon: prefixIcon != null
              ? Padding(
            padding: const EdgeInsets.only(left: 10, right: 5),
            child: Icon(prefixIcon, size: 20, color: AppColor.primaryDarkColor),
          )
              : null,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 30,
            minHeight: 30,
          ),
          suffixIcon: suffixIcon != null
              ? Padding(
            padding: const EdgeInsets.only(right: 10),
            child: suffixIcon,
          )
              : null,
        ),
      ),
    );
  }
}
