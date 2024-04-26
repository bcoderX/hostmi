import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/ui/alerts/hostmi_rating_dialog.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/widgets/bottom_bar.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

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

class ScaffoldWithNavigationBar extends StatefulWidget {
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
  State<ScaffoldWithNavigationBar> createState() =>
      _ScaffoldWithNavigationBarState();
}

class _ScaffoldWithNavigationBarState extends State<ScaffoldWithNavigationBar> {
  final bool _isShown = true;
  DateTime? _currentBackPressTime;

  @override
  void initState() {
    setLocaleMessages("fr", FrMessages());
    setLocaleMessages("fr_short", FrShortMessages());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!rootNavigatorKey.currentState!.context.canPop() &&
            widget.selectedIndex > 0) {
          context.push("/map");
          return false;
        }
        DateTime now = DateTime.now();
        if ((_currentBackPressTime == null ||
                now.difference(_currentBackPressTime!) >
                    const Duration(seconds: 2)) &&
            !rootNavigatorKey.currentState!.context.canPop()) {
          _currentBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.grey,
              content: Text(
                "Appuyer encore une fois pour quitter.",
                textAlign: TextAlign.center,
              ),
            ),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            widget.body,
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  _showRatingDialog();
                },
                child: Container(
                  color: AppColor.primary.withOpacity(.5),
                  padding: const EdgeInsets.all(3),
                  child: Transform.rotate(
                    angle: -pi / 2,
                    child: const Icon(
                      Icons.feedback_rounded,
                      color: AppColor.white,
                    ),
                  ),
                ).animate(
                  onComplete: (controller) {
                    controller.repeat();
                  },
                ).shake(delay: 2.seconds, duration: 1.5.seconds),
              ),
            )
          ],
        ),
        extendBody: !_isShown,
        // floatingActionButton: InkWell(
        //   onTap: () {
        //     setState(
        //       () {
        //         _isShown = !_isShown;
        //       },
        //     );
        //   },
        //   child: Container(
        //     padding: const EdgeInsets.all(8),
        //     decoration: BoxDecoration(
        //         color: AppColor.primary.withOpacity(.6),
        //         borderRadius: BorderRadius.circular(10.0)),
        //     child: AnimatedSwitcher(
        //       duration: const Duration(
        //         milliseconds: 500,
        //       ),
        //       transitionBuilder: (child, animation) {
        //         return RotationTransition(
        //           turns: child.key == const ValueKey("icon1")
        //               ? Tween<double>(begin: 1, end: 0).animate(animation)
        //               : Tween<double>(begin: 0, end: 1).animate(animation),
        //           child: ScaleTransition(
        //             scale: animation,
        //             child: child,
        //           ),
        //         );
        //       },
        //       child: _isShown
        //           ? const Icon(
        //               Icons.close,
        //               color: AppColor.white,
        //               key: ValueKey("icon1"),
        //             )
        //           : const Icon(
        //               Icons.dashboard,
        //               color: AppColor.white,
        //             ),
        //     ),
        //   ),
        // ),
        // floatingActionButtonLocation:
        //     FloatingActionButtonLocation.miniStartFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        bottomNavigationBar: BottomBar(
          currentIndex: widget.selectedIndex,
          onTap: widget.onDestinationSelected,
          items: [
            BottomBarItem(
              icon: Icon(Icons.map, color: AppColor.primary.withOpacity(0.4)),
              activeIcon: const Icon(Icons.map, color: AppColor.primary),
              title: Text(AppLocalizations.of(context)!.mapTabText),
            ),
            BottomBarItem(
                icon: Icon(Icons.view_list,
                    color: AppColor.primary.withOpacity(0.4)),
                activeIcon:
                    const Icon(Icons.view_list, color: AppColor.primary),
                title: Text(AppLocalizations.of(context)!.listTabText)),
            BottomBarItem(
                icon: Icon(Icons.message_rounded,
                    color: AppColor.primary.withOpacity(0.4)),
                activeIcon:
                    const Icon(Icons.message_rounded, color: AppColor.primary),
                title: Text(AppLocalizations.of(context)!.messageTabText)),
            BottomBarItem(
                icon: Icon(Icons.add_home,
                    color: AppColor.primary.withOpacity(0.4)),
                activeIcon: const Icon(Icons.add_home, color: AppColor.primary),
                title: Text(AppLocalizations.of(context)!.publishTabText)),
            BottomBarItem(
                icon:
                    Icon(Icons.menu, color: AppColor.primary.withOpacity(0.4)),
                activeIcon: const Icon(Icons.menu, color: AppColor.primary),
                title: Text(AppLocalizations.of(context)!.menuTabText)),
          ],
        ),
      ),
    );
  }

  _showRatingDialog() {
    showHostmiRatingDialog(context);
  }
}

class ScaffoldWithNavigationRail extends StatefulWidget {
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
  State<ScaffoldWithNavigationRail> createState() =>
      _ScaffoldWithNavigationRailState();
}

class _ScaffoldWithNavigationRailState
    extends State<ScaffoldWithNavigationRail> {
  @override
  void initState() {
    setLocaleMessages("fr", FrMessages());
    setLocaleMessages("fr_short", FrShortMessages());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          LayoutBuilder(builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: NavigationRail(
                    selectedIndex: widget.selectedIndex,
                    onDestinationSelected: widget.onDestinationSelected,
                    labelType: NavigationRailLabelType.all,
                    destinations: <NavigationRailDestination>[
                      NavigationRailDestination(
                          icon: Icon(Icons.map,
                              color: AppColor.primary.withOpacity(0.6)),
                          selectedIcon:
                              const Icon(Icons.map, color: AppColor.primary),
                          label:
                              Text(AppLocalizations.of(context)!.mapTabText)),
                      NavigationRailDestination(
                          icon: Icon(Icons.view_list,
                              color: AppColor.primary.withOpacity(0.6)),
                          selectedIcon: const Icon(Icons.view_list,
                              color: AppColor.primary),
                          label:
                              Text(AppLocalizations.of(context)!.listTabText)),
                      NavigationRailDestination(
                          icon: Icon(Icons.message_rounded,
                              color: AppColor.primary.withOpacity(0.6)),
                          selectedIcon: const Icon(Icons.message_rounded,
                              color: AppColor.primary),
                          label: Text(
                              AppLocalizations.of(context)!.messageTabText)),
                      NavigationRailDestination(
                          icon: Icon(Icons.add_home,
                              color: AppColor.primary.withOpacity(0.6)),
                          selectedIcon: const Icon(Icons.add_home,
                              color: AppColor.primary),
                          label: Text(
                              AppLocalizations.of(context)!.publishTabText)),
                      NavigationRailDestination(
                          icon: Icon(Icons.dashboard,
                              color: AppColor.primary.withOpacity(0.6)),
                          selectedIcon: const Icon(Icons.dashboard,
                              color: AppColor.primary),
                          label:
                              Text(AppLocalizations.of(context)!.menuTabText)),
                    ],
                  ),
                ),
              ),
            );
          }),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: widget.body,
          ),
        ],
      ),
    );
  }
}
