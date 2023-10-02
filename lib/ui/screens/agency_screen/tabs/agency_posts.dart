import 'package:flutter/material.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/ui/widgets/house_card.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AgencyPosts extends StatelessWidget {
  const AgencyPosts({super.key});
  final SizedBox _spacer = const SizedBox(
    height: 25,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.grey,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.publishedProperties,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: AppColor.black,
            ),
          ),
          _spacer,
          HouseCard(
            house: HouseModel(),
          ),
          _spacer,
          HouseCard(
            house: HouseModel(),
          ),
        ],
      ),
    );
  }
}
