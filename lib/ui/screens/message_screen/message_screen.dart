import 'package:flutter/services.dart';
import 'package:hostmi/ui/screens/chat_page.dart';
import 'package:hostmi/utils/app_color.dart';
import '../message_screen/widgets/message_item_widget.dart';

import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.gray50,
        appBar: AppBar(
          title: const Text("Messages"),
          backgroundColor: AppColor.grey,
          foregroundColor: AppColor.black,
          elevation: 0.0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Container(
                width: double.maxFinite,
                padding: getPadding(left: 24, top: 42, right: 24, bottom: 42),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return Padding(
                                padding: getPadding(top: 17.0, bottom: 17.0),
                                child: SizedBox(
                                    width: getHorizontalSize(327),
                                    child: Divider(
                                        height: getVerticalSize(1),
                                        thickness: getVerticalSize(1),
                                        color: ColorConstant.blueGray50)));
                          },
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return MessageItemWidget(onTaptf: () {
                              onTaptf(context);
                            });
                          }),
                      Padding(
                        padding: getPadding(top: 14, bottom: 5),
                        child: Divider(
                            height: getVerticalSize(1),
                            thickness: getVerticalSize(1),
                            color: ColorConstant.blueGray50),
                      ),
                    ])),
          ),
        ),
      ),
    );
  }

  onTaptf(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return const ChatPage();
    }));
  }

  onTapArrowleft2(BuildContext context) {
    Navigator.pop(context);
  }
}
