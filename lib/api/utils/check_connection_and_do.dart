import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostmi/api/utils/check_internet_status.dart';

Future<void> checkConnectionAndDo(void Function()? todo) async {
  bool isConnected = await checkInternetStatus();
  if (isConnected) {
    todo?.call();
  } else {
    Fluttertoast.showToast(
      msg: "Vérifiez votre connexion...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
