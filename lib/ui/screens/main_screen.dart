import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/firebase/analytics_client.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/utils/check_existing_db_updates.dart';
import 'package:hostmi/api/utils/check_existing_updates.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/ui/alerts/hostmi_rating_dialog.dart';
import 'package:hostmi/ui/screens/home_screen/map_welcome.dart';
import 'package:hostmi/ui/screens/list_screen.dart';
import 'package:hostmi/ui/screens/message_screen/message_screen.dart';
import 'package:hostmi/ui/screens/publisher_screen.dart';
import 'package:hostmi/ui/screens/settings_screen/settings_screen.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/widgets/bottom_bar.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

// Stateful navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
    this.selectedIndex,
    this.latitude,
    this.longitude,
    this.placeName,
  }) : super(
            key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'));
  final double? selectedIndex;
  final double? latitude;
  final double? longitude;
  final String? placeName;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> _tabs =["Maps", "List", "message", "publish", "Menu"];
  DateTime? _currentBackPressTime;
  late final PageController _pageController;
  double? selectedPage = 0;
  String? rest = "page_view";
  bool _isMenuOpened = true;
  @override
  void initState() {
    selectedPage = widget.selectedIndex ?? 0;
    _pageController = PageController(
        initialPage:
            widget.selectedIndex == null ? 0 : widget.selectedIndex!.toInt())
      ..addListener(() {
        setState(() {
          selectedPage = _pageController.page;
        });
        try{
          analytics.logScreenView(screenName: _tabs[_pageController.page!.toInt()]);
        }catch(e){
          debugPrint(e.toString());
        }
      });
    setLocaleMessages("fr", FrMessages());
    setLocaleMessages("fr_short", FrShortMessages());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      checkExistingUpdates(context);
      checkExistingDbUpdates(context);

      context.read<HostmiProvider>().initMessenger();
    });

    return WillPopScope(
      onWillPop: () async {
        if (!rootNavigatorKey.currentState!.context.canPop() &&
            selectedPage! > 0) {
          _pageController.animateToPage(0, duration: 20.ms, curve: Curves.ease);
          return false;
        }
        DateTime now = DateTime.now();
        if ((_currentBackPressTime == null ||
                now.difference(_currentBackPressTime!) >
                    const Duration(seconds: 2)) &&
            !rootNavigatorKey.currentState!.context.canPop()) {
          _currentBackPressTime = now;
          Fluttertoast.showToast(
              msg: "Appuyer encore une fois pour quitter",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
          return false;
        }
        analytics.logEvent(name: 'quit_app');
        return true;
      },
      child: OrientationBuilder(builder: (context, orientation) {
        return LayoutBuilder(builder: (context, constraints) {
          return Scaffold(
            body: Row(
              children: [
                orientation == Orientation.landscape && _isMenuOpened
                    ? LayoutBuilder(builder: (context, constraint) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: constraint.maxHeight),
                            child: IntrinsicHeight(
                              child: NavigationRail(
                                selectedIndex: selectedPage!.toInt(),
                                onDestinationSelected:
                                    onDestinationSelected,
                                labelType: NavigationRailLabelType.all,
                                destinations: <NavigationRailDestination>[
                                  NavigationRailDestination(
                                      icon: Icon(Icons.map,
                                          color: AppColor.primary
                                              .withOpacity(0.6)),
                                      selectedIcon: const Icon(Icons.map,
                                          color: AppColor.primary),
                                      label: Text(
                                          AppLocalizations.of(context)!
                                              .mapTabText)),
                                  NavigationRailDestination(
                                      icon: Icon(Icons.view_list,
                                          color: AppColor.primary
                                              .withOpacity(0.6)),
                                      selectedIcon: const Icon(
                                          Icons.view_list,
                                          color: AppColor.primary),
                                      label: Text(
                                          AppLocalizations.of(context)!
                                              .listTabText)),
                                  NavigationRailDestination(
                                      icon: Stack(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: (context
                                                                .watch<
                                                                    HostmiProvider>()
                                                                .unreadUserCount +
                                                            context
                                                                .watch<
                                                                    HostmiProvider>()
                                                                .unreadAgencyCount) >
                                                        0
                                                    ? 7
                                                    : 0,
                                                right: (context
                                                                .watch<
                                                                    HostmiProvider>()
                                                                .unreadUserCount +
                                                            context
                                                                .watch<
                                                                    HostmiProvider>()
                                                                .unreadAgencyCount) >
                                                        0
                                                    ? 7
                                                    : 0),
                                            child: Icon(Icons.message_rounded,
                                                color: AppColor.primary
                                                    .withOpacity(0.4)),
                                          ),
                                          (context
                                                          .watch<
                                                              HostmiProvider>()
                                                          .unreadUserCount +
                                                      context
                                                          .watch<
                                                              HostmiProvider>()
                                                          .unreadAgencyCount) >
                                                  0
                                              ? Positioned.fill(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 5,
                                                              vertical: 2),
                                                      decoration: BoxDecoration(
                                                          color: AppColor
                                                              .primary,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0)),
                                                      child: Text(
                                                        (context
                                                                    .watch<
                                                                        HostmiProvider>()
                                                                    .unreadUserCount +
                                                                context
                                                                    .watch<
                                                                        HostmiProvider>()
                                                                    .unreadAgencyCount)
                                                            .numeral(),
                                                        style:
                                                            const TextStyle(
                                                          color:
                                                              Colors.white,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                      selectedIcon: const Icon(
                                          Icons.message_rounded,
                                          color: AppColor.primary),
                                      label: Text(
                                          AppLocalizations.of(context)!
                                              .messageTabText)),
                                  NavigationRailDestination(
                                      icon: Icon(Icons.add_home,
                                          color: AppColor.primary
                                              .withOpacity(0.6)),
                                      selectedIcon: const Icon(
                                          Icons.add_home,
                                          color: AppColor.primary),
                                      label: Text(
                                          AppLocalizations.of(context)!
                                              .publishTabText)),
                                  NavigationRailDestination(
                                      icon: Stack(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: context
                                                        .watch<
                                                            HostmiProvider>()
                                                        .hasUpdates
                                                    ? 7
                                                    : 0,
                                                right: context
                                                        .watch<
                                                            HostmiProvider>()
                                                        .hasUpdates
                                                    ? 7
                                                    : 0),
                                            child: Icon(Icons.menu,
                                                color: AppColor.primary
                                                    .withOpacity(0.4)),
                                          ),
                                          context
                                                  .watch<HostmiProvider>()
                                                  .hasUpdates
                                              ? Positioned.fill(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 5,
                                                              vertical: 2),
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0)),
                                                      child: const Icon(
                                                        Icons.arrow_upward,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                      selectedIcon: const Icon(Icons.menu,
                                          color: AppColor.primary),
                                      label: Text(
                                          AppLocalizations.of(context)!
                                              .menuTabText)),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                    : const SizedBox(),
                orientation == Orientation.portrait
                    ? const SizedBox()
                    : const VerticalDivider(thickness: 1, width: 1),
                // This is the main content.
                Expanded(
                  child: Stack(
                    children: [
                      PageView(
                        restorationId: rest,
                        controller: _pageController,
                        children: [
                          MapWelcome(
                            latitude: widget.latitude,
                            longitude: widget.longitude,
                            placeName: widget.placeName,
                          ),
                           ListPage( onAddHouse: (){
                             _pageController.animateToPage(3, duration: 20.ms, curve: Curves.ease);
                          }),
                          const MessagePage(),
                          const PublisherPage(),
                          const SettingsScreen(),
                        ],
                      ),
                      orientation == Orientation.portrait
                          ? const SizedBox()
                          : Align(
                              alignment: Alignment.bottomLeft,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _isMenuOpened = !_isMenuOpened;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: AppColor.primary.withOpacity(.5),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Icon(
                                    _isMenuOpened
                                        ? Icons.close
                                        : Icons.arrow_forward_ios,
                                    color: AppColor.white,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: orientation == Orientation.portrait
                ? BottomBar(
                    currentIndex: selectedPage!.toInt(),
                    onTap: onDestinationSelected,
                    items: [
                      BottomBarItem(
                        icon: Icon(Icons.map,
                            color: AppColor.primary.withOpacity(0.4)),
                        activeIcon:
                            const Icon(Icons.map, color: AppColor.primary),
                        title: Text(AppLocalizations.of(context)!.mapTabText),
                      ),
                      BottomBarItem(
                          icon: Icon(Icons.view_list,
                              color: AppColor.primary.withOpacity(0.4)),
                          activeIcon: const Icon(Icons.view_list,
                              color: AppColor.primary),
                          title:
                              Text(AppLocalizations.of(context)!.listTabText)),
                      BottomBarItem(
                          icon: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: (context
                                                    .watch<HostmiProvider>()
                                                    .unreadUserCount +
                                                context
                                                    .watch<HostmiProvider>()
                                                    .unreadAgencyCount) >
                                            0
                                        ? 7
                                        : 0,
                                    right: (context
                                                    .watch<HostmiProvider>()
                                                    .unreadUserCount +
                                                context
                                                    .watch<HostmiProvider>()
                                                    .unreadAgencyCount) >
                                            0
                                        ? 7
                                        : 0),
                                child: Icon(Icons.message_rounded,
                                    color: AppColor.primary.withOpacity(0.4)),
                              ),
                              (context.watch<HostmiProvider>().unreadUserCount +
                                          context
                                              .watch<HostmiProvider>()
                                              .unreadAgencyCount) >
                                      0
                                  ? Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 2),
                                          decoration: BoxDecoration(
                                              color: AppColor.primary,
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: Text(
                                            (context
                                                        .watch<HostmiProvider>()
                                                        .unreadUserCount +
                                                    context
                                                        .watch<HostmiProvider>()
                                                        .unreadAgencyCount)
                                                .numeral(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          activeIcon: const Icon(Icons.message_rounded,
                              color: AppColor.primary),
                          title: Text(
                              AppLocalizations.of(context)!.messageTabText)),
                      BottomBarItem(
                          icon: Icon(Icons.add_home,
                              color: AppColor.primary.withOpacity(0.4)),
                          activeIcon: const Icon(Icons.add_home,
                              color: AppColor.primary),
                          title: Text(
                              AppLocalizations.of(context)!.publishTabText)),
                      BottomBarItem(
                        icon: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top:
                                      context.watch<HostmiProvider>().hasUpdates
                                          ? 7
                                          : 0,
                                  right:
                                      context.watch<HostmiProvider>().hasUpdates
                                          ? 7
                                          : 0),
                              child: Icon(Icons.menu,
                                  color: AppColor.primary.withOpacity(0.4)),
                            ),
                            context.watch<HostmiProvider>().hasUpdates
                                ? Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 2),
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: const Icon(
                                          Icons.arrow_upward,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                        activeIcon:
                            const Icon(Icons.menu, color: AppColor.primary),
                        title: Text(AppLocalizations.of(context)!.menuTabText),
                      ),
                    ],
                  )
                : null,
          );
        });
      }),
    );
  }



  onDestinationSelected(int index) {
    _pageController.animateToPage(index, duration: 20.ms, curve: Curves.linear);
  }
}

// class ScaffoldWithNavigationRail extends StatefulWidget {
//   const ScaffoldWithNavigationRail({
//     super.key,
//     required this.body,
//     required this.selectedIndex,
//     required this.onDestinationSelected,
//   });
//   final Widget body;
//   final int selectedIndex;
//   final ValueChanged<int> onDestinationSelected;

//   @override
//   State<ScaffoldWithNavigationRail> createState() =>
//       _ScaffoldWithNavigationRailState();
// }

// class _ScaffoldWithNavigationRailState
//     extends State<ScaffoldWithNavigationRail> {
//   @override
//   void initState() {
//     setLocaleMessages("fr", FrMessages());
//     setLocaleMessages("fr_short", FrShortMessages());
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           LayoutBuilder(builder: (context, constraint) {
//             return SingleChildScrollView(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(minHeight: constraint.maxHeight),
//                 child: IntrinsicHeight(
//                   child: NavigationRail(
//                     selectedIndex: widget.selectedIndex,
//                     onDestinationSelected: widget.onDestinationSelected,
//                     labelType: NavigationRailLabelType.all,
//                     destinations: <NavigationRailDestination>[
//                       NavigationRailDestination(
//                           icon: Icon(Icons.map,
//                               color: AppColor.primary.withOpacity(0.6)),
//                           selectedIcon:
//                               const Icon(Icons.map, color: AppColor.primary),
//                           label:
//                               Text(AppLocalizations.of(context)!.mapTabText)),
//                       NavigationRailDestination(
//                           icon: Icon(Icons.view_list,
//                               color: AppColor.primary.withOpacity(0.6)),
//                           selectedIcon: const Icon(Icons.view_list,
//                               color: AppColor.primary),
//                           label:
//                               Text(AppLocalizations.of(context)!.listTabText)),
//                       NavigationRailDestination(
//                           icon: Icon(Icons.message_rounded,
//                               color: AppColor.primary.withOpacity(0.6)),
//                           selectedIcon: const Icon(Icons.message_rounded,
//                               color: AppColor.primary),
//                           label: Text(
//                               AppLocalizations.of(context)!.messageTabText)),
//                       NavigationRailDestination(
//                           icon: Icon(Icons.add_home,
//                               color: AppColor.primary.withOpacity(0.6)),
//                           selectedIcon: const Icon(Icons.add_home,
//                               color: AppColor.primary),
//                           label: Text(
//                               AppLocalizations.of(context)!.publishTabText)),
//                       NavigationRailDestination(
//                           icon: Icon(Icons.dashboard,
//                               color: AppColor.primary.withOpacity(0.6)),
//                           selectedIcon: const Icon(Icons.dashboard,
//                               color: AppColor.primary),
//                           label:
//                               Text(AppLocalizations.of(context)!.menuTabText)),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }),
//           const VerticalDivider(thickness: 1, width: 1),
//           // This is the main content.
//           Expanded(
//             child: widget.body,
//           ),
//         ],
//       ),
//     );
//   }
// }
