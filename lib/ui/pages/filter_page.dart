import 'package:flutter/material.dart';
import 'package:hostmi/ui/widgets/range_field.dart';
import 'package:hostmi/ui/widgets/square_field.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  bool _showMore = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.grey,
        foregroundColor: AppColor.black,
        elevation: 0.4,
        title: Text(AppLocalizations.of(context)!.filter),
        actions: [
           Padding(
            padding:  EdgeInsets.all(4.0),
            child: CircleAvatar(
              backgroundColor: AppColor.primary,
              radius: 28,
              child: Text(AppLocalizations.of(context)!.filter, style: TextStyle(
                color: Colors.white
              ),),
            ),
          )
        ],
      ),
      body: Scaffold(
        body: Scrollbar(child: SingleChildScrollView(
          child: Column(
            children: [
              Container(width: double.infinity, height: 10.0, color: Colors.grey[200],),
               SquareTextField(errorText: "error", placeholder: AppLocalizations.of(context)!.chooseTown, prefixIcon: Icon(Icons.search),),
              Container(width: double.infinity, height: 10.0, color: Colors.grey[200],),
               Padding(padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 15.0),
                child: RangeField(rangeValues: RangeValues(5000.0, 100000.0), title: AppLocalizations.of(context)!.price,
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 15.0),
                child: Row(
                  children:  [
                    Expanded(child: RangeField(rangeValues: RangeValues(0.0, 100.0), title: AppLocalizations.of(context)!.bedroom,)),
                    SizedBox(width: 25,),
                    Expanded(child: RangeField(rangeValues: RangeValues(0.0, 100.0), title: AppLocalizations.of(context)!.bathRoom,)),
                  ],
                ),
              ),
              Container(width: double.infinity, height: 1.0, color: Colors.grey,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 4.0,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  children: [
                    CheckboxListTile(
                      activeColor: Colors.indigo,
                      onChanged: (bool? value) {},
                      title: Text(AppLocalizations.of(context)!.commonHouse,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      value: false,
                    ),
                    CheckboxListTile(
                      activeColor: Colors.indigo,
                      onChanged: (bool? value) {},
                      title: Text(AppLocalizations.of(context)!.virtualTour,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      value: false,
                    ),
                    CheckboxListTile(
                      activeColor: Colors.indigo,
                      onChanged: (bool? value) {},
                      title: Text(AppLocalizations.of(context)!.availableNow,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      value: false,
                    ),
                    CheckboxListTile(
                      activeColor: Colors.indigo,
                      onChanged: (bool? value) {},
                      title: Text("R+",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      value: false,
                    ),
                  ],
                ),
              ),
              Container(width: double.infinity, height: 40.0, color: Colors.grey[200],
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      _showMore = !_showMore;
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(AppLocalizations.of(context)!.moreFilter,
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.placeholderGrey),
                      ), SizedBox(width: 10.0,), Icon( _showMore == true ? Icons.keyboard_arrow_down : Icons.arrow_forward_ios, size: 15,),
                    ],
                  ),
                ),
              ),
              _showMore == true ?
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 4.0,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: [
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.water),
                    value: true,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.garden),
                    value: false,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.power),
                    value: true,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.store),
                    value: false,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.internalKitchen),
                    value: false,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.internalBathroom),
                    value: false,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.pool),
                    value: false,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.parking),
                    value: false,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.paved),
                    value: false,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.paved),
                    value: false,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.trees),
                    value: false,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.flowers),
                    value: false,
                  ),
                ],
              ) : Container(),
            ],
          ),
        ),),
      ),
    );
  }
}
