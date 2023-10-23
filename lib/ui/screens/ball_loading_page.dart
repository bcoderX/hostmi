// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rive/rive.dart';

class BallLoadingPage extends StatefulWidget {
  const BallLoadingPage({Key? key}) : super(key: key);
  @override
  State<BallLoadingPage> createState() => _BallLoadingPageState();
}

class _BallLoadingPageState extends State<BallLoadingPage> {
  // @override
  // void initState() {
  //   Timer(const Duration(seconds: 3), () {
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
  //       return widget.page;
  //     }));
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SizedBox(
      width: 25,
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: AppColor.primary,
        size: 25,
      ), /* RiveAnimation.asset("assets/rive/loading.riv") */
    )));
  }
}
