import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hostmi/api/firebase/analytics_client.dart';
import 'package:hostmi/api/firebase/fcm_client.dart';
import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/api/models/country_model.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/providers/locale_provider.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'api/constants/roles.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint("Handling a background ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Initializing supabase project
  await Supabase.initialize(
    url: 'https://rwwurjrdtxmszqpwpocx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ3d3VyanJkdHhtc3pxcHdwb2N4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM5MjI3MTUsImV4cCI6MjAwOTQ5ODcxNX0.UebMujaHkwjvN30VEmt_2nBDm2DLW4OdWJb02Hf64OY',
  );

//Initialized Firebase APP
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

//Register custom adapters for Hive store
  Hive.registerAdapter(RoleAdapter());
  Hive.registerAdapter(CountryAdapter());
  Hive.registerAdapter(AgencyModelAdapter());
  await Hive.openBox("hostmiLocalDatabase");

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: false,
    provisional: false,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    if (kDebugMode) {
      print('User granted permission');
    }
    try {
      String? token = await messaging.getToken();
     analytics.logEvent(name: 'app_opened');
      if (token != null) {
        try {
          if (supabase.auth.currentUser != null) {
            await supabase.rpc('update_fcm_key', params: {'key': token});
          }
        } catch (e) {
          if (kDebugMode) {
            print('print : $e');
          }
        }
      }
    } catch (e) {}
  } else {
    if (kDebugMode) {
      print('User declinedMultiProvider or has not accepted permission');
    }
  }

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

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class HostMi extends StatefulWidget {
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

  @override
  State<HostMi> createState() => _HostMiState();
}

class _HostMiState extends State<HostMi> {
  @override
  void initState() {
    // var initializationSettingsAndroid =
    //     const AndroidInitializationSettings('ic_launcher');
    var initialzationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      // AndroidNotification android = message.notification!.android!;
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            color: Colors.blue,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: "@mipmap/ic_launcher",
          ),
        ),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      // AndroidNotification android = message.notification!.android!;
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(notification.title.toString()),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(notification.body.toString())],
                ),
              ),
            );
          });
    });
    super.initState();
  }

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
        primarySwatch: const MaterialColor(0xFFFF6E40, HostMi.color),
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
