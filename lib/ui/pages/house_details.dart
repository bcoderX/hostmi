import 'package:flutter/material.dart';
import 'package:hostmi/ui/pages/ball_loading_page.dart';
import 'package:hostmi/ui/pages/chat_page.dart';
import 'package:hostmi/utils/app_color.dart';

class HouseDetails extends StatefulWidget {
  const HouseDetails({Key? key}) : super(key: key);

  @override
  State<HouseDetails> createState() => _HouseDetailsState();
}

class _HouseDetailsState extends State<HouseDetails> {
  SizedBox _spacer = SizedBox(height: 25,);
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,

      body: SafeArea(
        child: Stack(
          children: [
            Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenSize.height * 0.4,
                        child: PageView(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: AppColor.primary,
                                image: DecorationImage(
                                    image: AssetImage("assets/images/4.jpg"),
                                    fit: BoxFit.fitHeight),
                              ),
                              child: Column(
                                children: [
                                  Expanded(child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, .7),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: const Text("Face",
                                      style: TextStyle(
                                        color: AppColor.primary,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),),),
                                  )),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 10.0),
                                        height: 10,
                                        width: 20,
                                        color: AppColor.white,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 10.0),
                                        height: 10,
                                        width: 10,
                                        color: AppColor.white,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 10.0),
                                        height: 10,
                                        width: 10,
                                        color: AppColor.white,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 10.0),
                                        height: 10,
                                        width: 10,
                                        color: AppColor.white,
                                      ),
                                    ],
                                  ),
                                  _spacer,
                                ],
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: AppColor.primary,
                                image: DecorationImage(
                                    image: AssetImage("assets/images/2.jpg"),
                                    fit: BoxFit.fitHeight),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _spacer,
                      ListTile(
                        leading: Container(
                          height: 50,
                          width: 50,
                          color: AppColor.primary,
                        ),
                        title: Text("Hostmi"),
                        subtitle: Text("Cliquer pour voir la page"),
                        trailing: GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                              return ChatPage();
                            }));
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.chat, size: 35, color: AppColor.primary,),
                              Text("Contacter"),
                            ],
                          ),
                        ),
                      ),
                      _spacer,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Material(
                              elevation: 1.0,
                                color: AppColor.grey,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      const Text("PRIX", style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.primary,
                                      ),),
                                      const Text("40 000 FCFA", style: TextStyle(
                                        fontSize: 18,
                                        color: AppColor.placeholderGrey
                                      ),),
                                      _spacer,
                                      const Text("DESCRIPTION", style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.primary,
                                      ),),
                                      const Text("Lorem ipsum dolor sit amet. Aut nulla corrupti non voluptatibus quia aut amet aliquam eum fuga autem est ratione quis. Et doloribus veniam id commodi adipisci et reiciendis sint est dolor quia. Non voluptas suscipit sit voluptatum sint qui soluta rerum cum molestiae sapiente. Et",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: AppColor.placeholderGrey,

                                      ),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            _spacer,
                            SizedBox(
                              width: double.infinity,
                              child: Material(
                                elevation: 1.0,
                                color: AppColor.grey,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                       Text("Caractéristiques", style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.primary,
                                      ),),
                                       Text("+ Eau",
                                         style: TextStyle(
                                          color: AppColor.placeholderGrey
                                      ),),
                                      Text("+ Eau",
                                        style: TextStyle(
                                            color: AppColor.placeholderGrey
                                        ),),
                                      Text("+ Eau",
                                        style: TextStyle(
                                            color: AppColor.placeholderGrey
                                        ),),
                                      Text("+ Eau",
                                        style: TextStyle(
                                            color: AppColor.placeholderGrey
                                        ),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                backgroundColor: AppColor.white.withOpacity(.3),
                foregroundColor: AppColor.black,
                elevation: 0.0,
                title: Text("Détails"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
