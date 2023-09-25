import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class GearsLoadingPage extends StatefulWidget {
  const GearsLoadingPage({Key? key, required this.page, required this.operationTitle}) : super(key: key);
  final Widget page;
  final String operationTitle;
  @override
  State<GearsLoadingPage> createState() => _GearsLoadingPageState();
}

class _GearsLoadingPageState extends State<GearsLoadingPage> {

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context){
        return widget.page;
      }));
    });
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(body: Column(
      children: [
        Expanded(child: Center(child: SizedBox( width: 200, child: RiveAnimation.asset("assets/rive/animgears.riv")))),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Text(widget.operationTitle),
        ),
      ],
    ));
  }
}
