import 'package:hostmi/utils/app_color.dart';
import 'package:flutter/material.dart';

class SquareTextField extends StatefulWidget {
  const SquareTextField({
    Key? key,
    this.prefixIcon,
    this.suffixIcon,
    this.label,
    required this.errorText,
    this.maxLines,
    this.isRequired = true,
    this.isEnabled = true,
    this.isPassword = false,
    this.isFullyBordered = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.placeholder,
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  final bool isRequired;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? label;
  final String? placeholder;
  final String? errorText;
  final bool isEnabled;
  final bool isPassword;
  final bool isFullyBordered;
  final int? maxLines;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final void Function(String value)? onChanged;
  final void Function()? onTap;
  @override
  State<SquareTextField> createState() => _SquareTextFieldState();
}

class _SquareTextFieldState extends State<SquareTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscuringCharacter: "*",
      maxLines: widget.maxLines ?? 1,
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
        ),
        enabled: true,
        labelStyle: const TextStyle(
          color: AppColor.placeholderGrey,
        ),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: AppColor.grey,
        enabledBorder: widget.isFullyBordered
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: AppColor.listItemGrey),
              )
            : UnderlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: AppColor.listItemGrey),
              ),
        focusedBorder: widget.isFullyBordered
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: AppColor.primary),
              )
            : UnderlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: AppColor.primary),
              ),
      ),
      validator: !widget.isRequired
          ? null
          : (value) {
              if (value!.isEmpty) {
                return widget.errorText;
              } else {
                return null;
              }
            },
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      keyboardType: widget.keyboardType,
    );
  }
}
