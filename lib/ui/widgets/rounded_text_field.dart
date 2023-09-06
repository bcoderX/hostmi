import 'package:hostmi/utils/app_color.dart';
import 'package:flutter/material.dart';

class RoundedTextField extends StatefulWidget {
  const RoundedTextField({
    Key? key,
    this.prefixIcon,
    this.suffixIcon,
    this.label,
    required this.errorText,
    this.isEnabled = true,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.placeholder,
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? label;
  final String? placeholder;
  final String errorText;
  final bool isEnabled;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final void Function(String value)? onChanged;
  final void Function()? onTap;
  @override
  State<RoundedTextField> createState() => _RoundedTextFieldState();
}

class _RoundedTextFieldState extends State<RoundedTextField> {
  @override
  Widget build(BuildContext context) {
    return Material(
      shadowColor: AppColor.placeholderGrey,
      elevation: 2,
      borderRadius: BorderRadius.circular(15.0),
      child: TextFormField(
        obscuringCharacter: "*",
        obscureText: widget.isPassword,
        controller: widget.controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          labelText: widget.label,
          hintText: widget.placeholder,
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
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(color: AppColor.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: AppColor.grey),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return widget.errorText;
          } else {
            return null;
          }
        },
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        keyboardType: widget.keyboardType,
      ),
    );
  }
}
