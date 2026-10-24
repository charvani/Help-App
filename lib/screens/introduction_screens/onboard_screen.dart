import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_app_flutter/commons/colors.dart';
import 'package:help_app_flutter/commons/constants.dart';
import 'package:help_app_flutter/screens/authentication_screens/signin_screen.dart';

import '../../commons/common_widgets.dart';
import '../../controllers/maincontroller.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  int _pageIndex = 0;
  final _pageController = PageController();
  MainController onboardController = Get.put(MainController());
  onboardFun() async {
    await onboardController.getOnboardFun();
  }

  @override
  void initState() {
    super.initState();
    Constants.prefs!.setString("onboard", "true");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onboardFun();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: whiteColor,
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.01,
                top: MediaQuery.of(context).size.width * 0.01),
            child: TextButtonWidget(
              name: "Skip",
              textStyle: TextStyle(
                  color: blackColor,
                  fontSize: fontSize16,
                  fontFamily: "Poppins"),
              onTapFun: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SigninScreen()));
              },
            ),
          )
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        height: 100,
        color: whiteColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() {
              return onboardController.isloading.value
                  ? const Text("")
                  : Row(
                      children: [
                        for (int i = 0;
                            i < onboardController.getOnboard.length;
                            i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: CircleAvatar(
                              radius: (_pageIndex == i) ? 8 : 5,
                              backgroundColor: (_pageIndex == i)
                                  ? appThemeColor
                                  : orangeColor,
                            ),
                          ),
                      ],
                    );
            }),
            FloatingActionButton(
              onPressed: () {
                if (_pageIndex == (onboardController.getOnboard.length - 1)) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SigninScreen()));
                } else {
                  print(_pageIndex);
                  _pageController.animateToPage(_pageIndex + 1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.linear);
                }
              },
              backgroundColor: appThemeColor,
              child: Icon(Icons.arrow_forward_ios, color: whiteColor),
            )
            // CircleAvatar(
            //   radius: 25,
            //   backgroundColor: appThemeColor,
            //   child: Icon(Icons.arrow_forward_ios, color: whiteColor),
            // )
          ],
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          return onboardController.isloading.value
              ? Center(child: mCircularProgresIndication)
              : PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  children: [
                    for (int i = 0;
                        i < onboardController.getOnboard.length;
                        i++)
                      onboardWidget(
                        i,
                        onboardController.getOnboard[i]['image'],
                        onboardController.getOnboard[i]['title'],
                        onboardController.getOnboard[i]['description'],
                      ),
                  ],
                );
        }),
      ),
    );
  }

  Widget onboardWidget(int i, String img, title, description) {
    Widget textWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SpaceHeightWidget(
          height: MediaQuery.of(context).size.height * 0.08,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style:
              TextStyle(fontFamily: "Poppins SemiBold", fontSize: fontSize20),
        ),
        const SpaceHeightWidget(
          height: 20,
        ),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: "Poppins", fontSize: fontSize14),
        ),
      ],
    );
    Widget imageWidget = CachedNetworkImage(
      imageUrl: img.replaceAll("https", "http"),
      errorWidget: (context, url, error) => mCircularProgresIndication,
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width * 0.5,
    );

    return Stack(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (i % 2 == 0) textWidget,
                  if (img != "") imageWidget,
                  if (i % 2 != 0) textWidget,
                  if (i % 2 != 0)
                    SpaceHeightWidget(
                      height: MediaQuery.of(context).size.height * 0.03,
                    )
                ],
              ),
            )),
      ],
    );
  }
}
