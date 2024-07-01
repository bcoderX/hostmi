import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/core/app_export.dart';

class SliderarrowleftItemWidget extends StatelessWidget {
  const SliderarrowleftItemWidget({
    super.key,
    required this.imageUrl,
    required this.house,
    required this.index,
  });
  final String imageUrl;
  final HouseModel house;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: getSize(
          343,
        ),
        width: double.infinity,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              height: getSize(343),
              width: double.infinity,
              alignment: Alignment.center,
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: getPadding(
                  left: 24,
                  top: 24,
                  right: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: getPadding(
                        bottom: 1,
                      ),
                      child: Text(
                        index == 0
                            ? "${house.houseType!.fr!} - ${house.houseCategory!.fr!}"
                            : "",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtManropeExtraBold24WhiteA700,
                      ),
                    ),
                    Padding(
                      padding: getPadding(bottom: 30),
                      child: Container(
                        color: Colors.black.withOpacity(.3),
                        padding: getPadding(all: 10),
                        child: Text(
                          index == 0
                              ? house.fullAddress!.isEmpty
                                  ? "${house.sector == 0 ? "" : "Secteur ${house.sector},"} ${house.city}, ${house.country!.fr}"
                                  : house.fullAddress!
                              : "${house.imagesUrl![index]["description"]}",
                          overflow: TextOverflow.ellipsis,
                          // textAlign: TextAlign.left,
                          style: AppStyle.txtManropeMedium14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
