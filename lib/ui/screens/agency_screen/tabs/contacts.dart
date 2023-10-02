import 'package:flutter/material.dart';
import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/ui/screens/agency_screen/widgets/details_row.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AgencyContacts extends StatelessWidget {
  const AgencyContacts({super.key, required this.agency});
  final AgencyModel agency;
  final SizedBox _spacer = const SizedBox(
    height: 25,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 7.0,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 10.0),
            child: Text(
              AppLocalizations.of(context)!.details,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: AppColor.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _spacer,
                DetailsRow(
                    icon: Icons.person,
                    label: AppLocalizations.of(context)!.name,
                    value: agency.name!),
                _spacer,
                DetailsRow(
                    icon: Icons.phone,
                    label: AppLocalizations.of(context)!.phone,
                    value: agency.phoneNumber!),
                _spacer,
                DetailsRow(
                    icon: Icons.mail, label: "Email", value: agency.email!),
                _spacer,
                DetailsRow(
                    icon: Icons.location_pin,
                    label: "Address",
                    value: agency.address!),
                _spacer,
              ],
            ),
          )
        ],
      ),
    );
  }
}
