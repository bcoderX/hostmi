import 'package:flutter/material.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/theme/app_style.dart';
import 'package:hostmi/ui/screens/agency_screen/widgets/review_dialog_widget.dart';
import 'package:hostmi/widgets/reviews_list.dart';

class AgencyReviews extends StatefulWidget {
  const AgencyReviews({super.key, required this.agencyId});
  final String agencyId;

  @override
  State<AgencyReviews> createState() => _AgencyReviewsState();
}

class _AgencyReviewsState extends State<AgencyReviews> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: getPadding(left: 8, top: 14),
            child: Row(children: [
              Text("Note: 4.9",
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
                  child: Text("100 avis",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtManropeMedium12Gray900
                          .copyWith(letterSpacing: getHorizontalSize(0.4))))
            ])),
        Wrap(
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
                // Fluttertoast.showToast(
                //     msg: "This is Center Short Toast",
                //     toastLength: Toast.LENGTH_SHORT,
                //     gravity: ToastGravity.CENTER,
                //     timeInSecForIosWeb: 1,
                //     backgroundColor: Colors.red,
                //     textColor: Colors.white,
                //     fontSize: 16.0);
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
                      Text(
                          "Aider les chercheurs de maisons à faire le bon choix",
                          style: AppStyle.txtManrope12),
                    ],
                  ),
                  content: ReviewDialogWidget(
                    agencyId: widget.agencyId,
                  )),
            ],
          ),
        );
      },
    );
  }
}
