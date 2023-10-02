import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostmi/api/supabase/agencies/managers/select_manager_agency.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/ui/screens/agency_screen/agency_screen.dart';
import 'package:hostmi/ui/screens/ball_loading_page.dart';
import 'package:hostmi/ui/screens/create_agency_screen/no_agency.dart';
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
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: selectAgency(supabase.auth.currentUser!.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const BallLoadingPage();
          } else if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              final List<Map<String, dynamic>> data = snapshot.data ?? [];
              return LandlordPage(
                agency: data,
              );
            }
          }
          return const NoAgency();
        });
  }
}
