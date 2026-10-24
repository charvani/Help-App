import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

import 'package:help_app_flutter/commons/colors.dart';
import 'package:help_app_flutter/screens/main_screens/myaccount_screens/help_screen.dart';

import '../../commons/api_services.dart';
import '../../commons/common_functions.dart';
import '../../commons/common_widgets.dart';
import '../../commons/constants.dart';
import '../../controllers/maincontroller.dart';
import 'otp_screen.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  MainController signupController = Get.put(MainController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await signupController.getCmsFun(termsAndConditionsUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appThemeColor,
      appBar: AppBar(
        backgroundColor: appThemeColor,
        elevation: 0,
        leading: const SizedBox(
          height: 0,
          width: 0,
        ),
        // leading: BackIconButton(
        //     onTap: () {
        //       Navigator.pop(context);
        //     },
        //     color: whiteColor),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HelpScreen()));
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
      ),
      body: Container(
        decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        height: double.maxFinite,
        width: double.infinity,
        margin:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.055),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.height * 0.025,
        ),
        child: Form(
          key: _formkey,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SpaceHeightWidget(height: 20),
                      Text(
                        "Get Started".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Poppins SemiBold",
                            fontSize: fontSize20),
                      ),
                      SpaceHeightWidget(
                          height: MediaQuery.of(context).size.height * 0.005),
                      Text(
                        "Create account to continue".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Poppins", fontSize: fontSize14),
                      ),
                      SpaceHeightWidget(
                          height: MediaQuery.of(context).size.height * 0.03),
                      CommonTextFormField(
                          hinttext: "Name".tr(),
                          keyboard: TextInputType.name,
                          textCapital: TextCapitalization.words,
                          tcontroller: nameController,
                          inputformatters: [
                            LengthLimitingTextInputFormatter(50),
                            FilteringTextInputFormatter.allow(
                                RegExp("[A-Za-z ]")),
                            FilteringTextInputFormatter.deny(RegExp(r'^ ')),
                          ],
                          imagePath: "assets/images/person.svg",
                          validation: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your name".tr();
                            } else if (value.length < 3) {
                              return "Please enter proper name".tr();
                            } else {
                              return null;
                            }
                          }),
                      const SpaceHeightWidget(height: 20),
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
                      const SpaceHeightWidget(height: 20),
                      CommonTextFormField(
                          hinttext: "Email".tr(),
                          keyboard: TextInputType.emailAddress,
                          textCapital: TextCapitalization.none,
                          tcontroller: mailController,
                          inputformatters: [
                            LengthLimitingTextInputFormatter(50),
                            FilteringTextInputFormatter.deny(RegExp(r'^ +')),
                            FilteringTextInputFormatter.deny(
                                RegExp(r'[/\\ +-]')),
                          ],
                          imagePath: "assets/images/Gmail.svg",
                          validation: (value) {
                            String pattern =
                                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                r"{0,253}[a-zA-Z0-9])?)*$";
                            RegExp regex = RegExp(pattern);
                            if (value!.isEmpty) {
                              return "Please enter your Email".tr();
                            } else if (!regex.hasMatch(mailController.text)) {
                              return "Please enter proper Email".tr();
                            } else {
                              return null;
                            }
                          }),
                      const SpaceHeightWidget(height: 20),
                      genderType(),
                      // CommonTextFormField(
                      //     hinttext: "Gender".tr(),
                      //     keyboard: TextInputType.name,
                      //     textCapital: TextCapitalization.words,
                      //     tcontroller: genderController,
                      //     inputformatters: [
                      //       LengthLimitingTextInputFormatter(50),
                      //       FilteringTextInputFormatter.allow(RegExp("[A-Za-z]")),
                      //       FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                      //     ],
                      //     imagePath: "assets/images/Gender.svg",
                      //     validation: (value) {
                      //       if (value!.isEmpty) {
                      //         return "Please enter gender".tr();
                      //       } else {
                      //         return null;
                      //       }
                      //     }),
                      const SpaceHeightWidget(height: 20),
                      CommonTextFormField(
                          hinttext: "City".tr(),
                          keyboard: TextInputType.name,
                          textCapital: TextCapitalization.words,
                          tcontroller: locationController,
                          inputformatters: [
                            LengthLimitingTextInputFormatter(50),
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z ]")),
                            FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                          ],
                          imagePath: "assets/images/Location.svg",
                          validation: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your city".tr();
                            } else {
                              return null;
                            }
                          }),
                      const SpaceHeightWidget(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              setState(() {
                                terms = !terms;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 3),
                              height: 18,
                              width: 18,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: appThemeColor, width: 1.5),
                                  borderRadius: BorderRadius.circular(3)),
                              child: Icon(
                                Icons.done,
                                size: 15,
                                color: terms ? appThemeColor : whiteColor,
                              ),
                            ),
                          ),
                          const SpaceWidthWidget(width: 10),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              // setState(() {
                              //   termsTap = true;
                              // });
                              termsDilog();
                            },
                            child: RichText(
                              text: TextSpan(
                                  text: "I agree".tr(),
                                  style: TextStyle(
                                      fontSize: fontSize12,
                                      color: blackColor.withOpacity(0.5)),
                                  children: [
                                    TextSpan(
                                      text: " ${"terms and conditons".tr()}",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: fontSize12,
                                          color: appThemeColor),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                      const SpaceHeightWidget(height: 20),
                      Obx(() {
                        return CommonElvButton(
                          name: "Sign Up".tr(),
                          loading: signupController.isloading.value,
                          onTap: () {
                            signUpFun(context);
                          },
                        );
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${"Already have an account".tr()}?",
                            style: TextStyle(
                                fontFamily: "Poppins", fontSize: fontSize12),
                          ),
                          TextButtonWidget(
                            name: "Sign In".tr(),
                            onTapFun: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SigninScreen()),
                                  (route) => false);
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
              // Center(
              //   child: FutureBuilder(builder: (context, snap) {
              //     if (snap.hasError) {
              //       return mCircularProgresIndication;
              //     } else if (snap.connectionState == ConnectionState.waiting) {
              //       return mCircularProgresIndication;
              //     } else {
              //       return (termsTap)
              //           ? termsDilog()
              //           : Container(
              //               height: 0,
              //               width: 0,
              //             );
              //     }
              //   }),
              // )
            ],
          ),
        ),
      ),
    );
  }

  bool terms = true;
  signUpFun(cont) async {
    if (_formkey.currentState!.validate()) {
      if (terms == true) {
        Map mapdata = {
          "name": nameController.text,
          "email": mailController.text,
          "location": locationController.text,
          "gender": genderVal,
          "mobile": mobileController.text,
        };
        dynamic res = await signupController.getSignupFun(mapdata);
        if (res['status'] == "valid") {
          Navigator.push(
              cont,
              MaterialPageRoute(
                  builder: (cont) => OtpScreen(
                        mobileNum: mobileController.text,
                        from: "signup",
                      )));
        } else {
          toastMesg(res['message'], false);
        }
      } else {
        toastMesg("Please agree with terms and conditions".tr(), false);
      }
    }
  }

  String? genderVal;
  List<String> gender = ["Male", "Female", "Other"];
  Widget genderType() {
    return DropdownButtonFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      icon: const Icon(Icons.keyboard_arrow_down_outlined),
      focusColor: Colors.white,
      decoration: InputDecoration(
          isDense: true,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset("assets/images/Gender.svg"),
          ),
          labelText: "Gender".tr(),
          labelStyle: hintStyle,
          hintText: "Select gender".tr(),
          hintStyle: hintStyle,
          filled: true,
          fillColor: greyColor,
          focusColor: greyColor,
          hoverColor: greyColor,
          // border:
          errorBorder: errorBorder,
          focusedBorder: normalBorder,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: whiteColor)),
          focusedErrorBorder: errorBorder),
      items: [
        for (int i = 0; i < gender.length; i++)
          DropdownMenuItem(
              value: gender[i],
              onTap: () {
                setState(() {
                  genderVal = gender[i];
                });
              },
              child: Text(
                gender[i] == "Male"
                    ? "Male".tr()
                    : gender[i] == "Female"
                        ? "Female".tr()
                        : "Other".tr(),
                style: TextStyle(fontSize: fontSize16, fontFamily: "Poppins"),
              )),
      ],
      onChanged: (String? newValue) {},
      validator: (newValue) {
        if (newValue == null) {
          return 'Please select gender'.tr();
        } else {
          return null;
        }
      },
    );
  }

  bool termsTap = false;

  // Widget termsDilog() {
  //   return Container(
  //     color: whiteColor,
  //     child: Container(
  //       decoration: BoxDecoration(
  //           color: blackColor.withOpacity(0.05),
  //           border: Border.all(width: 1, color: appThemeColor),
  //           borderRadius: BorderRadius.circular(10)),
  //       child: Padding(
  //         padding: const EdgeInsets.all(10.0),
  //         child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     "Terms and conditions",
  //                     style: TextStyle(
  //                         fontFamily: "Poppin SemiBold",
  //                         fontSize: fontSize16,
  //                         color: blackColor),
  //                   ),
  //                 ],
  //               ),
  //               const SpaceHeightWidget(height: 10),
  //               Html(
  //                 tagsList: Html.tags,
  //                 data: signupController.getCmsData,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   TextButtonWidget(
  //                       name: "Close",
  //                       textStyle: TextStyle(
  //                         fontFamily: "Poppins",
  //                         fontSize: fontSize14,
  //                         color: redColor,
  //                       ),
  //                       onTapFun: () {
  //                         print("nme");
  //                         setState(() {
  //                           termsTap = false;
  //                         });
  //                       }),
  //                 ],
  //               )
  //             ]),
  //       ),
  //     ),
  //   );
  // }

  termsDilog() {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String text = signupController.getCmsData.replaceAll(exp, '');
    return showDialog(
        barrierDismissible: false,
        useSafeArea: true,
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (BuildContext cont, StateSetter myState) {
              return AlertDialog(
                  title: Text(
                    "Terms and conditions".tr(),
                    style: TextStyle(
                        fontFamily: "Poppin SemiBold",
                        fontSize: fontSize16,
                        color: blackColor),
                  ),
                  content: Text(
                    text,
                    style: TextStyle(
                        fontFamily: "Poppin",
                        fontSize: fontSize12,
                        color: blackColor.withOpacity(0.5)),
                  ),
                  // Html(
                  //   tagsList: Html.tags,
                  //   data: addPostController.getYoutubeInformation,
                  // ),
                  // Text(t2),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Close".tr(),
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: fontSize14,
                            color: redColor,
                          ),
                        )),
                  ]);
            }));
  }
}
