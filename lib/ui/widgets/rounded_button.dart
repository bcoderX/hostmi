import 'package:hostmi/utils/app_color.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatefulWidget {
  const RoundedButton({
    Key? key,
    this.onTap,
    this.fontSize,
    this.text,
    this.textColor,
    this.buttonColor,
    this.borderColor,
  }) : super(key: key);
  final double? fontSize;
  final String? text;
  final Color? textColor;
  final Color? buttonColor;
  final Color? borderColor;
  final void Function()? onTap;
  @override
  State<RoundedButton> createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: widget.buttonColor ?? AppColor.white,
          border: Border.all(color: widget.borderColor ?? Colors.grey[200]!)),
      child: MaterialButton(
        onPressed: widget.onTap,
        child: Text(
          widget.text!,
          style: TextStyle(
            fontSize: widget.fontSize,
            color: widget.textColor,
          ),
        ),
      ),
    );
  }
}
