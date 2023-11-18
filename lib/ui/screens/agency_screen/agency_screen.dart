import 'package:flutter/material.dart';
import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/api/supabase/agencies/select_agencies_by_id.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/ui/screens/agency_screen/tabs/agency_posts.dart';
import 'package:hostmi/ui/screens/agency_screen/tabs/agency_reviews.dart';
import 'package:hostmi/ui/screens/agency_screen/tabs/contacts.dart';
import 'package:hostmi/ui/screens/ball_loading_page.dart';
import 'package:hostmi/ui/widgets/landloard_action_button.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/routes.dart';

class AgencyScreen extends StatefulWidget {
  const AgencyScreen({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<AgencyScreen> createState() => _AgencyScreenState();
}

class _AgencyScreenState extends State<AgencyScreen> {
  int _selectedIndex = 0;
  late Future<List<Map<String, dynamic>>> _future;
  AgencyModel? loadedHouse;
  @override
  void initState() {
    _future = selectAgencyByID(widget.id);
    // agency = AgencyModel.fromMap(widget.agency[0]["agencies"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    if (supabase.auth.currentUser == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                      "Vous devez vous connecter pour voir les détails de l'agence."),
                  TextButton(
                    child: const Text("Cliquer ici pour se connecter"),
                    onPressed: () {
                      context.go(keyLoginRoute);
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      backgroundColor: Colors.grey[200],
                    ),
                    child: const Text(
                      "Retour",
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          }
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          
          if (!snapshot.hasData) {
            return const BallLoadingPage(
              loadingTitle: "Nous chargons les détails de l'agence...",
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              var agency = AgencyModel.fromMap(snapshot.data![0]);
              // print(agency.profileImageUrl);
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: AppColor.grey,
                  foregroundColor: AppColor.black,
                  elevation: 0.0,
                  // systemOverlayStyle: const SystemUiOverlayStyle(
                  //   statusBarBrightness: Brightness.light,
                  // ),
                  title: Text(
                    agency.name!,
                    style: const TextStyle(color: AppColor.black),
                  ),
                  actions: [
                    TextButton.icon(
                        onPressed: () async {
                          final canOpenUrl = await canLaunchUrl(
                              Uri.parse("tel:${agency.phoneNumber!}"));
                          print(agency.phoneNumber!);
                          if (canOpenUrl) {
                            await launchUrl(
                                Uri.parse("tel:${agency.phoneNumber!}"));
                          }
                        },
                        icon: const Icon(
                          Icons.call,
                          color: AppColor.primary,
                          size: 20,
                        ),
                        label: const Text("Appelez"))
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
                                    color: AppColor.bottomBarGrey,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        agency.coverImageUrl == null
                                            ? "https://rwwurjrdtxmszqpwpocx.supabase.co/storage/v1/object/public/agencies/default_images/cover_placeholder.png"
                                            : supabase.storage
                                                .from("agencies")
                                                .getPublicUrl(
                                                    agency.coverImageUrl!),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    border: const Border(
                                      bottom: BorderSide(
                                          width: 5.0,
                                          color: AppColor.listItemGrey),
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
                                    margin: const EdgeInsets.only(right: 25),
                                    decoration: BoxDecoration(
                                      image: agency.profileImageUrl == null
                                          ? null
                                          : DecorationImage(
                                              image: NetworkImage(supabase
                                                  .storage
                                                  .from("agencies")
                                                  .getPublicUrl(
                                                      agency.profileImageUrl!)),
                                              fit: BoxFit.cover,
                                            ),
                                      border: Border.all(
                                          color: AppColor.grey, width: 5.0),
                                      color: AppColor.primary,
                                    ),
                                    child: agency.profileImageUrl == null
                                        ? const Icon(
                                            Icons.house,
                                            color: Colors.white,
                                            size: 50,
                                          )
                                        : null),
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
                                  horizontal:
                                      BorderSide(color: AppColor.grey))),
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
                                  backgroundColor: _selectedIndex == 0
                                      ? AppColor.primary
                                      : null,
                                  foregroundColor: _selectedIndex == 0
                                      ? AppColor.white
                                      : null,
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
                                  text: "Apropos",
                                  backgroundColor: _selectedIndex == 1
                                      ? AppColor.primary
                                      : null,
                                  foregroundColor: _selectedIndex == 1
                                      ? AppColor.white
                                      : null,
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
                                    Icons.star,
                                    color: _selectedIndex == 2
                                        ? AppColor.white
                                        : Colors.grey[800],
                                    size: 18.0,
                                  ),
                                  text: "Note et avis",
                                  backgroundColor: _selectedIndex == 2
                                      ? AppColor.primary
                                      : null,
                                  foregroundColor: _selectedIndex == 2
                                      ? AppColor.white
                                      : null,
                                  onPressed: () {
                                    setSelectedIndex(2);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        _selectedIndex == 0
                            ? AgencyPosts(
                                agencyId: widget.id,
                              )
                            : _selectedIndex == 1
                                ? AgencyContacts(agency: agency)
                                : AgencyReviews(
                                    agencyId: widget.id,
                                  ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
          return SizedBox(
            height: screenSize.height,
            width: screenSize.width,
            child: Center(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: getHorizontalSize(25)),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Erreur de chargement",
                          style: TextStyle(
                              fontSize: getFontSize(18),
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                            "Nous n'arrivons pas à trouver l'agence selectionnée. Vérifiez votre connexion internet et réessayez."),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _future = selectAgencyByID(widget.id);
                            },
                            child: const Text("Réessayer"))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void setSelectedIndex(int i) => setState(() {
        _selectedIndex = i;
      });
}

  // Future<List<AgencyModel>> getHouseDetails(String id) async {
  //   final housesList = await selectHouseByID(id);
  //   return housesList.map((e) => AgencyModel.fromMap(e)).toList();
  //   // setState(() {});
  // }

