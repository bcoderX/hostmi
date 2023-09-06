import 'package:hostmi/ui/widgets/social_button.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/utils/app_text_size.dart';
import 'package:flutter/material.dart';

class SocialSignup extends StatelessWidget {
  const SocialSignup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "or sign in with",
          style: TextStyle(
            fontSize: AppTextSize.normal12,
            color: AppColor.primary,
          ),
        ),
        SocialButton(
          socialItem: const Center(
            child: Text(
              "G+",
              style: TextStyle(
                fontFamily: "Arial",
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: AppColor.primary,
              ),
            ),
          ),
          onTap: () {},
        ),
        SocialButton(
          socialItem: const Center(
            child: Text(
              "f",
              style: TextStyle(
                fontFamily: "Arial",
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: AppColor.primary,
              ),
            ),
          ),
          onTap: () {},
        ),
        SocialButton(
          socialItem: const Icon(
            Icons.apple,
            color: AppColor.primary,
            size: 30,
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
