import 'package:flutter/material.dart';
import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/api/models/country_model.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/providers/locale_provider.dart';
import 'package:hostmi/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'api/constants/roles.dart';

void main() async {
  Supabase client = await Supabase.initialize(
    url: 'https://rwwurjrdtxmszqpwpocx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ3d3VyanJkdHhtc3pxcHdwb2N4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM5MjI3MTUsImV4cCI6MjAwOTQ5ODcxNX0.UebMujaHkwjvN30VEmt_2nBDm2DLW4OdWJb02Hf64OY',
  );

  await initHiveForFlutter();
  Hive.registerAdapter(RoleAdapter());
  Hive.registerAdapter(CountryAdapter());
  Hive.registerAdapter(AgencyModelAdapter());
  await Hive.openBox("hostmiLocalDatabase");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HostmiProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const HostMi(),
    ),
  );
}

class HostMi extends StatelessWidget {
  static const Map<int, Color> color = {
    50: Color.fromRGBO(255, 110, 64, 0.1),
    100: Color.fromRGBO(255, 110, 64, 0.2),
    200: Color.fromRGBO(255, 110, 64, 0.3),
    300: Color.fromRGBO(255, 110, 64, 0.4),
    400: Color.fromRGBO(255, 110, 64, 0.5),
    500: Color.fromRGBO(255, 110, 64, 0.6),
    600: Color.fromRGBO(255, 110, 64, 0.7),
    700: Color.fromRGBO(255, 110, 64, 0.8),
    800: Color.fromRGBO(255, 110, 64, 0.9),
    900: Color.fromRGBO(255, 110, 64, 1.0),
  };
  const HostMi({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: HostMiRouter.goRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: context.watch<LocaleProvider>().locale,
      title: 'Hostmi',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        splashColor: AppColor.primary,
        scaffoldBackgroundColor: AppColor.grey,
        primarySwatch: const MaterialColor(0xFFFF6E40, color),
        // primarySwatch: const MaterialColor(0xFF872E01, color),
        fontFamily: 'Manrope',
        primaryTextTheme: const TextTheme(
          titleLarge: TextStyle(
            color: AppColor.primary,
            fontSize: 30,
            fontFamily: 'Manrope',
          ),
        ),
        bottomAppBarTheme: const BottomAppBarTheme(color: AppColor.grey),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
