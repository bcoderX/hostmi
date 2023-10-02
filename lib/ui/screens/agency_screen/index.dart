import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/ui/screens/add_house1.dart';
import 'package:hostmi/ui/widgets/landloard_action_button.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LandlordPage extends StatelessWidget {
  const LandlordPage({
    Key? key,
    required this.navigationShell,
    required this.agency,
  }) : super(
            key: key ??
                const ValueKey<String>('LandlordPageWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;
  final List<Map<String, dynamic>> agency;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return AgencyScreenWithNavigationBar(
        body: navigationShell,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        agencyList: agency,
      );
    });
  }
}

class AgencyScreenWithNavigationBar extends StatefulWidget {
  const AgencyScreenWithNavigationBar({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.agencyList,
  });
  final List<Map<String, dynamic>> agencyList;

  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  State<AgencyScreenWithNavigationBar> createState() =>
      _AgencyScreenWithNavigationBarState();
}

class _AgencyScreenWithNavigationBarState
    extends State<AgencyScreenWithNavigationBar> {
  final SizedBox _spacer = const SizedBox(height: 10);
  late final AgencyModel agency;

  @override
  void initState() {
    agency = AgencyModel.fromMap(widget.agencyList[0]["agencies"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.body == null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.grey,
              foregroundColor: AppColor.black,
              elevation: 0.0,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.light,
              ),
              title: Text(
                agency.name!,
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
                        style: const TextStyle(
                            color: AppColor.black, fontSize: 18.0),
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
                              height: 200,
                              decoration: BoxDecoration(
                                color: AppColor.grey,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    agency.coverImageUrl!,
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
                              height: 200,
                              width: 200,
                              margin: const EdgeInsets.only(
                                right: 25,
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(agency.profileImageUrl!),
                                  fit: BoxFit.cover,
                                ),
                                //borderRadius: BorderRadius.circular(100.0),
                                border: Border.all(
                                    color: AppColor.grey, width: 5.0),
                                color: AppColor.iconBorderGrey,
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
                                color: widget.selectedIndex == 0
                                    ? AppColor.white
                                    : Colors.grey[800],
                                size: 18.0,
                              ),
                              backgroundColor: widget.selectedIndex == 0
                                  ? AppColor.primary
                                  : null,
                              foregroundColor: widget.selectedIndex == 0
                                  ? AppColor.white
                                  : null,
                              text: "Publication",
                              onPressed: () {
                                widget.onDestinationSelected(0);
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (BuildContext context) {
                                //   return const AddHouse1();
                                // }));
                              },
                            ),
                            ActionButton(
                              icon: Icon(
                                Icons.contact_page,
                                color: widget.selectedIndex == 1
                                    ? AppColor.white
                                    : Colors.grey[800],
                                size: 18.0,
                              ),
                              backgroundColor: widget.selectedIndex == 1
                                  ? AppColor.primary
                                  : null,
                              foregroundColor: widget.selectedIndex == 1
                                  ? AppColor.white
                                  : null,
                              text: "Contacts",
                              onPressed: () {
                                widget.onDestinationSelected(1);
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (BuildContext context) {
                                //   return const AddHouse1();
                                // }));
                              },
                            ),
                            ActionButton(
                              icon: Icon(
                                Icons.settings,
                                color: widget.selectedIndex == 2
                                    ? AppColor.white
                                    : Colors.grey[800],
                                size: 18.0,
                              ),
                              backgroundColor: widget.selectedIndex == 2
                                  ? AppColor.primary
                                  : null,
                              foregroundColor: widget.selectedIndex == 2
                                  ? AppColor.white
                                  : null,
                              text: AppLocalizations.of(context)!.manage,
                              onPressed: () {
                                widget.onDestinationSelected(2);
                              },
                            ),
                            ActionButton(
                              icon: Icon(
                                Icons.add_circle,
                                color: Colors.grey[800],
                                size: 18.0,
                              ),
                              text: AppLocalizations.of(context)!.addHouse,
                              onPressed: () {
                                //widget.onDestinationSelected(2);
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (BuildContext context) {
                                //   return const AddHouse1();
                                // }));
                              },
                            ),
                            ActionButton(
                              icon: Icon(
                                Icons.share,
                                color: Colors.grey[800],
                                size: 18.0,
                              ),
                              text: AppLocalizations.of(context)!.share,
                            ),
                          ],
                        ),
                      ),
                    ),
                    widget.body
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            body: widget.body,
            bottomNavigationBar: NavigationBar(
              selectedIndex: widget.selectedIndex,
              destinations: [
                NavigationDestination(
                    icon: Icon(Icons.map,
                        color: AppColor.primary.withOpacity(0.6)),
                    selectedIcon:
                        const Icon(Icons.map, color: AppColor.primary),
                    label: AppLocalizations.of(context)!.mapTabText),
                NavigationDestination(
                    icon: Icon(Icons.view_list,
                        color: AppColor.primary.withOpacity(0.6)),
                    selectedIcon:
                        const Icon(Icons.view_list, color: AppColor.primary),
                    label: AppLocalizations.of(context)!.listTabText),
                NavigationDestination(
                    icon: Icon(Icons.message_rounded,
                        color: AppColor.primary.withOpacity(0.6)),
                    selectedIcon: const Icon(Icons.message_rounded,
                        color: AppColor.primary),
                    label: AppLocalizations.of(context)!.messageTabText),
                NavigationDestination(
                    icon: Icon(Icons.add_home,
                        color: AppColor.primary.withOpacity(0.6)),
                    selectedIcon:
                        const Icon(Icons.add_home, color: AppColor.primary),
                    label: AppLocalizations.of(context)!.publishTabText),
                NavigationDestination(
                    icon: Icon(Icons.dashboard,
                        color: AppColor.primary.withOpacity(0.6)),
                    selectedIcon:
                        const Icon(Icons.dashboard, color: AppColor.primary),
                    label: AppLocalizations.of(context)!.menuTabText),
              ],
              onDestinationSelected: widget.onDestinationSelected,
            ),
          );
  }
}
