import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

import 'package:flutter/services.dart';
import 'package:help_app_flutter/commons/colors.dart';
import 'package:help_app_flutter/commons/common_functions.dart';
import 'package:help_app_flutter/commons/common_widgets.dart';
import 'package:help_app_flutter/commons/constants.dart';
import 'package:help_app_flutter/screens/main_screens/myaccount_screens/help_screen.dart';

import '../../controllers/maincontroller.dart';
import 'otp_screen.dart';
import 'signup_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  TextEditingController mobileController = TextEditingController();
  MainController signinController = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appThemeColor,
      appBar: AppBar(
        backgroundColor: appThemeColor,
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpScreen()),
                );
              },
              child: Text(
                "${"Help".tr()}?",
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: fontSize16,
                    color: whiteColor),
              )),
          SpaceWidthWidget(width: MediaQuery.of(context).size.height * 0.01)
        ],
        leading: Container(),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        height: double.maxFinite,
        width: double.infinity,
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.055,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.height * 0.025,
        ),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceHeightWidget(height: 20),
                  Text(
                    "${"Hello".tr()},",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Poppins SemiBold", fontSize: fontSize20),
                  ),
                  const SpaceHeightWidget(height: 5),
                  Text(
                    "Good to see you here".tr(),
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontFamily: "Poppins", fontSize: fontSize14),
                  ),
                  const SpaceHeightWidget(height: 40),
                  CommonTextFormField(
                      hinttext: "Mobile".tr(),
                      keyboard: TextInputType.number,
                      textCapital: TextCapitalization.none,
                      tcontroller: mobileController,
                      inputformatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                      ],
                      imagePath: "assets/images/Call.svg",
                      validation: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your mobile number".tr();
                        } else if (value.length < 10) {
                          return "Please enter 10 digits".tr();
                        } else {
                          return null;
                        }
                      }),
                  const SpaceHeightWidget(height: 30),
                  Obx(() {
                    return CommonElvButton(
                      name: "Sign In".tr(),
                      loading: signinController.isloading.value,
                      onTap: () {
                        signinFun(context);
                      },
                    );
                  }),
                  const SpaceHeightWidget(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${"Didn't have an account".tr()}?",
                        style: TextStyle(
                            fontFamily: "Poppins", fontSize: fontSize12),
                      ),
                      TextButtonWidget(
                        name: "Sign Up".tr(),
                        onTapFun: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        },
                        textStyle: TextStyle(
                            fontFamily: "Poppins Bold",
                            fontSize: fontSize14,
                            color: orangeColor),
                      )
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }

  signinFun(cont) async {
    if (_formkey.currentState!.validate()) {
      Map mapdata = {"mobile": mobileController.text};
      dynamic res = await signinController.getSigninFun(mapdata);
      if (res['status'] == "valid") {
        Navigator.push(
            cont,
            MaterialPageRoute(
                builder: (cont) => OtpScreen(
                    mobileNum: mobileController.text, from: "signin")));
      } else {
        toastMesg(res['message'], false);
        if (res['exception_type'] == "OTP_VERIFICATION REQUIRED") {
          Navigator.push(
              cont,
              MaterialPageRoute(
                  builder: (cont) => OtpScreen(
                      mobileNum: mobileController.text, from: "signin")));
        }
      }
    }
  }
}
