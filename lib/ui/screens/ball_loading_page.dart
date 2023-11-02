// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rive/rive.dart';

class BallLoadingPage extends StatelessWidget {
  const BallLoadingPage({Key? key, this.loadingTitle}) : super(key: key);
  final String? loadingTitle;
  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LoadingAnimationWidget.staggeredDotsWave(
          color: AppColor.primary,
          size: 25,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(loadingTitle ?? "")
      ],
    )));
  }
}
