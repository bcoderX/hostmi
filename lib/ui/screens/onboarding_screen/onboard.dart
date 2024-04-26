import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/constants/roles.dart';
import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter/material.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  int _currentIndex = 0;
  final SizedBox _spacer = const SizedBox(height: 20);
  late PageController _pageController;
  Role role = getRole();

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      context.push("/choose-role/register");
                    },
                    child: const Text("Créer un compte"),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Trouver la\nmaison parfaite",
                      style: TextStyle(
                        fontSize: getFontSize(30),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              _spacer,
              Expanded(
                child: Center(
                  child: CustomImageView(
                    width: double.infinity,
                    imagePath: "assets/images/searching.png",
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "Vous pourrez chercher les propriétés et discuter avec les agences près de vous.",
                  style:
                      TextStyle(fontSize: getFontSize(16), color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              _spacer,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: AppColor.primary,
                    ),
                    width: 20,
                    height: 7,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.orange[100],
                    ),
                    width: 7,
                    height: 7,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.orange[100],
                    ),
                    width: 7,
                    height: 7,
                  ),
                ],
              ),
              _spacer,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        context.push("/choose-role/map");
                      },
                      child: Text(
                        "SAUTER",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 15.0,
                      ),
                      child: TextButton(
                        onPressed: () {
                          _pageController.animateToPage(
                            _currentIndex + 1,
                            duration: 1.seconds,
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text(
                          "SUIVANT",
                          style: TextStyle(
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      context.push("/choose-role/login");
                    },
                    child: const Text("Connectez-vous à votre compte"),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Publier des\nmaisons à louer",
                      style: TextStyle(
                        fontSize: getFontSize(30),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              _spacer,
              Expanded(
                child: Center(
                  child: CustomImageView(
                    width: double.infinity,
                    imagePath: "assets/images/for_rent.png",
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "Vous pourrez publier des propriétés\net trouver des clients.",
                  style:
                      TextStyle(fontSize: getFontSize(16), color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              _spacer,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.orange[100],
                    ),
                    width: 7,
                    height: 7,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: AppColor.primary),
                    width: 20,
                    height: 7,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.orange[100],
                    ),
                    width: 7,
                    height: 7,
                  ),
                ],
              ),
              _spacer,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        context.push("/choose-role/map");
                      },
                      child: Text(
                        "SAUTER",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 15.0,
                      ),
                      child: TextButton(
                        onPressed: () {
                          _pageController.animateToPage(
                            _currentIndex + 1,
                            duration: 1.seconds,
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text(
                          "SUIVANT",
                          style: TextStyle(
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      context.push("/choose-role/login");
                    },
                    child: const Text("Connectez-vous à votre compte"),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Faites de\nbonnes affaires",
                      style: TextStyle(
                        fontSize: getFontSize(30),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              _spacer,
              Expanded(
                child: Center(
                  child: CustomImageView(
                    width: double.infinity,
                    imagePath: "assets/images/553.png",
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "Convenez ensemble entre\nlocataires et promoteurs immobiliers\ndes conditions qui vous conviennent mieux.",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _spacer,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.orange[100],
                    ),
                    width: 7,
                    height: 7,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.orange[100],
                    ),
                    width: 7,
                    height: 7,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: AppColor.primary,
                    ),
                    width: 20,
                    height: 7,
                  ),
                ],
              ),
              _spacer,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.push("/choose-role/login");
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.orange, AppColor.primary]),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Text(
                          "SE CONNECTER",
                          style: TextStyle(color: AppColor.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.orange, AppColor.primary]),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Text(
                          "CREER UN COMPTE",
                          style: TextStyle(color: AppColor.white),
                        ),
                      ),
                      onTap: () {
                        context.push("/choose-role/register");
                      },
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push("/choose-role/map");
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 30.0),
                  child: Text(
                    "Commencer",
                    style: TextStyle(
                        color: Colors.grey[500], fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
