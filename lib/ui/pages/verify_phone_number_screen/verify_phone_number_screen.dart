import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/ui/pages/add_new_property_contact_screen/add_new_property_contact_screen.dart';
import 'package:hostmi/ui/pages/main_page.dart';
import 'package:hostmi/widgets/custom_button.dart';
import 'package:hostmi/widgets/custom_icon_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyPhoneNumberScreen extends StatelessWidget {
  const VerifyPhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.gray50,
            resizeToAvoidBottomInset: false,
            body: Container(
                width: double.maxFinite,
                padding: getPadding(left: 23, top: 8, right: 23, bottom: 8),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BackButton(),
                      Padding(
                          padding: getPadding(left: 1, top: 34),
                          child: Text("Verify phone number",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtManropeExtraBold24Gray900)),
                      Container(
                          width: getHorizontalSize(299),
                          margin: getMargin(left: 1, top: 7, right: 28),
                          child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "We send a code to (",
                                    style: TextStyle(
                                        color: ColorConstant.blueGray500,
                                        fontSize: getFontSize(14),
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text:
                                        " *****325). Enter it here to verify your identity",
                                    style: TextStyle(
                                        color: ColorConstant.gray900,
                                        fontSize: getFontSize(14),
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.w600))
                              ]),
                              textAlign: TextAlign.left)),
                      Padding(
                          padding: getPadding(left: 1, top: 47),
                          child: PinCodeTextField(
                              appContext: context,
                              length: 5,
                              obscureText: false,
                              obscuringCharacter: '*',
                              keyboardType: TextInputType.number,
                              autoDismissKeyboard: true,
                              enableActiveFill: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (value) {},
                              textStyle: TextStyle(
                                  color: ColorConstant.gray900,
                                  fontSize: getFontSize(24),
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w800),
                              pinTheme: PinTheme(
                                  fieldHeight: getHorizontalSize(56),
                                  fieldWidth: getHorizontalSize(56),
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(
                                      getHorizontalSize(12)),
                                  selectedFillColor: ColorConstant.blueGray50,
                                  activeFillColor: ColorConstant.blueGray50,
                                  inactiveFillColor: ColorConstant.blueGray50,
                                  inactiveColor:
                                      ColorConstant.fromHex("#1212121D"),
                                  selectedColor:
                                      ColorConstant.fromHex("#1212121D"),
                                  activeColor:
                                      ColorConstant.fromHex("#1212121D")))),
                      Align(
                          alignment: Alignment.center,
                          child: Padding(
                              padding: getPadding(top: 33),
                              child: Text("Resend Code",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtManropeSemiBold16Brown500
                                      .copyWith(
                                          letterSpacing:
                                              getHorizontalSize(0.2))))),
                      CustomButton(
                          height: getVerticalSize(56),
                          text: "Confirm",
                          margin: getMargin(left: 1, top: 50, bottom: 5),
                          shape: ButtonShape.RoundedBorder10,
                          padding: ButtonPadding.PaddingAll16,
                          fontStyle: ButtonFontStyle.ManropeBold16WhiteA700_1,
                          onTap: () {
                            onTapConfirm(context);
                          })
                    ]))));
  }

  onTapBtnArrowleft(BuildContext context) {
    Navigator.pop(context);
  }

  onTapConfirm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context){
        return const MainPage();
      })
    );
    //Navigator.pushNamed(context, AppRoutes.selectVirtualAppScreen);
  }
}
