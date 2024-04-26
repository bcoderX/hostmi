import 'package:hostmi/utils/app_color.dart';
import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  const RoundedTextField({
    Key? key,
    this.prefixIcon,
    this.suffixIcon,
    this.label,
    required this.errorText,
    this.isEnabled = true,
    this.isReadOnly = false,
    this.showCursor = true,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.placeholder,
    this.onChanged,
    this.onTap,
    this.maxLines = 1,
  }) : super(key: key);

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? label;
  final String? placeholder;
  final String errorText;
  final int? maxLines;
  final bool isEnabled;
  final bool isReadOnly;
  final bool showCursor;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final void Function(String value)? onChanged;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey[200]!),
        color: AppColor.white,
      ),
      child: TextFormField(
        showCursor: showCursor,
        maxLines: maxLines,
        readOnly: isReadOnly,
        obscuringCharacter: ".",
        obscureText: isPassword,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          hintText: placeholder,
          hintStyle: const TextStyle(
            color: AppColor.placeholderGrey,
            fontFamily: "Arial",
          ),
          enabled: true,
          labelStyle: const TextStyle(
            color: AppColor.placeholderGrey,
            fontFamily: "Arial",
          ),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: AppColor.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: AppColor.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: AppColor.grey),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return errorText;
          } else {
            return null;
          }
        },
        onChanged: onChanged,
        onTap: onTap,
        keyboardType: keyboardType,
      ),
    );
  }
}
