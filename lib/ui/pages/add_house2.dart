import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostmi/ui/pages/add_house3.dart';
import 'package:hostmi/ui/widgets/image_form_field.dart';
import 'package:hostmi/ui/widgets/labeled_dropdown.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddHouse2 extends StatefulWidget {
  const AddHouse2({Key? key}) : super(key: key);

  @override
  State<AddHouse2> createState() => _AddHouse2State();
}

class _AddHouse2State extends State<AddHouse2> {
  String fieldToAdd = "";
  List<File?> images = [null, null, null, null, null];
  List<String> fields = [];

  final SizedBox _spacer = SizedBox(height: 25.0);
  @override
  Widget build(BuildContext context) {
    fields = [
      AppLocalizations.of(context)!.facePicture,
      AppLocalizations.of(context)!.mainRoom,
      "${AppLocalizations.of(context)!.bedroom} 1",
      "${AppLocalizations.of(context)!.bedroom} 2",
      "${AppLocalizations.of(context)!.bathRoom} 1",
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.grey,
        foregroundColor: AppColor.black,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppColor.grey,
            statusBarIconBrightness: Brightness.dark),
        title: Text(AppLocalizations.of(context)!.addHouse),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      AppLocalizations.of(context)!.housePictures,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                        vertical: 5.0,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: AppColor.primary,
                      ),
                      child:  Center(
                        child: Text(
                          "${AppLocalizations.of(context)!.step} 2/3",
                          style: TextStyle(
                            color: AppColor.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  children: [
                    ...fields.map((field) {
                      return ImageFormField(
                        label: field,
                        onTap: () async {
                          await pickImage(fields.indexOf(field));
                        },
                        fileImage: images[fields.indexOf(field)],
                      );
          }).toList()
                    ,
                  ],
                ),
                _spacer,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: LabeledDropdownField(
                        label: '+ ${AppLocalizations.of(context)!.addNewRoom}',
                        value: "kitchen",
                        items: [
                          DropdownMenuItem<String>(
                            value: "kitchen",
                            child: Text(AppLocalizations.of(context)!.kitchen),
                          ),
                          DropdownMenuItem<String>(
                            value: "garden",
                            child: Text(AppLocalizations.of(context)!.garden),
                          ),
                        ],
                        onChanged: (String? value) {
                            switch(value){
                              case "kitchen":
                                fieldToAdd = AppLocalizations.of(context)!.kitchen;
                                break;
                              case "garden":
                                fieldToAdd = AppLocalizations.of(context)!.garden;
                                break;
                              default:
                                break;
                          }
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        addField(fieldToAdd);
                      },
                      child: Text(AppLocalizations.of(context)!.add, style: TextStyle(color: AppColor.primary),),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 23, horizontal: 30),
                        backgroundColor: AppColor.bottomBarGrey,

                      ),
                    )
                  ],
                ),
                _spacer,
                MaterialButton(
                  color: AppColor.primary,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  minWidth: double.infinity,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const AddHouse3();
                        },
                      ),
                    );
                  },
                  child:  Text(
                    AppLocalizations.of(context)!.defineMoreChars,
                    style: TextStyle(color: AppColor.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future pickImage(int index) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        images[index] = imageTemp;
      });
    } on PlatformException catch (e) {}
  }

  void addField(String fieldName){
    setState(() {
      if(!fields.contains(fieldName) && fieldToAdd.isNotEmpty){
        fields.add(fieldName);
        images.add(null);
      }
    });
  }
}
