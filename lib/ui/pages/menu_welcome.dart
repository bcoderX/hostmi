import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:settings_ui/settings_ui.dart';

class MenuWelcomePage extends StatefulWidget {
  const MenuWelcomePage({Key? key}) : super(key: key);

  @override
  State<MenuWelcomePage> createState() => _MenuWelcomePageState();
}

class _MenuWelcomePageState extends State<MenuWelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
        backgroundColor: AppColor.grey,
        foregroundColor: AppColor.black,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: SettingsList(
          lightTheme:
              const SettingsThemeData(dividerColor: AppColor.iconBorderGrey),
          sections: [
            SettingsSection(
              title: const Text(
                "Communs",
                style: TextStyle(
                  color: AppColor.primary,
                ),
              ),
              tiles: [
                SettingsTile(
                  title: const Text('Langue'),
                  description: const Text('Anglais'),
                  leading: const Icon(Icons.language),
                ),
                SettingsTile(
                  title: const Text('Thème'),
                  description: const Text('Clair'),
                  leading: const Icon(Icons.invert_colors),
                ),
              ],
            ),
            SettingsSection(
              title: const Text(
                "Compte",
                style: TextStyle(
                  color: AppColor.primary,
                ),
              ),
              tiles: [
                SettingsTile(
                  title: const Text('Numéro de téléphone'),
                  leading: const Icon(Icons.phone),
                ),
                SettingsTile(
                  title: const Text('Email'),
                  leading: const Icon(Icons.email),
                ),
                SettingsTile(
                  title: const Text('Se déconnecter'),
                  leading: const Icon(Icons.exit_to_app),
                ),
              ],
            ),
            SettingsSection(
              title: const Text(
                "Sécurité",
                style: TextStyle(
                  color: AppColor.primary,
                ),
              ),
              tiles: [
                SettingsTile(
                  title: const Text('Mot de passe'),
                  leading: const Icon(Icons.lock),
                ),
                SettingsTile.switchTile(
                  title: const Text('Activer les notification'),
                  leading: const Icon(Icons.notifications_active),
                  initialValue: false,
                  onToggle: (value) {},
                ),
              ],
            ),
            SettingsSection(
              title: const Text(
                "Autres",
                style: TextStyle(
                  color: AppColor.primary,
                ),
              ),
              tiles: [
                SettingsTile(
                  title: const Text("Conditions d'utilisations"),
                  leading: const Icon(Icons.description),
                ),
              ],
            )
          ]),
    );
  }
}
