import 'dart:io';

Future<bool> checkInternetStatus() async {
  bool isOnline = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      isOnline = true;
    }
  } on SocketException catch (_) {
    isOnline = false;
  }
  return isOnline;
}
