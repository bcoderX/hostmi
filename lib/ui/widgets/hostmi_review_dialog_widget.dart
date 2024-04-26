import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hostmi/api/supabase/rest/agencies/reviews/insert_new_hostmi_review.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HostmiReviewDialogWidget extends StatefulWidget {
  const HostmiReviewDialogWidget({super.key});

  @override
  State<HostmiReviewDialogWidget> createState() =>
      _HostmiReviewDialogWidgetState();
}

class _HostmiReviewDialogWidgetState extends State<HostmiReviewDialogWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  double _rate = 5;
  bool _isSaving = false;
  bool _isSaved = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _isSaved
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.greenAccent,
                    size: getSize(130),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Merci pour votre avis !"),
                  )
                ],
              )
            : Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                        "Quel sentiment exprouvez-vous en utilisant HostMI ?"),
                    RatingBar.builder(
                      initialRating: 5,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemSize: 30,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return const Icon(
                              Icons.sentiment_very_dissatisfied,
                              color: Colors.red,
                            );
                          case 1:
                            return const Icon(
                              Icons.sentiment_dissatisfied,
                              color: Colors.redAccent,
                            );
                          case 2:
                            return const Icon(
                              Icons.sentiment_neutral,
                              color: Colors.amber,
                            );
                          case 3:
                            return const Icon(
                              Icons.sentiment_satisfied,
                              color: Colors.lightGreen,
                            );
                          case 4:
                            return const Icon(
                              Icons.sentiment_very_satisfied,
                              color: Colors.green,
                            );
                        }
                        return const SizedBox();
                      },
                      onRatingUpdate: (rating) {
                        _rate = rating;
                        // print(rating);
                      },
                    ),
                    CustomTextFormField(
                      controller: _nameController,
                      hintText: "Nom complet",
                      margin: getMargin(top: 13),
                      textInputType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Champ obligatoire";
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      controller: _contactController,
                      hintText: "Email ou téléphone(inclure l'indicatif)..",
                      margin: getMargin(top: 13),
                      textInputType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Champ obligatoire";
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      controller: _commentController,
                      hintText: "Ecrivez votre avis ou votre suggestion ici...",
                      margin: getMargin(top: 13),
                      maxLines: 4,
                      textInputType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Champ obligatoire";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSaving
                            ? () {}
                            : () async {
                                // Navigator.of(context).pop();
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isSaving = true;
                                  });

                                  final response = await insertNewHostmiReview({
                                    "user_id": supabase.auth.currentUser == null
                                        ? null
                                        : supabase.auth.currentUser!.id,
                                    "stars": _rate,
                                    "full_name": _nameController.text.trim(),
                                    "comment": _commentController.text.trim(),
                                    "contact": _contactController.text.trim()
                                  });
                                  if (response.isSuccess) {
                                    if (response.list!.isNotEmpty) {
                                      setState(() {
                                        _isSaved = true;
                                      });
                                    }
                                  }
                                  setState(() {
                                    _isSaving = false;
                                  });
                                }
                              },
                        child: _isSaving
                            ? LoadingAnimationWidget.threeArchedCircle(
                                color: AppColor.white,
                                size: getSize(25),
                              )
                            : const Text("Envoyer"),
                      ),
                    ),
                  ],
                ),
              ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.grey,
                  foregroundColor: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Fermer")),
        )
      ],
    );
  }
}
