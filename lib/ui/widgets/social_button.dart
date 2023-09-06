import 'package:hostmi/utils/app_color.dart';
import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({Key? key, required this.socialItem, required this.onTap})
      : super(key: key);
  final Widget socialItem;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: 50.0,
          width: 60.0,
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.iconBorderGrey),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: socialItem),
    );
  }
}
