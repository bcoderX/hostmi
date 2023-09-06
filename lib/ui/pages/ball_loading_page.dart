import 'dart:async';

import 'package:flutter/material.dart';
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
    return const Scaffold(body: Center(child: SizedBox(
      width: 150,
        child: RiveAnimation.asset("assets/rive/loading.riv"))));
  }
}
