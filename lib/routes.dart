import 'package:flutter/material.dart';
import 'package:hostmi/ui/screens/chat_page.dart';
import 'package:hostmi/ui/screens/choice_page/choice_page.dart';
import 'package:hostmi/ui/screens/create_agency_screen/add_pictures.dart';
import 'package:hostmi/ui/screens/create_agency_screen/create_agency_basic_details.dart';
import 'package:hostmi/ui/screens/create_agency_screen/create_agency_advanced_details.dart';
import 'package:hostmi/ui/screens/create_agency_screen/review_agency_details.dart';
import 'package:hostmi/ui/screens/filter_page.dart';
import 'package:hostmi/ui/screens/home_screen/map_screen.dart';
import 'package:hostmi/ui/screens/home_screen/search_place.dart';
import 'package:hostmi/ui/screens/language_screen/language_screen.dart';
import 'package:hostmi/ui/screens/list_screen.dart';
import 'package:hostmi/ui/screens/login_screen.dart';
import 'package:hostmi/ui/screens/login_phone_number_screen.dart';
import 'package:hostmi/ui/screens/main_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/ui/screens/home_screen/map_welcome.dart';
import 'package:hostmi/ui/screens/menu_screen.dart';
import 'package:hostmi/ui/screens/message_screen/message_screen.dart';
import 'package:hostmi/ui/screens/create_agency_screen/no_agency.dart';
import 'package:hostmi/ui/screens/product_details_screen/product_details_screen.dart';
import 'package:hostmi/ui/screens/profile_screen/profile_screen.dart';
import 'package:hostmi/ui/screens/publisher_screen.dart';
import 'package:hostmi/ui/screens/register_screen.dart';
import 'package:hostmi/ui/screens/verify_phone_number_screen/verify_phone_number_screen.dart';

//Routes keys
const String keyLoginRoute = "/login";
const String publishs = "pu";
const String keyPublishRoute = "/publish";
const String keyCreateAgencyRoute = "create-agency";
const String keyCreateAgencyFullRoute = "publish/$keyCreateAgencyRoute";
const String keyCreateAgencyBasicDetailsRoute = "basic-details";
const String keyCreateAgencyBasicDetailsFullRoute =
    "$keyPublishRoute/$keyCreateAgencyRoute/$keyCreateAgencyBasicDetailsRoute";
const String keyCreateAgencyAdvancedDetailsRoute = "advanced-details";
const String keyCreateAgencyAdvancedDetailsFullRoute =
    "$keyPublishRoute/$keyCreateAgencyRoute/$keyCreateAgencyAdvancedDetailsRoute";
const String keyReviewAgencyDetailsRoute = "review-details";
const String keyReviewAgencyDetailsFullRoute =
    "$keyPublishRoute/$keyCreateAgencyRoute/$keyReviewAgencyDetailsRoute";
const String keyCreateAgencyAddPicturesRoute = "add-pictures";
const String keyCreateAgencyAddPicturesFullRoute =
    "$keyPublishRoute/$keyCreateAgencyRoute/$keyCreateAgencyAddPicturesRoute";

//End route keys

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
        path: keyLoginRoute,
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
                    builder: (context, state) => const ProductDetailsScreen(),
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
              GoRoute(
                path: keyPublishRoute,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: PublisherPage(),
                ),
                routes: [
                  GoRoute(
                      path: keyCreateAgencyRoute,
                      builder: (context, state) => const NoAgency(),
                      routes: [
                        GoRoute(
                          path: keyCreateAgencyBasicDetailsRoute,
                          builder: (context, state) =>
                              const CreateAgencyBasicDetails(),
                        ),
                        GoRoute(
                          path: keyCreateAgencyAdvancedDetailsRoute,
                          builder: (context, state) =>
                              CreateAgencyAdvancedDetails(),
                        ),
                        GoRoute(
                          path: keyReviewAgencyDetailsRoute,
                          builder: (context, state) =>
                              const ReviewAgencyDetails(),
                        ),
                        GoRoute(
                          path: keyCreateAgencyAddPicturesRoute,
                          builder: (context, state) =>
                              const AddAgencyPictures(),
                        ),
                      ]),
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
                    builder: (context, state) => const ProfilePage(),
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
