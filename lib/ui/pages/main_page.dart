import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/ui/pages/favorite_page.dart';
import 'package:hostmi/ui/pages/list_main.dart';
import 'package:hostmi/ui/pages/list_page.dart';
import 'package:hostmi/ui/pages/home_page/map_page.dart';
import 'package:hostmi/ui/pages/menu_page.dart';
import 'package:hostmi/ui/pages/message_page/message_page.dart';
import 'package:hostmi/ui/pages/publisher_page.dart';
import 'package:hostmi/utils/app_color.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, this.pageIndex=0}) : super(key: key);
  static const String path = "/";
  final int pageIndex;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Map<int, GlobalKey> navigatorKeys = {
    0: GlobalKey(),
    1: GlobalKey(),
    2: GlobalKey(),
    3: GlobalKey(),
    4: GlobalKey(),
  };

  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
     _currentIndex = widget.pageIndex;
    super.initState();
  }


  DateTime? _currentBackPressTime;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if ((_currentBackPressTime == null ||
                now.difference(_currentBackPressTime!) >
                    const Duration(seconds: 2)) &&
            navigatorKeys[_currentIndex]!.currentState!.context.size!.width ==
                0) {
          _currentBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColor.primary.withOpacity(.6),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(5.0),
              content: const Text(
                "Appuyer encore une fois pour quiter.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.white,
                ),
              ),
            ),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            return !await Navigator.maybePop(
                navigatorKeys[_currentIndex]!.currentState!.context);
          },
          child: IndexedStack(
            index: _currentIndex,
            children: <Widget>[
              MapPage(),
              ListMain(navigatorKey: navigatorKeys[1]!),
              const MessagePage(),
              const PublisherPage(),
              const MenuPage(),
            ],
          ),
        ),
        /*_pages[exist ? _currentIndex : notIntabBar]*/
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColor.grey,
          elevation: 3.0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedIconTheme: const IconThemeData(
            size: 30,
            color: AppColor.primary,
          ),
          unselectedIconTheme: IconThemeData(
            size: 30,
            color: AppColor.primary.withOpacity(0.6),
          ),
          selectedLabelStyle: const TextStyle(color: AppColor.primary),
          unselectedLabelStyle:
              TextStyle(color: AppColor.primary.withOpacity(0.6)),
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.map),
                label: AppLocalizations.of(context)!.mapTabText),
            BottomNavigationBarItem(
                icon: const Icon(Icons.view_list),
                label: AppLocalizations.of(context)!.listTabText),
            BottomNavigationBarItem(
                icon: const Icon(Icons.message_rounded),
                label: AppLocalizations.of(context)!.messageTabText),
            BottomNavigationBarItem(
                icon: const Icon(Icons.add_home),
                label: AppLocalizations.of(context)!.publishTabText),
            BottomNavigationBarItem(
                icon: const Icon(Icons.dashboard),
                label: AppLocalizations.of(context)!.menuTabText),
          ],
        ),
      ),
    );
  }
}

// Stateful navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(
      key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

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
      if (constraints.maxWidth < 450) {
        return ScaffoldWithNavigationBar(
          body: navigationShell,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
        );
      } else {
        return ScaffoldWithNavigationRail(
          body: navigationShell,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
        );
      }
    });
  }
}


class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(

        selectedIndex: selectedIndex,
        destinations:  [
          NavigationDestination(
              icon:  Icon(Icons.map, color: AppColor.primary.withOpacity(0.6)),
              selectedIcon: const Icon(Icons.map, color: AppColor.primary),
              label: AppLocalizations.of(context)!.mapTabText),
          NavigationDestination(
              icon:  Icon(Icons.view_list, color: AppColor.primary.withOpacity(0.6)),
              selectedIcon: const Icon(Icons.view_list, color: AppColor.primary),
              label: AppLocalizations.of(context)!.listTabText),
          NavigationDestination(
              icon:  Icon(Icons.message_rounded, color: AppColor.primary.withOpacity(0.6)),
              selectedIcon: const Icon(Icons.message_rounded, color: AppColor.primary),
              label: AppLocalizations.of(context)!.messageTabText),
          NavigationDestination(
              icon:  Icon(Icons.add_home, color: AppColor.primary.withOpacity(0.6)),
              selectedIcon: const Icon(Icons.add_home, color: AppColor.primary),
              label: AppLocalizations.of(context)!.publishTabText),
          NavigationDestination(
              icon:  Icon(Icons.dashboard, color: AppColor.primary.withOpacity(0.6)),
              selectedIcon: const Icon(Icons.dashboard, color: AppColor.primary),
              label: AppLocalizations.of(context)!.menuTabText),
        ],
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}

class ScaffoldWithNavigationRail extends StatelessWidget {
  const ScaffoldWithNavigationRail({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: NavigationRail(
                      selectedIndex: selectedIndex,
                      onDestinationSelected: onDestinationSelected,
                      labelType: NavigationRailLabelType.all,
                      destinations:  <NavigationRailDestination>[
                        NavigationRailDestination(
                            icon:  Icon(Icons.map, color: AppColor.primary.withOpacity(0.6)),
                            selectedIcon: const Icon(Icons.map, color: AppColor.primary),
                            label: Text(AppLocalizations.of(context)!.mapTabText)),
                        NavigationRailDestination(
                            icon:  Icon(Icons.view_list, color: AppColor.primary.withOpacity(0.6)),
                            selectedIcon: const Icon(Icons.view_list, color: AppColor.primary),
                            label: Text(AppLocalizations.of(context)!.listTabText)),
                        NavigationRailDestination(
                            icon:  Icon(Icons.message_rounded, color: AppColor.primary.withOpacity(0.6)),
                            selectedIcon: const Icon(Icons.message_rounded, color: AppColor.primary),
                            label: Text(AppLocalizations.of(context)!.messageTabText)),
                        NavigationRailDestination(
                            icon:  Icon(Icons.add_home, color: AppColor.primary.withOpacity(0.6)),
                            selectedIcon: const Icon(Icons.add_home, color: AppColor.primary),
                            label: Text(AppLocalizations.of(context)!.publishTabText)),
                        NavigationRailDestination(
                            icon:  Icon(Icons.dashboard, color: AppColor.primary.withOpacity(0.6)),
                            selectedIcon: const Icon(Icons.dashboard, color: AppColor.primary),
                            label: Text(AppLocalizations.of(context)!.menuTabText)),
                      ],
                    ),
                  ),
                ),
              );
            }
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}