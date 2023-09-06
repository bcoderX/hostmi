import 'package:flutter/material.dart';
import 'package:hostmi/ui/pages/menu_welcome.dart';
import 'package:hostmi/ui/pages/settings_screen/settings_screen.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key }) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return SettingsScreen();
  }
}
