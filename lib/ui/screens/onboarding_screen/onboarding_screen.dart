import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/constants/roles.dart';
import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/ui/alerts/error_dialog.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late VideoPlayerController _controller;
  final Role role = getRole();
  final bool _showStartupPage = getShowStartupPage();
  bool _goAuto = getShowStartupPage();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    Timer(2.seconds, () {
      if (_showStartupPage == false) {
        onTapGetstarted(context);
      }
    });

    _controller = VideoPlayerController.asset("assets/videos/house_intro.mp4")
      ..initialize().then((_) {
        if (_controller.value.isInitialized) {
          _controller.play();
          _controller.setLooping(true);
        }
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SizedBox(
            width: size.width,
            height: size.height,
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const SizedBox(),
          ),
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Container(
              width: double.maxFinite,
              color: Colors.transparent,
              padding: getPadding(left: 26, top: 40, right: 26, bottom: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: AppDecoration.txtOutlineBlack9003f,
                    child: Text(
                      "BIENVENUE",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: getFontSize(30), color: AppColor.white),
                    ),
                  ),
                  Container(
                      margin: getMargin(top: 17),
                      child: Text("Avec HostMI, louez en un clic",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColor.white,
                              fontSize: getFontSize(18)))),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                          value: _goAuto,
                          semanticLabel: "Page de démarrage",
                          onChanged: (value) {
                            setState(() {
                              _goAuto = value!;
                            });
                          }),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text("Toujours afficher cette page",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColor.white,
                                fontSize: getFontSize(18))),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          foregroundColor: AppColor.white,
                          elevation: 0.0,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        onPressed: () {
                          onTapGetstarted(context);
                        },
                        child: _showStartupPage == false
                            ? LoadingAnimationWidget.threeArchedCircle(
                                color: AppColor.white,
                                size: 25,
                              )
                            : const Text("CONTINUER")),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _startErrorDialog({required String title, required String content}) {
    showErrorDialog(
      title: title,
      content: content,
      context: context,
    );
  }

  void _navigateTo(String route) {
    context.go(route);
  }

  onTapGetstarted(BuildContext context) {
    if (role == Role.UNKNOWN) {
      context.push("/onboard");
    } else {
      if (role == Role.DEVELOPER) {
        _navigateTo(keyPublishRoute);
      } else if (role == Role.TENANT) {
        _navigateTo("/list");
      }
    }
    setShowStartupPage(_goAuto);
  }
}
