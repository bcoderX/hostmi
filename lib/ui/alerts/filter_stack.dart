import 'package:flutter/material.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/theme/app_style.dart';
import 'package:hostmi/utils/app_color.dart';

class FilterStack extends StatelessWidget {
  const FilterStack({
    super.key,
    required this.title,
    required this.child,
    required this.onCancel,
    required,
    this.onValidate,
    required this.screen,
  });
  final String title;
  final Widget child;
  final void Function()? onCancel;
  final void Function()? onValidate;
  final Size screen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCancel,
      child: Container(
        padding: getPadding(left: 25, right: 25, top: 150),
        height: screen.height,
        width: double.infinity,
        color: AppColor.black.withOpacity(.2),
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {},
            child: Card(
              elevation: 3.0,
              child: Container(
                padding: getPadding(all: 10),
                margin: getMargin(all: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppStyle.txtManropeBold18,
                    ),
                    const SizedBox(height: 20),
                    child,
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: AppColor.black,
                          ),
                          onPressed: onCancel,
                          child: const Text("Annuler"),
                        )),
                        const SizedBox(width: 15),
                        Expanded(
                            child: ElevatedButton(
                          onPressed: onValidate,
                          child: const Text("Valider"),
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
