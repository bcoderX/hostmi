import 'package:flutter/material.dart';
import 'package:hostmi/ui/widgets/square_field.dart';
import 'package:hostmi/utils/app_color.dart';

class RangeField extends StatefulWidget {
  const RangeField({
    Key? key,
    this.title = "",
    required this.rangeValues,
    required this.minTextController,
    required this.maxTextController,
  }) : super(key: key);
  final String title;
  final RangeValues rangeValues;
  final TextEditingController minTextController;
  final TextEditingController maxTextController;

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
        widget.title.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(widget.title),
              )
            : const SizedBox(),
        RangeSlider(
            values: _rangeValues,
            min: widget.rangeValues.start,
            max: widget.rangeValues.end,
            divisions: 100,
            activeColor: AppColor.primary,
            labels: RangeLabels(
                "${_rangeValues.start.round()}", "${_rangeValues.end.round()}"),
            onChanged: (RangeValues values) {
              setState(() {
                _rangeValues = values;
              });
              widget.minTextController.text = values.start.round().toString();
              widget.maxTextController.text = values.end.round().toString();
            }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Expanded(
                  child: SquareTextField(
                errorText: "",
                placeholder: "min",
                isFullyBordered: true,
                controller: widget.minTextController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (double.parse(value) < _rangeValues.start) {
                    setState(() {
                      _rangeValues =
                          RangeValues(double.parse(value), _rangeValues.end);
                    });
                  }
                },
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.remove,
                  color: Colors.grey[300],
                ),
              ),
              Expanded(
                  child: SquareTextField(
                errorText: "",
                placeholder: "max",
                isFullyBordered: true,
                controller: widget.maxTextController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (double.parse(value) > _rangeValues.start) {
                    setState(() {
                      _rangeValues =
                          RangeValues(_rangeValues.start, double.parse(value));
                    });
                  }
                },
              )),
            ],
          ),
        )
      ],
    );
  }
}
