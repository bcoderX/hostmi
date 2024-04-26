import 'package:flutter/material.dart';
import 'package:hostmi/ui/screens/create_agency_screen/update_agency_details.dart';
import 'package:hostmi/ui/screens/favorite_screen/favorite_houses_screen.dart';
import 'package:hostmi/ui/screens/message_screen/message_details_screen.dart';
import 'package:hostmi/ui/screens/choice_page/choice_page.dart';
import 'package:hostmi/ui/screens/create_agency_screen/add_pictures.dart';
import 'package:hostmi/ui/screens/create_agency_screen/create_agency_basic_details.dart';
import 'package:hostmi/ui/screens/create_agency_screen/create_agency_advanced_details.dart';
import 'package:hostmi/ui/screens/create_agency_screen/review_agency_details.dart';
import 'package:hostmi/ui/screens/edit_profile_screen/edit_profile_screen.dart';
import 'package:hostmi/ui/screens/filter_screen/filter_screen.dart';
import 'package:hostmi/ui/screens/home_screen/search_place.dart';
import 'package:hostmi/ui/screens/language_screen/language_screen.dart';
import 'package:hostmi/ui/screens/list_screen.dart';
import 'package:hostmi/ui/screens/login_screen.dart';
import 'package:hostmi/ui/screens/main_screen_1.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/ui/screens/home_screen/map_welcome.dart';
import 'package:hostmi/ui/screens/message_screen/message_screen.dart';
import 'package:hostmi/ui/screens/create_agency_screen/no_agency.dart';
import 'package:hostmi/ui/screens/new_password_screen.dart';
import 'package:hostmi/ui/screens/onboarding_screen/onboard.dart';
import 'package:hostmi/ui/screens/onboarding_screen/onboarding_screen.dart';
import 'package:hostmi/ui/screens/product_details_screen/product_details_screen.dart';
import 'package:hostmi/ui/screens/profile_screen/profile_screen.dart';
import 'package:hostmi/ui/screens/publisher_screen.dart';
import 'package:hostmi/ui/screens/recently_views_screen/recently_views_screen.dart';
import 'package:hostmi/ui/screens/register_screen.dart';
import 'package:hostmi/ui/screens/settings_screen/settings_screen.dart';
import 'package:hostmi/ui/screens/terms_and_conditions/terms_and_conditions.dart';
import 'package:hostmi/ui/screens/verify_otp_login_screen/verify_otp_login_screen.dart';
import 'package:hostmi/ui/screens/verify_otp_register_screen/verify_otp_register_screen.dart';

//Routes keys
const String keyLoginRoute = "/login";
const String publishs = "pu";
const String keyPublishRoute = "/publish";
const String keyCreateAgencyRoute = "/create-agency";
const String keyCreateAgencyBasicDetailsRoute = "basic-details";
const String keyCreateAgencyAdvancedDetailsRoute = "advanced-details";
const String keyReviewAgencyDetailsRoute = "review-details";
const String keyCreateAgencyAddPicturesRoute = "add-pictures";

//End route keys

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorMapKey = GlobalKey<NavigatorState>(debugLabel: 'shellMap');
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
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/choose-role/:next',
        builder: (context, state) => ChoicePage(
          next: state.pathParameters["next"]!,
        ),
      ),
      GoRoute(
        path: keyLoginRoute,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/change-password',
        builder: (context, state) => const NewPasswordScreen(),
      ),
      GoRoute(
        path: '/onboard',
        builder: (context, state) => const OnBoard(),
      ),
      GoRoute(
        path: '/filter',
        builder: (context, state) => const FilterScreen(),
      ),
      GoRoute(
        path: '/search-place',
        builder: (context, state) => const SearchPlace(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/help',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/privacy-policy',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/terms-and-conditions',
        builder: (context, state) => TermsAndConditionsScreen(),
      ),
      GoRoute(
        path: '/update-agency-details',
        builder: (context, state) => const UpdateAgencyDetails(),
      ),
      GoRoute(
        path: '/recently-viewed',
        builder: (context, state) => const RecentlyViewsScreen(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoriteHousesScreen(),
      ),
      GoRoute(
        path: '/verify-login-otp/:email/:phone',
        builder: (context, state) => VerifyOTPLoginScreen(
          email: state.pathParameters["email"] == "verify"
              ? null
              : state.pathParameters["email"],
          phoneNumber: state.pathParameters["phone"] == "verify"
              ? null
              : state.pathParameters["phone"],
        ),
      ),
      GoRoute(
        path: '/verify-register-otp/:email/:phone',
        builder: (context, state) => VerifyOTPRegisterScreen(
          email: state.pathParameters["email"] == "verify"
              ? null
              : state.pathParameters["email"],
          phoneNumber: state.pathParameters["phone"] == "verify"
              ? null
              : state.pathParameters["phone"],
        ),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/message-details/:opener/:agencyId/:userId',
        builder: (context, state) => MessagesDetailsScreen(
          agencyId: state.pathParameters["agencyId"]!,
          userId: state.pathParameters["userId"]!,
          opener: state.pathParameters["opener"]!,
        ),
      ),
      GoRoute(
        path: '/complete-profile/:previous/:next',
        builder: (context, state) => EditProfileScreen(
          next: state.pathParameters["next"]!,
        ),
      ),
      GoRoute(
        path: '/property-details/:id',
        builder: (context, state) => ProductDetailsScreen(
          houseId: state.pathParameters["id"]!,
        ),
      ),
      // Stateful navigation based on:
      // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: shellNavigatorMapKey,
            routes: [
              GoRoute(
                path: '/map',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: MapWelcome(),
                ),
                routes: [
                  GoRoute(
                    path: 'coords/:lat/:long/:name',
                    builder: (context, state) => MapWelcome(
                        latitude: double.tryParse(state.pathParameters["lat"]!),
                        longitude:
                            double.tryParse(state.pathParameters["long"]!),
                        placeName: state.pathParameters["name"]),
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
                    path: 'list/tab/:index',
                    builder: (context, state) => ListPage(
                      index: int.tryParse(state.pathParameters["index"]!) ?? 0,
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: '/property-details/:id',
                builder: (context, state) => ProductDetailsScreen(
                  houseId: state.pathParameters["id"]!,
                ),
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
              ),
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
                          const CreateAgencyAdvancedDetails(),
                    ),
                    GoRoute(
                      path: keyReviewAgencyDetailsRoute,
                      builder: (context, state) => const ReviewAgencyDetails(),
                    ),
                    GoRoute(
                      path: keyCreateAgencyAddPicturesRoute,
                      builder: (context, state) => const AddAgencyPictures(),
                    ),
                  ]),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorMenuKey,
            routes: [
              // Shopping Cart
              GoRoute(
                  path: '/settings',
                  pageBuilder: (context, state) => const NoTransitionPage(
                        child: SettingsScreen(),
                      ),
                  routes: [
                    GoRoute(
                      path: 'language',
                      builder: (context, state) => const LanguagePage(),
                    ),
                  ]),
            ],
          ),
        ],
      ),
    ],
  );
}
