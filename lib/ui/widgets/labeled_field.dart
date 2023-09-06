import 'package:flutter/material.dart';
import 'package:hostmi/ui/widgets/square_field.dart';
import 'package:hostmi/utils/app_color.dart';

class LabeledField extends StatelessWidget {
  const LabeledField({
        Key? key,
        this.label,
        this.placeholder,
        this.controller,
        this.errorText,
        this.maxLines,
        this.isRequired = false
      })
      : super(key: key);

  final String? label;
  final String? placeholder;
  final String? errorText;
  final bool isRequired;
  final int? maxLines;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(text: TextSpan(
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColor.black),
          children: [
            TextSpan(text: label),
            isRequired == true ? TextSpan(text: " *", style: const TextStyle(color: Colors.red)) : TextSpan()
          ]
        )),
        const SizedBox(
          height: 15.0,
        ),
        SquareTextField(
          errorText: errorText,
          placeholder: placeholder,
          maxLines: maxLines,
          isFullyBordered: true,
          controller: controller,
        ),
      ],
    );
  }
}
