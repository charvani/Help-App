import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:help_app_flutter/commons/api_services.dart';
import 'package:help_app_flutter/commons/colors.dart';
import 'package:help_app_flutter/commons/constants.dart';

import '../../commons/common_functions.dart';
import '../../commons/common_widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../controllers/maincontroller.dart';
import '../main_screens/bottombar_screen/bottombar_screen.dart';

class OtpScreen extends StatefulWidget {
  final String mobileNum, from;

  const OtpScreen({super.key, required this.mobileNum, required this.from});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  MainController otpController = Get.put(MainController());
  TextEditingController otpTextController = TextEditingController();
  int _start = 30;
  bool resendwidget = false;
  Timer? timer;
  String seconds = '30';
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            resendwidget = true;
          });
        } else {
          if (mounted) {
            setState(() {
              _start--;
              if (_start < 10) {
                seconds = '0$_start';
              } else {
                seconds = _start.toString();
              }
            });
          }
        }
      },
    );
  }

  firebaseTokenfun() async {
    var device_token = await FirebaseMessaging.instance.getToken();
    print("firebase token .......$device_token");
    if (device_token != null) {
      Constants.prefs!.setString('device_token', device_token);
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    firebaseTokenfun();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        leading: BackIconButton(
            onTap: () {
              Navigator.pop(context);
            },
            color: blackColor),
        centerTitle: true,
        title: Text(
          "OTP".tr(),
          style: TextStyle(
            fontFamily: "Poppins Medium",
            fontSize: fontSize20,
            color: blackColor,
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/OTP.png",
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
                    const SpaceHeightWidget(height: 30),
                    Text(
                      "Verification Code".tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Poppins SemiBold", fontSize: fontSize20),
                    ),
                    const SpaceHeightWidget(height: 10),
                    Text(
                      "${"We have sent the code verification to your registered Mobile Number".tr()}91-${widget.mobileNum}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Poppins", fontSize: fontSize12),
                    ),
                    const SpaceHeightWidget(height: 20),
                    PinCodeTextField(
                      keyboardType: TextInputType.number,
                      controller: otpTextController,
                      appContext: context,
                      length: 4,
                      onChanged: (value) {},
                      autoDismissKeyboard: true,
                      pinTheme: PinTheme(
                        errorBorderColor: redColor,
                        borderWidth: 1,
                        selectedColor: blackColor.withOpacity(0.4),
                        selectedFillColor: blackColor.withOpacity(0.4),
                        inactiveColor: blackColor.withOpacity(0.4),
                        inactiveFillColor: blackColor.withOpacity(0.4),
                        activeColor: blackColor.withOpacity(0.4),
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(12),
                        fieldHeight: 50,
                        fieldWidth: 52,
                        activeFillColor: blackColor.withOpacity(0.4),
                      ),
                      cursorColor: blackColor,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.deny(RegExp("[ ]")),
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        LengthLimitingTextInputFormatter(4),
                      ],
                      validator: (value) {
                        if (value!.length < 4) {
                          return "Please enter 4 digits".tr();
                        } else {
                          return null;
                        }
                      },
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      height: 40,
                      child: resendwidget
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${"Don't you receive otp".tr()}?",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: fontSize12),
                                ),
                                Obx(() {
                                  return TextButtonWidget(
                                    onTapFun: () async {
                                      Map mapdata = {
                                        "mobile": widget.mobileNum
                                      };
                                      dynamic res = await otpController
                                          .getResendOtpFun(mapdata);
                                      if (res['status'] != "valid") {
                                        toastMesg(res['message'], false);
                                      } else {
                                        setState(() {
                                          resendwidget = false;
                                          _start = 30;
                                          seconds = '30';
                                        });
                                        startTimer();
                                      }
                                    },
                                    loading: otpController.isloading.value,
                                    name: "RESEND".tr(),
                                    textStyle: TextStyle(
                                        fontFamily: "Poppins Bold",
                                        fontSize: fontSize14,
                                        color: orangeColor),
                                  );
                                }),
                              ],
                            )
                          : RichText(
                              text: TextSpan(
                                  text: "${"Resend OTP in".tr()} ",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: fontSize12,
                                      color: blackColor),
                                  children: [
                                  TextSpan(
                                    text: "00 : $seconds ${"Sec".tr()}",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: fontSize12,
                                        color: redColor),
                                  )
                                ])),
                    ),
                    const SpaceHeightWidget(height: 30),
                    Obx(() {
                      return CommonElvButton(
                        name: "Verify".tr(),
                        loading: otpController.isloading.value,
                        onTap: () {
                          verifyFun(context);
                        },
                      );
                    })
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  verifyFun(cont) async {
    if (_formKey.currentState!.validate()) {
      Map mapdata = {
        "otp": otpTextController.text,
        "mobile": widget.mobileNum,
        "token": Constants.prefs!.getString('device_token')
      };
      String? url;
      if (widget.from == "signin") {
        url = signinOtpVerifyUrl;
      } else {
        url = signupOtpVerifyUrl;
      }
      dynamic res = await otpController.getOtpVerifyFun(mapdata, url);
      if (res['status'] == "valid") {
        Constants.prefs!.setString("login", "true");
        Constants.prefs!.setString("mobile", widget.mobileNum);
        Constants.prefs!.setString("mail", res['data']['email']);
        Constants.prefs!.setString("name", res['data']['name']);
        Constants.prefs!.setString("user_id", res['data']['id']);
        Constants.prefs!.setString("access_token", res['data']['access_token']);

        Navigator.pushAndRemoveUntil(
            cont,
            MaterialPageRoute(
                builder: (cont) => const BottomBarScreen(
                      index: 0,
                    )),
            (route) => false);
      } else {
        toastMesg(res['message'], false);
      }
    }
  }
}
