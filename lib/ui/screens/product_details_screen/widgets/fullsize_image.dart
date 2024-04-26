import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/utils/app_color.dart';

class FullSizeImage extends StatelessWidget {
  const FullSizeImage({super.key, required this.images});
  final List<dynamic> images;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              width: double.infinity,
              height: screen.height,
              child: PageView.builder(
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {},
                            child: InteractiveViewer(
                              panEnabled: false,
                              child: CachedNetworkImage(
                                width: double.infinity,
                                imageUrl: supabase.storage
                                    .from("agencies")
                                    .getPublicUrl(images[index]["image_url"]
                                        .toString()
                                        .replaceFirst("agencies/", "")),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                          child: Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: getPadding(all: 20),
                            width: double.infinity,
                            color: Colors.black.withOpacity(.3),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  images[index]["description"].toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                    images.length,
                                    (pIndex) {
                                      return Container(
                                        margin: getMargin(right: 10, top: 10),
                                        width: index == pIndex ? 15 : 7.5,
                                        height: index == pIndex ? 15 : 7.5,
                                        decoration: BoxDecoration(
                                          color: index == pIndex
                                              ? AppColor.primary
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              index == pIndex ? 7.5 : 4),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))
                    ],
                  );
                },
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
