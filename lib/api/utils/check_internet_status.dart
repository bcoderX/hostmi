import 'dart:io';

Future<bool> checkInternetStatus() async {
  bool isOnline = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      if ("[InternetAddress('142.250.201.78', IPv4)]" == result.toString()) {
        return false;
      }
      // debugPrint(result.toString());
      isOnline = true;
    }
  } on SocketException catch (_) {
    isOnline = false;
  }
  return isOnline;
}
