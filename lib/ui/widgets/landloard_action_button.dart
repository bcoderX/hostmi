import 'package:flutter/material.dart';
import 'package:hostmi/utils/app_color.dart';

class LandlordActionButton extends StatelessWidget {
  const LandlordActionButton(
      {Key? key, required this.icon, required this.text, this.onPressed})
      : super(key: key);
  final Widget icon;
  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            primary: Colors.grey[300],
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              icon,
              Text(
                text,
                style: const TextStyle(color: AppColor.black),
              ),
            ],
          )),
    );
  }
}
