import 'package:hostmi/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class RoundedButton extends StatefulWidget {
  const RoundedButton({
    Key? key,
    this.onTap,
    this.fontSize,
    this.text,
    this.textColor,
    this.buttonColor
  }) : super(key: key);
  final double? fontSize;
  final String? text;
  final Color? textColor;
  final Color? buttonColor;
  final void Function()? onTap;
  @override
  State<RoundedButton> createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      borderOnForeground: true,
      color: widget.buttonColor,
      child: MaterialButton(
        onPressed: widget.onTap,
        child:  Text(
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
