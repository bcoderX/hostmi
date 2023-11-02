import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/ui/screens/add_new_property_screens/add_property_basic_details.dart';
import 'package:hostmi/ui/screens/add_new_property_screens/add_new_property_select_amenities_screen/add_new_property_select_amenities_screen.dart';
import 'package:hostmi/ui/screens/agency_screen/tabs/agency_manager_posts.dart';
import 'package:hostmi/ui/screens/agency_screen/tabs/agency_posts.dart';
import 'package:hostmi/ui/screens/agency_screen/tabs/contacts.dart';
import 'package:hostmi/ui/screens/agency_screen/tabs/manage_agency.dart';
import 'package:hostmi/ui/widgets/landloard_action_button.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AgencyManagerScreen extends StatefulWidget {
  const AgencyManagerScreen({Key? key, required this.agency}) : super(key: key);
  final AgencyModel agency;

  @override
  State<AgencyManagerScreen> createState() => _AgencyManagerScreenState();
}

class _AgencyManagerScreenState extends State<AgencyManagerScreen> {
  final SizedBox _spacer = const SizedBox(height: 10);
  int _selectedIndex = 0;
  @override
  void initState() {
    // agency = AgencyModel.fromMap(widget.agency[0]["agencies"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Size _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.grey,
        foregroundColor: AppColor.black,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
        title: Text(
          widget.agency.name!,
          style: const TextStyle(color: AppColor.black),
        ),
        actions: [
          InkWell(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.edit,
                  color: AppColor.primary,
                  size: 30,
                ),
                Text(
                  AppLocalizations.of(context)!.edit,
                  style: const TextStyle(color: AppColor.black, fontSize: 18.0),
                ),
                const SizedBox(
                  width: 5.0,
                )
              ],
            ),
            onTap: () {},
          )
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppColor.grey,
                          image: DecorationImage(
                            image: NetworkImage(
                              widget.agency.coverImageUrl!,
                            ),
                            fit: BoxFit.cover,
                          ),
                          border: const Border(
                            bottom: BorderSide(
                                width: 5.0, color: AppColor.listItemGrey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                    ],
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 125,
                        width: 125,
                        margin: const EdgeInsets.only(
                          right: 25,
                        ),
                        decoration: BoxDecoration(
                          image: null,
                          /* DecorationImage(
                            image:  NetworkImage(agency.profileImageUrl!),
                            fit: BoxFit.cover,
                          ), */
                          //borderRadius: BorderRadius.circular(100.0),
                          border: Border.all(color: AppColor.grey, width: 5.0),
                          color: AppColor.primary,
                        ),
                        child: const Icon(
                          Icons.house,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                width: double.maxFinite,
                height: 60,
                decoration: const BoxDecoration(
                    color: AppColor.grey,
                    border: Border.symmetric(
                        horizontal: BorderSide(color: AppColor.grey))),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ActionButton(
                        icon: Icon(
                          Icons.pages,
                          color: _selectedIndex == 0
                              ? AppColor.white
                              : Colors.grey[800],
                          size: 18.0,
                        ),
                        text: "Publication",
                        backgroundColor:
                            _selectedIndex == 0 ? AppColor.primary : null,
                        foregroundColor:
                            _selectedIndex == 0 ? AppColor.white : null,
                        onPressed: () {
                          setSelectedIndex(0);
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (BuildContext context) {
                          //   return const AddHouse1();
                          // }));
                        },
                      ),
                      ActionButton(
                        icon: Icon(
                          Icons.contact_page,
                          color: _selectedIndex == 1
                              ? AppColor.white
                              : Colors.grey[800],
                          size: 18.0,
                        ),
                        text: "Contacts",
                        backgroundColor:
                            _selectedIndex == 1 ? AppColor.primary : null,
                        foregroundColor:
                            _selectedIndex == 1 ? AppColor.white : null,
                        onPressed: () {
                          setSelectedIndex(1);
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (BuildContext context) {
                          //   return const AddHouse1();
                          // }));
                        },
                      ),
                      ActionButton(
                        icon: Icon(
                          Icons.settings,
                          color: _selectedIndex == 2
                              ? AppColor.white
                              : Colors.grey[800],
                          size: 18.0,
                        ),
                        text: AppLocalizations.of(context)!.manage,
                        backgroundColor:
                            _selectedIndex == 2 ? AppColor.primary : null,
                        foregroundColor:
                            _selectedIndex == 2 ? AppColor.white : null,
                        onPressed: () {
                          setSelectedIndex(2);
                        },
                      ),
                      ActionButton(
                        icon: Icon(
                          Icons.add_circle,
                          color: Colors.grey[800],
                          size: 18.0,
                        ),
                        text: "Ajouter une propriété",
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            //return const AddHouse1();
                            return const AddNewPropertyBasicDetails();
                          }));
                        },
                      ),
                      ActionButton(
                        icon: Icon(
                          Icons.share,
                          color: Colors.grey[800],
                          size: 18.0,
                        ),
                        text: AppLocalizations.of(context)!.share,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return const AddNewPropertySelectAmenitiesScreen();
                          }));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              _selectedIndex == 0
                  ? const AgencyManagerPosts()
                  : _selectedIndex == 1
                      ? AgencyContacts(agency: widget.agency)
                      : const ManageAgency(),
            ],
          ),
        ),
      ),
    );
  }

  void setSelectedIndex(int i) => setState(() {
        _selectedIndex = i;
      });
}
