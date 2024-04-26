import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostmi/api/supabase/rest/agencies/reviews/get_avg_rate.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/theme/app_style.dart';
import 'package:hostmi/ui/screens/agency_screen/widgets/agency_review_dialog_widget.dart';
import 'package:hostmi/widgets/reviews_list.dart';

class AgencyReviews extends StatefulWidget {
  const AgencyReviews(
      {super.key, required this.agencyId, this.isManager = false});
  final String agencyId;
  final bool isManager;

  @override
  State<AgencyReviews> createState() => _AgencyReviewsState();
}

class _AgencyReviewsState extends State<AgencyReviews> {
  late Future<List<dynamic>> _agencyFuture;

  @override
  void initState() {
    _agencyFuture = getAgencyAvgRate(widget.agencyId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: getPadding(left: 8, top: 14),
          child: FutureBuilder<List<dynamic>>(
            future: _agencyFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                debugPrint(snapshot.error.toString());
              }
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Row(children: [
                  Text("Note: ${snapshot.data!.first['stars']}",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtManropeBold18
                          .copyWith(letterSpacing: getHorizontalSize(0.2))),
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  Padding(
                      padding: getPadding(left: 14, top: 15, bottom: 11),
                      child: Text(
                          "${snapshot.data!.first['reviews_count']} avis",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtManropeMedium12Gray900
                              .copyWith(letterSpacing: getHorizontalSize(0.4))))
                ]);
              }
              return Row(children: [
                Text("Note: --",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtManropeBold18
                        .copyWith(letterSpacing: getHorizontalSize(0.2))),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                Padding(
                    padding: getPadding(left: 14, top: 15, bottom: 11),
                    child: Text("-- avis",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtManropeMedium12Gray900
                            .copyWith(letterSpacing: getHorizontalSize(0.4))))
              ]);
            },
          ),
        ),
        widget.isManager
            ? const SizedBox()
            : Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      _showRatingDialog();
                    },
                    icon: const Icon(Icons.edit_note_outlined),
                    label: const Text("Donner mon avis"),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Fluttertoast.showToast(
                        msg: "Cette fonctionnalité sera disponible dans la prochaine mise à jour",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    },
                    icon: const Icon(Icons.record_voice_over_outlined),
                    label: const Text("Signaler"),
                  ),
                ],
              ),
        ReviewList(agencyId: widget.agencyId),
      ],
    );
  }

  _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              AlertDialog(
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Donner votre avis"),
                    Text("Aider les chercheurs de maisons à faire le bon choix",
                        style: AppStyle.txtManrope12),
                  ],
                ),
                content: AgencyReviewDialogWidget(
                  agencyId: widget.agencyId,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
