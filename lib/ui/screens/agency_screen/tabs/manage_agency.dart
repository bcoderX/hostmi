import 'package:flutter/widgets.dart';

class ManageAgency extends StatelessWidget {
  const ManageAgency({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24.0),
      child: Text(
        "Vous aurez bientôt plus d'options pour gérer vos maisons et votre agence.",
        textAlign: TextAlign.center,
      ),
    );
  }
}
