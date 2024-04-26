import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/models/user_profile_model.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/api/supabase/rest/users/select_profile.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/widgets/custom_icon_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<DatabaseResponse>? _profileFuture;

  UserProfileModel? _user;

  @override
  void initState() {
    if (supabase.auth.currentUser != null) {
      _profileFuture = getProfile(supabase.auth.currentUser!.id);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (supabase.auth.currentUser == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Connectez vous à votre compte"),
              TextButton(
                child: const Text("Cliquer ici pour se connecter"),
                onPressed: () {
                  context.push(keyLoginRoute);
                },
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
        backgroundColor: ColorConstant.gray50,
        appBar: AppBar(
          title: const Text("Profile"),
          backgroundColor: AppColor.grey,
          foregroundColor: AppColor.black,
          elevation: 0.0,
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Container(
                width: double.maxFinite,
                padding: getPadding(left: 24, top: 32, right: 24, bottom: 32),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: getSize(70),
                          width: getSize(70),
                          child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                FutureBuilder<DatabaseResponse>(
                                    future: _profileFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data!.isSuccess) {
                                          _user = UserProfileModel.fromMap(
                                              data: snapshot.data!.list![0]);

                                          return Container(
                                              width: getSize(100),
                                              height: getSize(100),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                                color: AppColor.primary,
                                              ),
                                              child: _user!.avatarUrl == null
                                                  ? const Icon(
                                                      Icons.person,
                                                      color: Colors.white,
                                                    )
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl: supabase
                                                            .storage
                                                            .from("profiles")
                                                            .getPublicUrl(_user!
                                                                .avatarUrl!),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ));
                                        }
                                      }
                                      return CustomImageView(
                                          imagePath:
                                              ImageConstant.imageNotFound,
                                          height: getSize(70),
                                          width: getSize(70),
                                          radius: BorderRadius.circular(
                                              getHorizontalSize(35)),
                                          alignment: Alignment.center);
                                    }),
                              ])),
                      Padding(
                          padding: getPadding(top: 8),
                          child: FutureBuilder<DatabaseResponse>(
                              future: _profileFuture,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data!.isSuccess) {
                                    _user = UserProfileModel.fromMap(
                                        data: snapshot.data!.list![0]);

                                    return Text(
                                        _user == null ||
                                                _user!.firstname == null
                                            ? "---"
                                            : "${_user!.firstname} ${_user!.lastname}",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle.txtManropeBold18
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.2)));
                                  }
                                }
                                return Text("---",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtManropeBold18.copyWith(
                                        letterSpacing: getHorizontalSize(0.2)));
                              })),
                      Padding(
                          padding: getPadding(top: 4),
                          child: Text(
                              supabase.auth.currentUser!.email ??
                                  supabase.auth.currentUser!.phone ??
                                  '---',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtManropeMedium14Bluegray500)),
                      GestureDetector(
                          onTap: () {
                            onTapBtnEdit(context);
                          },
                          child: Padding(
                              padding: getPadding(top: 15),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CustomIconButton(
                                        height: 40,
                                        width: 40,
                                        variant:
                                            IconButtonVariant.FillBluegray50,
                                        shape: IconButtonShape.RoundedBorder10,
                                        padding: IconButtonPadding.PaddingAll12,
                                        child: Icon(
                                          Icons.person_4,
                                          color: AppColor.primary,
                                          size: 15,
                                        )),
                                    Padding(
                                        padding: getPadding(
                                            left: 16, top: 12, bottom: 7),
                                        child: Text("Données personnelles",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeSemiBold14Gray900)),
                                    const Spacer(),
                                    CustomImageView(
                                        svgPath: ImageConstant
                                            .imgArrowrightBlueGray500,
                                        height: getSize(20),
                                        width: getSize(20),
                                        margin: getMargin(top: 10, bottom: 10))
                                  ]))),
                      GestureDetector(
                          onTap: () {
                            onTapRecentlyView(context);
                          },
                          child: Padding(
                              padding: getPadding(top: 15),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CustomIconButton(
                                        height: 40,
                                        width: 40,
                                        variant:
                                            IconButtonVariant.FillBluegray50,
                                        shape: IconButtonShape.RoundedBorder10,
                                        padding: IconButtonPadding.PaddingAll12,
                                        child: Icon(
                                          Icons.remove_red_eye,
                                          color: AppColor.primary,
                                          size: 15,
                                        )),
                                    Padding(
                                        padding: getPadding(
                                            left: 16, top: 12, bottom: 7),
                                        child: Text("Historique des vues",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeSemiBold14Gray900)),
                                    const Spacer(),
                                    CustomImageView(
                                        svgPath: ImageConstant
                                            .imgArrowrightBlueGray500,
                                        height: getSize(20),
                                        width: getSize(20),
                                        margin: getMargin(top: 10, bottom: 10))
                                  ]))),
                      GestureDetector(
                          onTap: () {
                            onTapMyfavorites(context);
                          },
                          child: Padding(
                              padding: getPadding(top: 16),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CustomIconButton(
                                        height: 40,
                                        width: 40,
                                        variant:
                                            IconButtonVariant.FillBluegray50,
                                        shape: IconButtonShape.RoundedBorder10,
                                        padding: IconButtonPadding.PaddingAll12,
                                        child: Icon(
                                          Icons.favorite_border,
                                          color: AppColor.primary,
                                          size: 15,
                                        )),
                                    Padding(
                                        padding: getPadding(
                                            left: 16, top: 12, bottom: 7),
                                        child: Text("Mes favoris",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeSemiBold14Gray900)),
                                    const Spacer(),
                                    CustomImageView(
                                        svgPath: ImageConstant
                                            .imgArrowrightBlueGray500,
                                        height: getSize(20),
                                        width: getSize(20),
                                        margin: getMargin(top: 10, bottom: 10))
                                  ]))),
                      GestureDetector(
                          onTap: () {
                            onTapMylistings(context);
                          },
                          child: Padding(
                              padding: getPadding(top: 16),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CustomIconButton(
                                        height: 40,
                                        width: 40,
                                        variant:
                                            IconButtonVariant.FillBluegray50,
                                        shape: IconButtonShape.RoundedBorder10,
                                        padding: IconButtonPadding.PaddingAll12,
                                        child: Icon(
                                          Icons.house_siding,
                                          color: AppColor.primary,
                                          size: 15,
                                        )),
                                    Padding(
                                        padding: getPadding(
                                            left: 16, top: 12, bottom: 7),
                                        child: Text("Mes propriétés",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeSemiBold14Gray900)),
                                    const Spacer(),
                                    CustomImageView(
                                        svgPath: ImageConstant
                                            .imgArrowrightBlueGray500,
                                        height: getSize(20),
                                        width: getSize(20),
                                        margin: getMargin(top: 10, bottom: 10))
                                  ]))),
                      GestureDetector(
                          onTap: () {
                            onTapPasttour(context);
                          },
                          child: Padding(
                              padding: getPadding(top: 16),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CustomIconButton(
                                        height: 40,
                                        width: 40,
                                        variant:
                                            IconButtonVariant.FillBluegray50,
                                        shape: IconButtonShape.RoundedBorder10,
                                        padding: IconButtonPadding.PaddingAll12,
                                        child: Icon(
                                          Icons.lock_reset_outlined,
                                          color: AppColor.primary,
                                          size: 15,
                                        )),
                                    Padding(
                                        padding: getPadding(
                                            left: 16, top: 10, bottom: 9),
                                        child: Text(
                                            "Rénitialiser mon mot de passe",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeSemiBold14Gray900)),
                                    const Spacer(),
                                    CustomImageView(
                                        svgPath: ImageConstant
                                            .imgArrowrightBlueGray500,
                                        height: getSize(20),
                                        width: getSize(20),
                                        margin: getMargin(top: 10, bottom: 10))
                                  ]))),
                    ])),
          ),
        ));
  }

  onTapBtnEdit(BuildContext context) {
    context.push("/complete-profile/profile/profile");
  }

  onTapRecentlyView(BuildContext context) {
    context.push('/recently-viewed');
    //Navigator.pushNamed(context, AppRoutes.recentlyViewsScreen);
  }

  onTapMyfavorites(BuildContext context) {
    context.push('/favorites');
  }

  onTapPasttour(BuildContext context) {
    context.push("/change-password");
    //Navigator.pushNamed(context, AppRoutes.pastToursScreen);
  }

  onTapMylistings(BuildContext context) {
    context.push("/publish");
    //Navigator.pushNamed(context, AppRoutes.homeListingScreen);
  }

  onTapSettings(BuildContext context) {
    //Navigator.pushNamed(context, AppRoutes.settingsScreen);
  }
}
