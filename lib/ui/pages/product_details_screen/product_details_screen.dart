import 'package:hostmi/ui/pages/chat_page.dart';
import 'package:hostmi/ui/pages/message_page/message_page.dart';
import 'package:hostmi/utils/app_color.dart';

import '../product_details_screen/widgets/listdate_item_widget.dart';
import '../product_details_screen/widgets/listfive_item_widget.dart';
import '../product_details_screen/widgets/listrectangle4224_item_widget.dart';
import '../product_details_screen/widgets/sliderarrowleft_item_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/widgets/custom_button.dart';
import 'package:hostmi/widgets/custom_icon_button.dart';
import 'package:hostmi/widgets/custom_radio_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int silderIndex = 1;
  final ScrollController _scrollController = ScrollController();
  double _opacity = 0;
  double _scrollPosition = 0;
  String radioGroup = "";

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.gray50,
            body: Scrollbar(
                child: Stack(
              children: [
                SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        SizedBox(
                            width: double.infinity,
                            child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  CarouselSlider.builder(
                                      options: CarouselOptions(
                                          height: getSize(343),
                                          initialPage: 0,
                                          autoPlay: true,
                                          viewportFraction: 1.0,
                                          enableInfiniteScroll: false,
                                          scrollDirection: Axis.horizontal,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              silderIndex = index;
                                            });
                                          }),
                                      itemCount: 2,
                                      itemBuilder: (context, index, realIndex) {
                                        return SliderarrowleftItemWidget();
                                      }),
                                  Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                          height: getVerticalSize(3),
                                          margin: getMargin(bottom: 16),
                                          child: AnimatedSmoothIndicator(
                                              activeIndex: silderIndex,
                                              count: 2,
                                              axisDirection: Axis.horizontal,
                                              effect: ScrollingDotsEffect(
                                                  spacing: 4,
                                                  activeDotColor:
                                                      ColorConstant.brown500,
                                                  dotColor:
                                                      ColorConstant.gray30099,
                                                  dotHeight: getVerticalSize(3),
                                                  dotWidth:
                                                      getHorizontalSize(16)))))
                                ])),
                        Padding(
                            padding: getPadding(
                                left: 16, right: 16, top: 33, bottom: 5),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: getPadding(left: 8, top: 34),
                                      child: Text("Description",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtManropeBold18
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2)))),
                                  Padding(
                                      padding: getPadding(
                                          left: 8, top: 13, right: 39),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomIconButton(
                                                height: 34,
                                                width: 34,
                                                variant: IconButtonVariant
                                                    .FillBlue500,
                                                shape: IconButtonShape
                                                    .RoundedBorder5,
                                                child: CustomImageView(
                                                    svgPath: ImageConstant
                                                        .imgIcon20x20)),
                                            Padding(
                                                padding: getPadding(left: 2),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text("Bathroom",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: AppStyle
                                                              .txtManrope10
                                                              .copyWith(
                                                                  letterSpacing:
                                                                      getHorizontalSize(
                                                                          0.4))),
                                                      Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Padding(
                                                              padding:
                                                                  getPadding(
                                                                      top: 1),
                                                              child: Text(
                                                                  "2 Rooms",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: AppStyle
                                                                      .txtManropeBold12
                                                                      .copyWith(
                                                                          letterSpacing:
                                                                              getHorizontalSize(0.4)))))
                                                    ])),
                                            CustomIconButton(
                                                height: 34,
                                                width: 34,
                                                margin: getMargin(left: 5),
                                                variant: IconButtonVariant
                                                    .FillBlue500,
                                                shape: IconButtonShape
                                                    .RoundedBorder5,
                                                child: CustomImageView(
                                                    svgPath: ImageConstant
                                                        .imgLock20x20)),
                                            Padding(
                                                padding: getPadding(left: 1),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text("Bedroom",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: AppStyle
                                                              .txtManrope10
                                                              .copyWith(
                                                                  letterSpacing:
                                                                      getHorizontalSize(
                                                                          0.4))),
                                                      Padding(
                                                          padding: getPadding(
                                                              top: 1),
                                                          child: Text("3 Rooms",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: AppStyle
                                                                  .txtManropeBold12
                                                                  .copyWith(
                                                                      letterSpacing:
                                                                          getHorizontalSize(
                                                                              0.4))))
                                                    ])),
                                            CustomIconButton(
                                                height: 34,
                                                width: 34,
                                                margin: getMargin(left: 5),
                                                variant: IconButtonVariant
                                                    .FillBlue500,
                                                shape: IconButtonShape
                                                    .RoundedBorder5,
                                                child: CustomImageView(
                                                    svgPath: ImageConstant
                                                        .imgOffer20x20)),
                                            Padding(
                                                padding:
                                                    getPadding(left: 8, top: 2),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text("Square",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: AppStyle
                                                              .txtManrope10
                                                              .copyWith(
                                                                  letterSpacing:
                                                                      getHorizontalSize(
                                                                          0.4))),
                                                      Padding(
                                                          padding: getPadding(
                                                              top: 1),
                                                          child: Text(
                                                              "1,880 Ft",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: AppStyle
                                                                  .txtManropeBold12
                                                                  .copyWith(
                                                                      letterSpacing:
                                                                          getHorizontalSize(
                                                                              0.4))))
                                                    ]))
                                          ])),
                                  Padding(
                                      padding: getPadding(left: 8, top: 31),
                                      child: Text("About",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtManropeBold18
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2)))),
                                  Container(
                                      width: getHorizontalSize(327),
                                      margin: getMargin(
                                          left: 8, top: 13, right: 39),
                                      child: Text(
                                          "Casablanca Ground is located in Malang City which is not far from the city center. This house was made in 2012 with a minimalist and modern architecture suitable for families.",
                                          maxLines: null,
                                          textAlign: TextAlign.justify,
                                          style: AppStyle
                                              .txtManropeRegular14Gray900)),
                                  Padding(
                                      padding: getPadding(left: 8, top: 13),
                                      child: Row(children: [
                                        Text("See More",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeBold14Blue500
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.2))),
                                        CustomImageView(
                                            svgPath: ImageConstant
                                                .imgArrowright16x16,
                                            height: getSize(16),
                                            width: getSize(16),
                                            margin: getMargin(
                                                left: 8, top: 1, bottom: 2))
                                      ])),
                                  Padding(
                                      padding: getPadding(
                                          left: 8, top: 34, bottom: 13),
                                      child: Text("Gallery",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtManropeBold18
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2)))),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(children: [
                                      CustomImageView(
                                          imagePath: ImageConstant.img1,
                                          height: getVerticalSize(130),
                                          width: getHorizontalSize(100)),
                                      Container(
                                          height: getVerticalSize(130),
                                          width: getHorizontalSize(99),
                                          margin: getMargin(left: 14),
                                          child: Stack(
                                              alignment: Alignment.topLeft,
                                              children: [
                                                CustomImageView(
                                                    imagePath: ImageConstant
                                                        .imgImg130x991,
                                                    height:
                                                        getVerticalSize(130),
                                                    width:
                                                        getHorizontalSize(99),
                                                    radius:
                                                        BorderRadius.circular(
                                                            getHorizontalSize(
                                                                5)),
                                                    alignment:
                                                        Alignment.center),
                                                CustomImageView(
                                                    svgPath: ImageConstant
                                                        .imgVuesaxboldvideocircle,
                                                    height: getSize(24),
                                                    width: getSize(24),
                                                    alignment:
                                                        Alignment.topLeft,
                                                    margin: getMargin(
                                                        left: 36, top: 51))
                                              ])),
                                      Container(
                                          height: getVerticalSize(130),
                                          width: getHorizontalSize(100),
                                          margin: getMargin(left: 14),
                                          child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                CustomImageView(
                                                    imagePath: ImageConstant
                                                        .imgBg130x100,
                                                    height:
                                                        getVerticalSize(130),
                                                    width:
                                                        getHorizontalSize(100),
                                                    radius:
                                                        BorderRadius.circular(
                                                            getHorizontalSize(
                                                                5)),
                                                    alignment:
                                                        Alignment.center),
                                                Align(
                                                    alignment: Alignment.center,
                                                    child: Text("+12",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: AppStyle
                                                            .txtManropeExtraBold18Gray300
                                                            .copyWith(
                                                                letterSpacing:
                                                                    getHorizontalSize(
                                                                        0.2))))
                                              ]))
                                    ]),
                                  ),
                                  Padding(
                                      padding: getPadding(left: 8, top: 32),
                                      child: Text("Location",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtManropeBold18
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2)))),
                                  Container(
                                      height: getVerticalSize(152),
                                      width: getHorizontalSize(327),
                                      margin: getMargin(left: 8, top: 15),
                                      child: Stack(
                                          alignment: Alignment.topLeft,
                                          children: [
                                            CustomImageView(
                                                imagePath: ImageConstant
                                                    .imgMapsiclemap152x3271,
                                                height: getVerticalSize(152),
                                                width: getHorizontalSize(327),
                                                radius: BorderRadius.circular(
                                                    getHorizontalSize(16)),
                                                alignment: Alignment.center),
                                            CustomImageView(
                                                svgPath:
                                                    ImageConstant.imgEye80x80,
                                                height: getSize(80),
                                                width: getSize(80),
                                                alignment: Alignment.topLeft,
                                                margin: getMargin(
                                                    left: 93, top: 31))
                                          ])),
                                  Container(
                                      margin:
                                          getMargin(left: 8, top: 32, right: 8),
                                      padding: getPadding(all: 24),
                                      decoration: AppDecoration.outlineGray3002
                                          .copyWith(
                                              borderRadius: BorderRadiusStyle
                                                  .roundedBorder10),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                                padding: getPadding(top: 3),
                                                child: Text(
                                                    "Contact to Buyer’s Agent",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeBold16
                                                        .copyWith(
                                                            letterSpacing:
                                                                getHorizontalSize(
                                                                    0.2)))),
                                            Padding(
                                                padding: getPadding(
                                                    top: 22, right: 36),
                                                child: Row(children: [
                                                  CustomImageView(
                                                      imagePath: ImageConstant
                                                          .imgBg48x48,
                                                      height: getSize(48),
                                                      width: getSize(48),
                                                      margin:
                                                          getMargin(bottom: 1)),
                                                  Expanded(
                                                      child: Padding(
                                                          padding: getPadding(
                                                              left: 16, top: 1),
                                                          child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    "Aristide Somé",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: AppStyle
                                                                        .txtManropeBold16
                                                                        .copyWith(
                                                                            letterSpacing:
                                                                                getHorizontalSize(0.2))),
                                                                Padding(
                                                                    padding:
                                                                        getPadding(
                                                                            top:
                                                                                6),
                                                                    child: Text(
                                                                        "Hostmi",
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .left,
                                                                        style: AppStyle
                                                                            .txtManropeMedium14Bluegray500))
                                                              ])))
                                                ])),
                                            Padding(
                                                padding: getPadding(top: 30),
                                                child: Row(children: [
                                                  CustomButton(
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    ChatPage()));
                                                      },
                                                      height:
                                                          getVerticalSize(45),
                                                      width: getHorizontalSize(
                                                          115),
                                                      text: "Message",
                                                      variant: ButtonVariant
                                                          .FillBluegray50,
                                                      shape: ButtonShape
                                                          .RoundedBorder5,
                                                      padding: ButtonPadding
                                                          .PaddingT10,
                                                      fontStyle: ButtonFontStyle
                                                          .ManropeSemiBold14Bluegray500_1,
                                                      prefixWidget: Container(
                                                          margin: getMargin(
                                                              right: 12),
                                                          child: CustomImageView(
                                                              svgPath: ImageConstant
                                                                  .imgCommentBold24px))),
                                                  CustomButton(
                                                      height:
                                                          getVerticalSize(45),
                                                      width: getHorizontalSize(
                                                          115),
                                                      text: "Phone",
                                                      margin:
                                                          getMargin(left: 10),
                                                      variant: ButtonVariant
                                                          .FillBluegray50,
                                                      shape: ButtonShape
                                                          .RoundedBorder5,
                                                      padding: ButtonPadding
                                                          .PaddingT10,
                                                      fontStyle: ButtonFontStyle
                                                          .ManropeSemiBold14Bluegray500_1,
                                                      prefixWidget: Container(
                                                          margin: getMargin(
                                                              right: 12),
                                                          child: CustomImageView(
                                                              svgPath: ImageConstant
                                                                  .imgCall20x20)))
                                                ])),
                                            CustomButton(
                                                height: getVerticalSize(45),
                                                text: "Ask a question",
                                                margin: getMargin(top: 12),
                                                variant: ButtonVariant
                                                    .FillBluegray50,
                                                shape:
                                                    ButtonShape.RoundedBorder5,
                                                padding:
                                                    ButtonPadding.PaddingT10,
                                                fontStyle: ButtonFontStyle
                                                    .ManropeSemiBold14Bluegray500_1,
                                                prefixWidget: Container(
                                                    margin:
                                                        getMargin(right: 10),
                                                    child: CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgQuestion)))
                                          ])),
                                  Padding(
                                      padding: getPadding(
                                        top: 34,
                                      ),
                                      child: Row(children: [
                                        Text("Key Details",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtManropeBold18
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.2))),
                                        Padding(
                                            padding: getPadding(
                                                left: 30, top: 2, bottom: 2),
                                            child: Text(
                                                "Update: 07/07/2022 5:00 PM",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle
                                                    .txtManropeRegular14Gray900))
                                      ])),
                                  Padding(
                                      padding: getPadding(left: 8, top: 21),
                                      child: Text("Price Insights",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtManropeBold16
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2)))),
                                  Padding(
                                      padding: getPadding(left: 8, top: 11),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("List Price",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle
                                                    .txtManropeRegular14Gray900),
                                            Padding(
                                                padding: getPadding(left: 200),
                                                child: Text("3.000",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeSemiBold14Gray900))
                                          ])),
                                  Padding(
                                      padding: getPadding(left: 8, top: 12),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                                padding: getPadding(top: 1),
                                                child: Text("Est, Mo, Payment",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeRegular14Gray900)),
                                            Padding(
                                                padding: getPadding(
                                                    left: 150, bottom: 1),
                                                child: Text("15.000",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeSemiBold14Gray900))
                                          ])),
                                  Padding(
                                      padding: getPadding(left: 8, top: 11),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Relax Estimate",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle
                                                    .txtManropeRegular14Gray900),
                                            Padding(
                                                padding: getPadding(left: 160),
                                                child: Text("3.000",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeSemiBold14Gray900))
                                          ])),
                                  Padding(
                                      padding: getPadding(left: 8, top: 13),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                                padding: getPadding(top: 1),
                                                child: Text("Price/Sq. Ft",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeRegular14Gray900)),
                                            Padding(
                                                padding: getPadding(
                                                    left: 220, bottom: 1),
                                                child: Text("-",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeSemiBold14Gray900))
                                          ])),
                                  Padding(
                                      padding: getPadding(left: 8, top: 19),
                                      child: Text("Home Facts",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtManropeBold16
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2)))),
                                  Padding(
                                      padding: getPadding(
                                        left: 8,
                                        top: 13,
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                                padding: getPadding(bottom: 1),
                                                child: Text("On Market",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeRegular14Gray900)),
                                            Padding(
                                                padding: getPadding(
                                                    left: 180, top: 1),
                                                child: Text("30 days",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeSemiBold14Gray900))
                                          ])),
                                  Padding(
                                      padding: getPadding(left: 8, top: 11),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                                padding: getPadding(top: 1),
                                                child: Text("Community",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeRegular14Gray900)),
                                            Padding(
                                                padding: getPadding(
                                                    left: 140, bottom: 1),
                                                child: Text("San Francisco",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeSemiBold14Gray900))
                                          ])),
                                  Padding(
                                      padding: getPadding(left: 8, top: 11),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                                padding: getPadding(top: 1),
                                                child: Text("Country",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeRegular14Gray900)),
                                            Padding(
                                                padding: getPadding(
                                                    left: 160, bottom: 1),
                                                child: Text("San Francisco",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeSemiBold14Gray900))
                                          ])),
                                  Padding(
                                      padding: getPadding(left: 8, top: 11),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("MLS#",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle
                                                    .txtManropeRegular14Gray900),
                                            Padding(
                                                padding: getPadding(left: 180),
                                                child: Text("42212314554",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeSemiBold14Gray900))
                                          ])),
                                  Padding(
                                      padding: getPadding(left: 8, top: 12),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Built",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle
                                                    .txtManropeRegular14Gray900),
                                            Padding(
                                                padding: getPadding(left: 240),
                                                child: Text("1992",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeSemiBold14Gray900))
                                          ])),
                                  Padding(
                                      padding: getPadding(left: 8, top: 13),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                                padding: getPadding(bottom: 1),
                                                child: Text("Lot Size",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeRegular14Gray900)),
                                            Padding(
                                                padding: getPadding(
                                                    left: 142, top: 1),
                                                child: Text("3.400 square feet",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeSemiBold14Gray900))
                                          ])),
                                  Padding(
                                      padding: getPadding(left: 8, top: 15),
                                      child: Row(children: [
                                        Text("See More",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeBold14Blue500
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.2))),
                                        CustomImageView(
                                            svgPath: ImageConstant
                                                .imgArrowright16x16,
                                            height: getSize(16),
                                            width: getSize(16),
                                            margin: getMargin(
                                                left: 8, top: 1, bottom: 2))
                                      ])),
                                  Padding(
                                      padding: getPadding(top: 24),
                                      child: Divider(
                                          height: getVerticalSize(1),
                                          thickness: getVerticalSize(1),
                                          color: ColorConstant.gray300,
                                          indent: getHorizontalSize(8),
                                          endIndent: getHorizontalSize(39))),
                                  Padding(
                                      padding: getPadding(left: 8, top: 25),
                                      child: Text("Popular Amenities",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtManropeBold18
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2)))),
                                  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      padding: getPadding(left: 11, top: 21),
                                      child: IntrinsicWidth(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  CustomImageView(
                                                      svgPath: ImageConstant
                                                          .imgIconGray900,
                                                      height: getSize(24),
                                                      width: getSize(24)),
                                                  Padding(
                                                      padding:
                                                          getPadding(top: 10),
                                                      child: Text("Sunning",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: AppStyle
                                                              .txtManropeSemiBold12
                                                              .copyWith(
                                                                  letterSpacing:
                                                                      getHorizontalSize(
                                                                          0.4))))
                                                ]),
                                            Padding(
                                                padding: getPadding(
                                                    left: 22, bottom: 1),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      CustomImageView(
                                                          svgPath: ImageConstant
                                                              .imgSignal,
                                                          height: getSize(24),
                                                          width: getSize(24)),
                                                      Padding(
                                                          padding: getPadding(
                                                              top: 9),
                                                          child: Text(
                                                              "Free Wifi",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: AppStyle
                                                                  .txtManropeSemiBold12
                                                                  .copyWith(
                                                                      letterSpacing:
                                                                          getHorizontalSize(
                                                                              0.4))))
                                                    ])),
                                            Padding(
                                                padding: getPadding(
                                                    left: 18, bottom: 1),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      CustomImageView(
                                                          svgPath: ImageConstant
                                                              .imgAlarm,
                                                          height: getSize(24),
                                                          width: getSize(24)),
                                                      Padding(
                                                          padding: getPadding(
                                                              top: 9),
                                                          child: Text(
                                                              "Restaurant",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: AppStyle
                                                                  .txtManropeSemiBold12
                                                                  .copyWith(
                                                                      letterSpacing:
                                                                          getHorizontalSize(
                                                                              0.4))))
                                                    ])),
                                            Padding(
                                                padding: getPadding(
                                                    left: 33, bottom: 1),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      CustomImageView(
                                                          svgPath: ImageConstant
                                                              .imgIcon24x24,
                                                          height: getSize(24),
                                                          width: getSize(24)),
                                                      Padding(
                                                          padding: getPadding(
                                                              top: 9),
                                                          child: Text("Bar",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: AppStyle
                                                                  .txtManropeSemiBold12
                                                                  .copyWith(
                                                                      letterSpacing:
                                                                          getHorizontalSize(
                                                                              0.4))))
                                                    ])),
                                            Padding(
                                                padding: getPadding(
                                                    left: 36, bottom: 1),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      CustomImageView(
                                                          svgPath: ImageConstant
                                                              .imgClock1,
                                                          height: getSize(24),
                                                          width: getSize(24)),
                                                      Padding(
                                                          padding: getPadding(
                                                              top: 9),
                                                          child: Text(
                                                              "Business ",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: AppStyle
                                                                  .txtManropeSemiBold12
                                                                  .copyWith(
                                                                      letterSpacing:
                                                                          getHorizontalSize(
                                                                              0.4))))
                                                    ]))
                                          ]))),
                                  Padding(
                                      padding: getPadding(left: 8, top: 15),
                                      child: Row(children: [
                                        Text("All Amenities",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeBold14Blue500
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.2))),
                                        CustomImageView(
                                            svgPath: ImageConstant
                                                .imgArrowright16x16,
                                            height: getSize(16),
                                            width: getSize(16),
                                            margin: getMargin(
                                                left: 14, top: 1, bottom: 2))
                                      ])),
                                  Padding(
                                      padding: getPadding(top: 24),
                                      child: Divider(
                                          height: getVerticalSize(1),
                                          thickness: getVerticalSize(1),
                                          color: ColorConstant.gray300,
                                          indent: getHorizontalSize(8),
                                          endIndent: getHorizontalSize(39))),
                                  Padding(
                                      padding: getPadding(
                                        top: 23,
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Reviews",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle.txtManropeBold18
                                                    .copyWith(
                                                        letterSpacing:
                                                            getHorizontalSize(
                                                                0.2))),
                                            Padding(
                                                padding: getPadding(
                                                    top: 4, bottom: 3),
                                                child: Text("View all Reviews",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeBold12Blue500
                                                        .copyWith(
                                                            letterSpacing:
                                                                getHorizontalSize(
                                                                    0.4))))
                                          ])),
                                  Padding(
                                      padding: getPadding(left: 8, top: 14),
                                      child: Row(children: [
                                        Text("4.9",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtManropeBold32
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.2))),
                                        CustomImageView(
                                            svgPath: ImageConstant.imgTicket,
                                            height: getVerticalSize(15),
                                            width: getHorizontalSize(96),
                                            margin: getMargin(
                                                left: 12, top: 13, bottom: 14)),
                                        Padding(
                                            padding: getPadding(
                                                left: 14, top: 15, bottom: 11),
                                            child: Text("100 ratings",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle
                                                    .txtManropeMedium12Gray900
                                                    .copyWith(
                                                        letterSpacing:
                                                            getHorizontalSize(
                                                                0.4))))
                                      ])),
                                  Padding(
                                      padding: getPadding(
                                        left: 8,
                                        top: 6,
                                      ),
                                      child: ListView.separated(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          separatorBuilder: (context, index) {
                                            return SizedBox(
                                                height: getVerticalSize(3));
                                          },
                                          itemCount: 5,
                                          itemBuilder: (context, index) {
                                            return ListfiveItemWidget();
                                          })),
                                  Padding(
                                      padding: getPadding(top: 24),
                                      child: Divider(
                                          height: getVerticalSize(1),
                                          thickness: getVerticalSize(1),
                                          color: ColorConstant.gray300,
                                          indent: getHorizontalSize(8),
                                          endIndent: getHorizontalSize(39))),
                                  Padding(
                                      padding: getPadding(left: 8, top: 18),
                                      child: CustomRadioButton(
                                          text:
                                              "Notify me when the price changes.",
                                          value:
                                              "Notify me when the price changes.",
                                          groupValue: radioGroup,
                                          margin: getMargin(left: 8, top: 18),
                                          fontStyle: RadioFontStyle
                                              .ManropeMedium14Gray900,
                                          onChange: (value) {
                                            radioGroup = value;
                                          })),
                                  Padding(
                                      padding: getPadding(left: 8, top: 23),
                                      child: Text("School",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtManropeBold18
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2)))),
                                  Padding(
                                      padding: getPadding(left: 8, top: 12),
                                      child: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "This home is within ",
                                                style: TextStyle(
                                                    color: ColorConstant
                                                        .blueGray500,
                                                    fontSize: getFontSize(14),
                                                    fontFamily: 'Manrope',
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            TextSpan(
                                                text: "Seattle Publics Schools",
                                                style: TextStyle(
                                                    color:
                                                        ColorConstant.brown500,
                                                    fontSize: getFontSize(14),
                                                    fontFamily: 'Manrope',
                                                    fontWeight:
                                                        FontWeight.w600))
                                          ]),
                                          textAlign: TextAlign.left)),
                                  Container(
                                      width: getHorizontalSize(300),
                                      margin: getMargin(
                                        left: 8,
                                        top: 9,
                                      ),
                                      child: Text(
                                          "Seattle’s enrollment criteria aren’t based solely\non geography. Please check the school district website to see all schools serving this home.",
                                          textAlign: TextAlign.justify,
                                          style: AppStyle.txtManropeRegular14)),
                                  Padding(
                                      padding: getPadding(
                                        top: 21,
                                      ),
                                      child: ListView.separated(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          separatorBuilder: (context, index) {
                                            return SizedBox(
                                                height: getVerticalSize(12));
                                          },
                                          itemCount: 3,
                                          itemBuilder: (context, index) {
                                            return Listrectangle4224ItemWidget();
                                          })),
                                  Padding(
                                      padding: getPadding(left: 8, top: 16),
                                      child: Row(children: [
                                        Text("Show 4 More",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeBold14Blue500
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.2))),
                                        CustomImageView(
                                            svgPath: ImageConstant
                                                .imgArrowright16x16,
                                            height: getSize(16),
                                            width: getSize(16),
                                            margin: getMargin(
                                                left: 8, top: 1, bottom: 2))
                                      ])),
                                ])),
                      ],
                    )),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    backgroundColor: ColorConstant.gray50.withOpacity(_opacity),
                    foregroundColor: AppColor.black,
                    elevation: 0.0,
                    title: Text("Détails"),
                  ),
                ),
              ],
            )),
            bottomNavigationBar: Container(
                padding: getPadding(left: 24, top: 13, right: 24, bottom: 13),
                decoration: AppDecoration.outlineBluegray1000f,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: getPadding(top: 2),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                    padding: getPadding(top: 4, bottom: 3),
                                    child: Text("Price:",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtManropeMedium14Gray900)),
                                Text("1.940.00",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtManropeExtraBold20Blue500
                                        .copyWith(
                                            letterSpacing:
                                                getHorizontalSize(0.2)))
                              ])),
                      Padding(
                          padding: getPadding(top: 15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomIconButton(
                                    height: 44,
                                    width: 44,
                                    margin: getMargin(top: 2, bottom: 2),
                                    variant:
                                        IconButtonVariant.OutlineBluegray50_1,
                                    padding: IconButtonPadding.PaddingAll12,
                                    child: CustomImageView(
                                        svgPath: ImageConstant.imgFavorite)),
                                CustomButton(
                                    height: getVerticalSize(48),
                                    width: double.infinity,
                                    text: "Schedule Tour",
                                    shape: ButtonShape.RoundedBorder10,
                                    padding: ButtonPadding.PaddingAll13,
                                    fontStyle: ButtonFontStyle
                                        .ManropeBold16WhiteA700_1)
                              ]))
                    ]))));
  }
}
