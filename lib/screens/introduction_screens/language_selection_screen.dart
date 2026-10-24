import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:help_app_flutter/commons/colors.dart';

import '../../commons/common_widgets.dart';
import '../../commons/constants.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  List<String> languageNames = [
    "English(Aa)",
    "Kannada(ಎಎ)",
  ];
  int? selectedLangIndex;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkFun();
    });
  }

  checkFun() {
    if (context.locale.toString() == "en") {
      setState(() {
        selectedLangIndex = 0;
      });
    } else if (context.locale.toString() == "kn") {
      setState(() {
        selectedLangIndex = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SpaceHeightWidget(height: 60),
                          Text(
                            "Select Language".tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Poppins SemiBold",
                                fontSize: fontSize20),
                          ),
                          const SpaceHeightWidget(height: 20),
                          for (int i = 0; i < 2; i++)
                            Column(
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    setState(() {
                                      selectedLangIndex = i;
                                    });
                                    if (selectedLangIndex == 0) {
                                      if (mounted) {
                                        setState(() {
                                          context.setLocale(const Locale('en'));
                                        });
                                        Get.updateLocale(
                                          const Locale('en'),
                                        );
                                      }
                                    } else if (selectedLangIndex == 1) {
                                      if (mounted) {
                                        setState(() {
                                          context.setLocale(const Locale('kn'));
                                        });
                                      }
                                      Get.updateLocale(
                                        const Locale('kn'),
                                      );
                                    }
                                    Timer(const Duration(microseconds: 10), () {
                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             const SigninScreen()));
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Container(
                                    height: 55,
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: selectedLangIndex == i
                                                ? orangeColor
                                                : blackColor.withOpacity(0.4),
                                            width: 1)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(languageNames[i],
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: fontSize14)),
                                        selectedLangIndex == i
                                            ? CircleAvatar(
                                                backgroundColor: orangeColor,
                                                radius: 12,
                                                child: Icon(
                                                  Icons.done,
                                                  size: 20,
                                                  color: whiteColor,
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                ),
                                const SpaceHeightWidget(height: 20),
                              ],
                            ),
                        ]),
                    Image.asset(
                      "assets/images/lang_select.png",
                      fit: BoxFit.contain,
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
