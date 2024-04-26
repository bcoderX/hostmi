import 'package:flutter/material.dart';

class LabeledDropdownField extends StatelessWidget {
  const LabeledDropdownField({
    Key? key,
    this.label,
    this.value,
    this.errorText,
    this.items,
    this.onChanged,
    this.onTap,
  }) : super(key: key);
  final String? label;
  final String? errorText;
  final String? value;
  final List<DropdownMenuItem<String>>? items;
  final void Function(String?)? onChanged;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15.0,
        ),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: value,
          decoration: InputDecoration(
              border: const OutlineInputBorder(), errorText: errorText),
          items: items,
          onTap: onTap,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
