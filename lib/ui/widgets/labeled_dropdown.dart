import 'package:flutter/material.dart';
import 'package:hostmi/ui/widgets/square_field.dart';

class LabeledDropdownField extends StatelessWidget {
   LabeledDropdownField(
      {Key? key,
        this.label,
        this.value,
        this.errorText,
        this.items,
        this.onChanged,
      })
      : super(key: key);
  final String? label;
  final String? errorText;
  final String? value;
  final List<DropdownMenuItem<String>>? items;
  void Function(String?)? onChanged;


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
            value: value,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
              errorText: errorText
            ),
            items: items, onChanged: onChanged,),
      ],
    );
  }
}
