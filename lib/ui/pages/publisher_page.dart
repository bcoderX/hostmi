import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostmi/ui/pages/no_page.dart';
import 'package:hostmi/utils/app_color.dart';

class PublisherPage extends StatefulWidget {
  const PublisherPage({Key? key}) : super(key: key);

  @override
  State<PublisherPage> createState() => _PublisherPageState();
}

class _PublisherPageState extends State<PublisherPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColor.grey,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.grey,
      ),
    );
    return  const NoPage();

  }
}
