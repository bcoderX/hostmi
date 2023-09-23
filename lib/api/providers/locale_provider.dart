import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LocaleProvider with ChangeNotifier{
  var hostmiBox = Hive.box("hostmiLocalDatabase");
  final Map<String, String> _supportedLocales = {
    "default": "System Language",
    "en": "English",
    "fr": "Français"
  };

  Map<String, String>  get supportedLocales => _supportedLocales;
  Locale? get locale => hostmiBox.get("locale") == null ? null : Locale(hostmiBox.get("locale"));
  void set(Locale? locale){
    hostmiBox.put("locale", locale?.languageCode);
    notifyListeners();
  }
}