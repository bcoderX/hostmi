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
        this.isRequired = false,
        this.isFullyBordered = true,
    this.keyboardType = TextInputType.text,
      })
      : super(key: key);

  final String? label;
  final String? placeholder;
  final String? errorText;
  final bool isRequired;
  final bool isFullyBordered;
  final int? maxLines;
  final TextInputType keyboardType;
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
            isRequired == true ? const TextSpan(text: " *", style: TextStyle(color: Colors.red)) : const TextSpan()
          ]
        )),
        const SizedBox(
          height: 15.0,
        ),
        SquareTextField(
          errorText: errorText,
          keyboardType: keyboardType,
          isRequired: isRequired,
          placeholder: placeholder,
          maxLines: maxLines,
          isFullyBordered: isFullyBordered,
          controller: controller,
        ),
      ],
    );
  }
}
