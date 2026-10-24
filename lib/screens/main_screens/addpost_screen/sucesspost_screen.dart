import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:help_app_flutter/commons/colors.dart';
import 'package:help_app_flutter/commons/common_widgets.dart';

import '../../../commons/constants.dart';
import '../bottombar_screen/bottombar_screen.dart';

class SucessPostScreen extends StatefulWidget {
  final String postId;
  const SucessPostScreen({super.key, required this.postId});

  @override
  State<SucessPostScreen> createState() => _SucessPostScreenState();
}

class _SucessPostScreenState extends State<SucessPostScreen> {
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
                  Image.asset("assets/images/postsucess.png"),
                  const SpaceHeightWidget(height: 40),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "Your Post has been uploaded".tr(),
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: fontSize20,
                              color: blackColor),
                          children: [
                            TextSpan(
                              text: " ${"Successfully".tr()}.",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: fontSize20,
                                  color: greenColor),
                            )
                          ])),
                  const SpaceHeightWidget(height: 10),
                  RichText(
                      text: TextSpan(
                          text: "${"Post Id".tr()}: ",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: fontSize16,
                              color: blackColor),
                          children: [
                        TextSpan(
                          text: "#${widget.postId}",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: fontSize16,
                              color: orangeColor),
                        )
                      ])),
                  const SpaceHeightWidget(height: 20),
                  Text(
                    "${"Once the Owner approves then the Post will go live".tr()}.",
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
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BottomBarScreen(
                                        index: 3,
                                      )));
                        },
                        name: "My Posts".tr()),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
