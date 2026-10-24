import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:help_app_flutter/commons/colors.dart';
import 'package:help_app_flutter/commons/common_widgets.dart';
import 'package:help_app_flutter/screens/main_screens/bottombar_screen/bottombar_screen.dart';

import '../../../commons/constants.dart';

class SucessSubscriptionScreen extends StatefulWidget {
  const SucessSubscriptionScreen({super.key});

  @override
  State<SucessSubscriptionScreen> createState() =>
      _SucessSubscriptionScreenState();
}

class _SucessSubscriptionScreenState extends State<SucessSubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SpaceHeightWidget(height: 80),
                  Image.asset("assets/images/SubscriptionSucess.png"),
                  const SpaceHeightWidget(height: 40),
                  Text(
                    "${"Congratulations".tr()}.",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: fontSize20,
                        color: greenColor),
                  ),
                  Text(
                    "Your Subscription has".tr(),
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: fontSize20,
                        color: blackColor),
                  )
                  // RichText(
                  //     textAlign: TextAlign.center,
                  //     text: TextSpan(
                  //         text: "Your Subscription has".tr(),
                  //         style: TextStyle(
                  //             fontFamily: "Poppins",
                  //             fontSize: fontSize20,
                  //             color: blackColor),
                  //         children: [
                  //           TextSpan(
                  //             text: "${" Successfully".tr()}.",
                  //             style: TextStyle(
                  //                 fontFamily: "Poppins",
                  //                 fontSize: fontSize20,
                  //                 color: greenColor),
                  //           )
                  //         ])),
                  ,
                  const SpaceHeightWidget(height: 20),
                  Text(
                    "${"Once the Owner approves then you can Post Quickly".tr()}.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: fontSize12,
                        color: blackColor.withOpacity(0.3)),
                  ),
                  const SpaceHeightWidget(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: CommonElvButton(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BottomBarScreen(
                                        index: 0,
                                      )),
                              (route) => false);
                        },
                        name: "Back to Home".tr()),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
