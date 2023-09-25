import 'package:flutter/material.dart';
import 'package:hostmi/ui/screens/list_screen.dart';

class ListMain extends StatefulWidget {
  const ListMain({Key? key, required this.navigatorKey}) : super(key: key);
  final GlobalKey navigatorKey;

  @override
  State<ListMain> createState() => _ListMainState();
}

class _ListMainState extends State<ListMain> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) {
          return ListPage();
        });
      },
    );
  }
}
