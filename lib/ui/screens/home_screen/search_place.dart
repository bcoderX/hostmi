import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPlace extends StatefulWidget {
  const SearchPlace({Key? key}) : super(key: key);

  @override
  _SearchPlaceState createState() => _SearchPlaceState();
}

class _SearchPlaceState extends State<SearchPlace> {
  final _controller = TextEditingController();
  var uuid = const Uuid();
  String? _sessionToken;
  List<dynamic> _placeList = [];

  _onChanged(String? value) {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(value!);
  }

  void getSuggestion(String input) async {
    String kplacesApiKey = "AIzaSyAWO3hxU9IfAC3y2geMwP4f7nRMdUX0kNk";
    // String type = '(regions)';
    String url =
        "http://dev.virtualearth.net/REST/v1/Locations/$input?includeNeighborhood=1&maxResults=10&include=queryParse,ciso2&key=AqMPtuc1rEJSQqOIho6XQxEAQjMdkPo1jowOgPyPPQLfw3-pgjWhWqeWYYEoEDMc";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    var request = Uri.parse(
        '$baseURL?input=$input&key=$kplacesApiKey&sessiontoken=$_sessionToken');
    var req2 = Uri.parse(url);
    var resp2 = await http.get(req2);
    var response = await http.get(request);
    // if (response.statusCode == 200) {
    //   debugPrint(response.body);
    //   setState(() {
    //     _placeList = json.decode(response.body)['resourceSets'];
    //   });
    // } else {
    //   throw Exception('Failed to load predictions');
    // }
    if (resp2.statusCode == 200) {
      //debugPrint(resp2.body);
      setState(() {
        _placeList = json.decode(resp2.body)['resourceSets'][0]["resources"];
        // debugPrint(json.decode(resp2.body)['resourceSets'][0]["resources"]);
      });
    } else {
      throw Exception('Failed to load predictions');
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
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppColor.grey,
            statusBarIconBrightness: Brightness.dark),
        title: TextFormField(
          controller: _controller,
          onChanged: _onChanged,
          decoration: InputDecoration(
            hintText: "Chercher un lieu",
            focusColor: Colors.white,
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
                title: Text(_placeList[index]["name"]),
              ),
              Container(
                width: double.infinity,
                height: 2.0,
                color: Colors.grey[200],
              )
            ],
          );
        },
      ),
    );
  }
}
