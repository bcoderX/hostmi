import 'package:flutter/material.dart';
import 'package:hostmi/ui/widgets/labeled_field.dart';
import 'package:hostmi/ui/widgets/square_field.dart';
import 'package:hostmi/utils/app_color.dart';

class RangeField extends StatefulWidget {
  const RangeField({Key? key, required this.title, required this.rangeValues}) : super(key: key);
  final String title;
  final RangeValues rangeValues;

  @override
  State<RangeField> createState() => _RangeFieldState();
}

class _RangeFieldState extends State<RangeField> {
  late RangeValues _rangeValues;
  @override
  void initState() {
    _rangeValues = widget.rangeValues;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold,),),
        RangeSlider(
            values: _rangeValues,
            min: widget.rangeValues.start,
            max: widget.rangeValues.end,
            divisions: 100,
            activeColor: AppColor.primary,
            labels: RangeLabels("${_rangeValues.start.round()}","${_rangeValues.end.round()}"),
            onChanged: (RangeValues values){
              setState(() {
                _rangeValues = values;
              });
            }),
        Row(
          children: const [
            Expanded(child: SquareTextField(errorText: "", placeholder: "min", isFullyBordered: true,)),
            SizedBox(width: 10,),
            Expanded(child: SquareTextField(errorText: "", placeholder: "max",isFullyBordered: true,)),
          ],
        )
      ],
    );
  }
}
