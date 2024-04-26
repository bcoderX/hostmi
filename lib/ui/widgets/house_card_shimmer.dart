import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/utils/app_color.dart';

class HouseCardShimmer extends StatelessWidget {
  const HouseCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
            borderRadius: BorderRadius.circular(10.0),
            elevation: 1.0,
            color: Colors.grey,
            child: SizedBox(
              width: double.infinity,
              height: getVerticalSize(150),
            )),
        Container(
          height: getVerticalSize(125),
          width: getHorizontalSize(400),
          color: AppColor.white.withOpacity(.7),
          child: Padding(
            padding: getPadding(all: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height: getVerticalSize(10),
                        margin: const EdgeInsets.only(right: 50),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.grey[400],
                        ),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.grey[400],
                        ),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.grey[400],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: getVerticalSize(16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: getVerticalSize(10),
                      width: 100,
                      color: Colors.grey[400],
                    ),
                    Container(
                      height: getVerticalSize(10),
                      width: 100,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
                SizedBox(
                  height: getVerticalSize(16),
                ),
                Container(
                  height: getVerticalSize(10),
                  width: double.infinity,
                  color: Colors.grey[400],
                ),
                SizedBox(
                  height: getVerticalSize(16),
                ),
                Row(
                  children: [
                    Container(
                      height: getVerticalSize(10),
                      width: 100,
                      color: Colors.grey[400],
                    ),
                    const Expanded(child: SizedBox()),
                    Container(
                      height: getVerticalSize(10),
                      width: 100,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: getVerticalSize(10)),
        Container(
            width: double.infinity,
            height: getVerticalSize(30),
            color: AppColor.grey),
        SizedBox(height: getVerticalSize(10)),
      ],
    );
  }
}
