import 'package:flutter/material.dart';
import 'package:hostmi/api/models/house_category.dart';
import 'package:hostmi/api/models/house_features.dart';
import 'package:hostmi/api/models/house_type.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/ui/screens/add_new_property_screens/add_new_property_select_amenities_screen/widgets/options_item_widget.dart';

class OptionsListWidget<T> extends StatefulWidget {
  const OptionsListWidget(
      {super.key,
      required this.items,
      required this.selected,
      required this.onSelected,
      this.g});
  final List<dynamic> items;
  final List<int> selected;
  final void Function(T) onSelected;
  final T? g;

  @override
  State<OptionsListWidget> createState() => _OptionsListWidgetState();
}

class _OptionsListWidgetState extends State<OptionsListWidget> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: getVerticalSize(5),
      spacing: getHorizontalSize(5),
      children: widget.items
          .map((item) => OptionsItemWidget(
                amenity: item,
                selected: widget.selected,
                onPressed: () {
                  if (widget.g.runtimeType == HouseType) {
                    widget.onSelected(HouseType.fromMap(data: item));
                  } else if (widget.g.runtimeType == HouseFeatures) {
                    widget.onSelected(HouseFeatures.fromMap(data: item));
                  } else if (widget.g.runtimeType == HouseCategory) {
                    widget.onSelected(HouseCategory.fromMap(data: item));
                  }

                  setState(() {});
                },
              ))
          .toList(),
    );
  }
}
