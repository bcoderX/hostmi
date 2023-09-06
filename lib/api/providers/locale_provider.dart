import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LocaleProvider with ChangeNotifier{
  final Map<String, String> _supportedLocales = {
    "en": "English",
    "fr": "Français"
  };
  Locale? _locale = Locale(Intl.systemLocale);

  Map<String, String>  get supportedLocales => _supportedLocales;
  Locale? get locale => _locale;

  void set(Locale? locale){
    _locale = locale;
    notifyListeners();
  }
}