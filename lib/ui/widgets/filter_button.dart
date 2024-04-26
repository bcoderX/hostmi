import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterButton extends StatefulWidget {
  const FilterButton({
    Key? key,
    this.onTap,
  }) : super(key: key);

  final void Function()? onTap;
  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5.0, bottom: 5.0),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: getPadding(all: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.filter_list_sharp,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                AppLocalizations.of(context)!.sort,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
