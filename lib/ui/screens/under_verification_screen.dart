import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UnderVerificationPage extends StatefulWidget {
  const UnderVerificationPage({Key? key, required this.page}) : super(key: key);
  final Widget page;
  @override
  State<UnderVerificationPage> createState() => _UnderVerificationPageState();
}

class _UnderVerificationPageState extends State<UnderVerificationPage> {
/*
  @override
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
        body: SafeArea(
      child: Column(
        children: [
           Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 30.0),
            child: Text(
              AppLocalizations.of(context)!.relaxMessage,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          const Expanded(
              child:
                  Center(child: RiveAnimation.asset("assets/rive/relax.riv"),),),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, right: 8.0, left: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                )),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return widget.page;
                      },
                    ),
                  );
                },
                child:  Text(AppLocalizations.of(context)!.next),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
