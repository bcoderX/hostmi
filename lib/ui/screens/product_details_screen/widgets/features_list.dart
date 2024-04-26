import 'package:flutter/material.dart';
import 'package:hostmi/api/supabase/rest/houses/select_features.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/ui/screens/add_new_property_screens/add_new_property_select_amenities_screen/widgets/options_item_widget.dart';
import 'package:hostmi/ui/screens/loading_page.dart';
import 'package:hostmi/utils/app_color.dart';

class FeaturesListWidget extends StatefulWidget {
  const FeaturesListWidget({super.key, required this.featuresIDs});
  final List<dynamic> featuresIDs;

  @override
  State<FeaturesListWidget> createState() => _FeaturesListWidgetState();
}

class _FeaturesListWidgetState extends State<FeaturesListWidget> {
  late Future<List<Map<String, dynamic>>> _featuresFuture;
  @override
  void initState() {
    _featuresFuture = getFeatures(widget.featuresIDs);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getPadding(top: 15, bottom: 5),
      child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _featuresFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox(
                height: 100,
                width: double.infinity,
                child: BallLoadingPage(
                  loadingTitle: "Chargement des détails...",
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Error: ${snapshot.error}"),
                  IconButton(
                      onPressed: () {
                        _featuresFuture = getFeatures(widget.featuresIDs);
                      },
                      icon: const Icon(
                        Icons.replay_circle_filled_rounded,
                        size: 40,
                        color: AppColor.primary,
                      ))
                ],
              ));
            }
            if (!snapshot.hasData) {
              return const Center(child: Text("Error"));
            }

            if (snapshot.data!.isEmpty) {
              return const Text("Pas de caracteristiques");
            }
            List<Map<String, dynamic>> features = snapshot.data!;
            return Wrap(
              runSpacing: getVerticalSize(5),
              spacing: getHorizontalSize(5),
              children: features
                  .map((feature) => OptionsItemWidget(
                        amenity: feature,
                        selected: const [],
                        onPressed: () {},
                      ))
                  .toList(),
            );
          }),
    );
  }

  Future<List<Map<String, dynamic>>> getFeatures(List<dynamic> features) async {
    final featuresList = await loadHouseFeaturesByIds(features);
    return featuresList;
    // setState(() {});
  }
}
