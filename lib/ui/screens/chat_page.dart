import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/ui/widgets/square_field.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1/pixelRatio;
    BubbleStyle styleSomedody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 1*px,
      margin: BubbleEdges.only(top: 50.0, right: 50.0),
      alignment: Alignment.topLeft,
    );

    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: AppColor.primary.withOpacity(.5),
      elevation: 1*px,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topRight,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColor.grey,
        foregroundColor: AppColor.black,
        title: Text("${AppLocalizations.of(context)!.discussWith} Hostmi"),
      ),
      body: Stack(
        children: [
          Container(
            color: AppColor.grey,
            child: ListView(
              padding: EdgeInsets.all(8.0),
              children: [
                Bubble(
                  alignment: Alignment.center,
                  color: AppColor.primary,
                  elevation: 1*px,
                  margin: BubbleEdges.only(top: 8.0,),
                  child: const Text(
                    "TODAY",
                    style: TextStyle(
                      fontSize: 10.0,
                      color: AppColor.white,
                    ),
                  ),
                ),
                Bubble(
                  style: styleMe,
                  child: Text("Hi ! I'd like to get a tour in your house"),
                ),
                Bubble(
                  style: styleSomedody,
                  child: Text("Well ! Are you in Koudougou ?"),
                ),
              ],
            ),
          ),
          Positioned.fill(child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
              child: Row(
                children: [
                  Expanded(child: SquareTextField(errorText: 'error', placeholder: AppLocalizations.of(context)!.typeMessage, )),
                  IconButton(onPressed: (){}, icon: Icon(Icons.send, color: AppColor.primary,))
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
