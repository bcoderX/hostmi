import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({Key? key, required this.continueToPage}) : super(key: key);
  final Widget continueToPage;
  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  /* @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
        return widget.page;
      }));
    });
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const Expanded(
          child: Center(
            child: SizedBox(
              width: 250,
              child: RiveAnimation.asset("assets/rive/success.riv"),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0, right: 8.0, left: 8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10.0,)),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                  return widget.continueToPage;
                },),);
              },
              child:  Text(AppLocalizations.of(context)!.next),
            ),
          ),
        ),
      ],
    ));
  }
}
