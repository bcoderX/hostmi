import 'package:flutter/material.dart';
import 'package:hostmi/ui/pages/chat_page.dart';
import 'package:hostmi/ui/pages/choice_page/choice_page.dart';
import 'package:hostmi/ui/pages/create_page.dart';
import 'package:hostmi/ui/pages/filter_page.dart';
import 'package:hostmi/ui/pages/home_page/map_page.dart';
import 'package:hostmi/ui/pages/home_page/search_place.dart';
import 'package:hostmi/ui/pages/language_page/language_page.dart';
import 'package:hostmi/ui/pages/list_page.dart';
import 'package:hostmi/ui/pages/login_page.dart';
import 'package:hostmi/ui/pages/login_phone_number_page.dart';
import 'package:hostmi/ui/pages/main_page.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/ui/pages/home_page/map_welcome.dart';
import 'package:hostmi/ui/pages/menu_page.dart';
import 'package:hostmi/ui/pages/message_page/message_page.dart';
import 'package:hostmi/ui/pages/no_page.dart';
import 'package:hostmi/ui/pages/product_details_screen/product_details_screen.dart';
import 'package:hostmi/ui/pages/profile_page/profile_page.dart';
import 'package:hostmi/ui/pages/publisher_page.dart';
import 'package:hostmi/ui/pages/register_page.dart';
import 'package:hostmi/ui/pages/verify_phone_number_screen/verify_phone_number_screen.dart';

Map<String, WidgetBuilder> getRoutes(BuildContext context) {
  return <String, WidgetBuilder>{
    LoginPage.path: (BuildContext context) => const LoginPage(),
    MainPage.path: (BuildContext context) => const MainPage(),
    CreatePage.path: (BuildContext context) => const CreatePage(),
  };
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorMapKey = GlobalKey<NavigatorState>(debugLabel: 'shellMap');
final _shellNavigatorListKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellList');
final _shellNavigatorMessageKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellList');
final _shellNavigatorPublishKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellList');
final _shellNavigatorMenuKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellList');

class HostMiRouter {
  // private navigators
  static final goRouter = GoRouter(
    initialLocation: '/',
    // * Passing a navigatorKey causes an issue on hot reload:
    // * https://github.com/flutter/flutter/issues/113757#issuecomment-1518421380
    // * However it's still necessary otherwise the navigator pops back to
    // * root on hot reload
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ChoicePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
          path: '/phone-login',
          builder: (context, state) => const LoginPhoneNumberPage(),
          routes: [
            GoRoute(
                path: "code",
                builder: (context, state) => const VerifyPhoneNumberScreen())
          ]),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      // Stateful navigation based on:
      // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorMapKey,
            routes: [
              GoRoute(
                path: '/map',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: MapWelcome(),
                ),
                routes: [
                  GoRoute(
                    path: 'main',
                    builder: (context, state) => const MapPage(),
                  ),
                  GoRoute(
                    path: 'filter',
                    builder: (context, state) => const FilterPage(),
                  ),
                  GoRoute(
                    path: 'search-place',
                    builder: (context, state) => SearchPlace(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorListKey,
            routes: [
              // Shopping Cart
              GoRoute(
                path: '/list',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ListPage(),
                ),
                routes: [
                  GoRoute(
                    path: 'details',
                    builder: (context, state) => ProductDetailsScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorMessageKey,
            routes: [
              // Shopping Cart
              GoRoute(
                path: '/messages',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: MessagePage(),
                ),
                routes: [
                  GoRoute(
                    path: 'chat',
                    builder: (context, state) => const ChatPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorPublishKey,
            routes: [
              // Shopping Cart
              GoRoute(
                path: '/publisher',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: PublisherPage(),
                ),
                routes: [
                  GoRoute(
                    path: 'no-page',
                    builder: (context, state) => const NoPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorMenuKey,
            routes: [
              // Shopping Cart
              GoRoute(
                path: '/settings',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: MenuPage(),
                ),
                routes: [
                  GoRoute(
                    path: 'profile',
                    builder: (context, state) => ProfilePage(),
                  ),
                  GoRoute(
                    path: 'language',
                    builder: (context, state) => const LanguagePage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
