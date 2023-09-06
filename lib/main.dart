import 'package:flutter/material.dart';
import 'package:hostmi/api/providers/auth_provider.dart';
import 'package:hostmi/api/providers/locale_provider.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/ui/pages/choice_page/choice_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  //Initializing hive store
  await initHiveForFlutter();

  final _httpLink = HttpLink(
    'http://127.0.0.1:8000/api/',
  );

  final _authLink = AuthLink(getToken: () => 'JWT dggfgg');
  Link _link = _authLink.concat(_httpLink);

  final ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: _link,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

  runApp(
      MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const HostMi()));
}

class HostMi extends StatelessWidget {
  static const Map<int, Color> color = {
    50: Color.fromRGBO(135, 46, 1, 0.1),
    100: Color.fromRGBO(135, 46, 1, 0.2),
    200: Color.fromRGBO(135, 46, 1, 0.3),
    300: Color.fromRGBO(135, 46, 1, 0.4),
    400: Color.fromRGBO(135, 46, 1, 0.5),
    500: Color.fromRGBO(135, 46, 1, 0.6),
    600: Color.fromRGBO(135, 46, 1, 0.7),
    700: Color.fromRGBO(135, 46, 1, 0.8),
    800: Color.fromRGBO(135, 46, 1, 0.9),
    900: Color.fromRGBO(135, 46, 1, 1.0),
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
        primarySwatch: const MaterialColor(0xFF872E01, color),
        fontFamily: 'Roboto',
        primaryTextTheme: const TextTheme(
          titleLarge: TextStyle(
            color: AppColor.primary,
            fontSize: 30,
            fontFamily: 'Roboto',
          ),
        ),
        bottomAppBarTheme: BottomAppBarTheme(color: AppColor.grey),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

/* class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
 */
