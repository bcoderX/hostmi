import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';

class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({this.onChanged});

  Function(BottomBarEnum)? onChanged;

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int selectedIndex = 0;

  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: ImageConstant.imgHome24x24,
      title: "Home",
      type: BottomBarEnum.Home,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgMail,
      title: "Message",
      type: BottomBarEnum.Message,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgLocation24x24,
      title: "Discover",
      type: BottomBarEnum.Discover,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgHome1,
      title: "My Home",
      type: BottomBarEnum.Myhome,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgUser,
      title: "Profile",
      type: BottomBarEnum.Profile,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.blueGray1000f,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: Offset(
              0,
              -8,
            ),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: List.generate(bottomMenuList.length, (index) {
          return BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomImageView(
                  svgPath: bottomMenuList[index].icon,
                  height: getSize(
                    24,
                  ),
                  width: getSize(
                    24,
                  ),
                  color: ColorConstant.blueGray500,
                ),
                Padding(
                  padding: getPadding(
                    top: 5,
                  ),
                  child: Text(
                    bottomMenuList[index].title ?? "",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtManropeMedium10.copyWith(
                      letterSpacing: getHorizontalSize(
                        0.4,
                      ),
                      color: ColorConstant.blueGray500,
                    ),
                  ),
                ),
              ],
            ),
            activeIcon: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomImageView(
                  svgPath: bottomMenuList[index].icon,
                  height: getSize(
                    24,
                  ),
                  width: getSize(
                    24,
                  ),
                  color: ColorConstant.brown500,
                ),
                Padding(
                  padding: getPadding(
                    top: 4,
                  ),
                  child: Text(
                    bottomMenuList[index].title ?? "",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtManropeMedium10Blue500.copyWith(
                      letterSpacing: getHorizontalSize(
                        0.4,
                      ),
                      color: ColorConstant.brown500,
                    ),
                  ),
                ),
              ],
            ),
            label: '',
          );
        }),
        onTap: (index) {
          selectedIndex = index;
          widget.onChanged?.call(bottomMenuList[index].type);
          setState(() {});
        },
      ),
    );
  }
}

enum BottomBarEnum {
  Home,
  Message,
  Discover,
  Myhome,
  Profile,
}

class BottomMenuModel {
  BottomMenuModel({required this.icon, this.title, required this.type});

  String icon;

  String? title;

  BottomBarEnum type;
}

class DefaultWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
