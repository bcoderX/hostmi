import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPlace extends StatefulWidget {
  const SearchPlace({Key? key}) : super(key: key);

  @override
  _SearchPlaceState createState() => _SearchPlaceState();
}

class _SearchPlaceState extends State<SearchPlace> {
  late TextEditingController _controller;
  List<dynamic> _placeList = [];

  _onChanged(String? value) {
    getSuggestion(value!);
  }

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void getSuggestion(String input) async {
    String url =
        "http://dev.virtualearth.net/REST/v1/Locations/$input?includeNeighborhood=1&maxResults=10&include=queryParse,ciso2&key=AqMPtuc1rEJSQqOIho6XQxEAQjMdkPo1jowOgPyPPQLfw3-pgjWhWqeWYYEoEDMc";

    var req2 = Uri.parse(url);
    try{
      var resp2 = await http.get(req2);

      if (resp2.statusCode == 200) {
        //debugPrint(resp2.body);
        setState(() {
          _placeList = json.decode(resp2.body)['resourceSets'][0]["resources"];
          debugPrint(
              json.decode(resp2.body)['resourceSets'][0]["resources"].toString());
        });
    }
      else {
        debugPrint('Failed to load predictions');
      }
    }catch(e){

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.grey,
        foregroundColor: AppColor.black,
        elevation: 0.0,
        title: TextFormField(
          controller: _controller,
          onChanged: _onChanged,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Chercher un lieu",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none),
            focusColor: Colors.white,
            filled: true,
            fillColor: Colors.white,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            prefixIcon: const BackButton(),
            suffixIcon: IconButton(
              onPressed: () {
                _controller.text = "";
                _placeList.clear();
                setState(() {});
              },
              icon: const Icon(Icons.cancel),
            ),
          ),
        ),
        actions: const [],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _placeList.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  debugPrint(
                      "${_placeList[index]["point"]["coordinates"][0]}/${_placeList[index]["point"]["coordinates"][1]}/${_placeList[index]["name"]}");
                  context.push(
                      "/map/coords/${_placeList[index]["point"]["coordinates"][0]}/${_placeList[index]["point"]["coordinates"][1]}/${_placeList[index]["name"]}");
                },
                title: Text(_placeList[index]["name"]),
                subtitle: Text(
                    "${_placeList[index]["address"]["adminDistrict2"]}, ${_placeList[index]["address"]["adminDistrict"]}"),
              ),
              Container(
                width: double.infinity,
                height: 5.0,
                color: Colors.grey[200],
              ),
            ],
          );
        },
      ),
    );
  }
}
