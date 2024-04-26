import 'package:flutter/widgets.dart';
import 'package:hostmi/utils/app_color.dart';

class DetailsRow extends StatelessWidget {
  const DetailsRow(
      {super.key,
      required this.icon,
      required this.label,
      required this.value});
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColor.primary,
        ),
        Expanded(
          child: Text(
            "$label : $value",
            style: const TextStyle(
              color: AppColor.black,
            ),
          ),
        ),
      ],
    );
  }
}
