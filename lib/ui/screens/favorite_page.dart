import 'package:flutter/material.dart';
import 'package:hostmi/utils/app_color.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.grey,
      child: const Center(
        child: Text("Favorites"),
      ),
    );
  }
}
