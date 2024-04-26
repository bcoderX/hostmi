import 'package:flutter/material.dart';
import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/theme/app_style.dart';
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
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0, top: 10.0, bottom: 13),
            child: Text(
              "A propos",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: AppColor.black,
              ),
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey[300],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                      padding: getPadding(left: 8, top: 31),
                      child: Text("Description",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtManropeBold18.copyWith(
                              letterSpacing: getHorizontalSize(0.2)))),
                ),
                Container(
                    width: getHorizontalSize(327),
                    margin: getMargin(left: 8, top: 13, right: 39, bottom: 13),
                    child: Text("${agency.description}",
                        maxLines: null,
                        textAlign: TextAlign.justify,
                        style: AppStyle.txtManropeRegular14Gray900)),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.grey[300],
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                      padding: getPadding(left: 8, top: 13),
                      child: Text("Contacts",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtManropeBold18.copyWith(
                            letterSpacing: getHorizontalSize(0.2),
                          ))),
                ),
                const SizedBox(
                  height: 10,
                ),
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
                agency.whatsapp == null
                    ? const SizedBox()
                    : DetailsRow(
                        icon: Icons.phone,
                        label: "Whatsapp",
                        value: agency.whatsapp!),
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
