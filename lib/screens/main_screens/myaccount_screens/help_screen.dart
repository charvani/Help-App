import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:help_app_flutter/commons/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../commons/common_widgets.dart';
import '../../../commons/constants.dart';
import '../../../controllers/maincontroller.dart';
import '../home_screens/notification_screen.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  MainController supportController = Get.put(MainController());
  String image = "";
  String mobile = "";
  String mail = "";
  String title = "";
  dataFun() async {
    dynamic res = await supportController.getSupportFun();
    if (res['status'] == true) {
      setState(() {
        title = res['data']['title'];
        image = res['data']['image'];
        mail = res['data']['email'];
        mobile = res['data']['mobile'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      dataFun();
    });
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
          "Support".tr(),
          style: TextStyle(
            fontFamily: "Poppins Medium",
            fontSize: fontSize20,
            color: blackColor,
          ),
        ),
        // actions: [
        //   NotificationWidget(
        //     badge: true,
        //     iconColor: blackColor,
        //     onTap: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => NotificationsScreen()));
        //     },
        //   ),
        //   const SpaceWidthWidget(
        //     width: 10,
        //   )
        // ],
      ),
      body: Obx(() {
        return supportController.isloading.value
            ? Center(child: mCircularProgresIndication)
            : SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SpaceHeightWidget(height: 100),
                          // Image.asset(
                          //   "assets/images/Support.png",
                          //   width: 300,
                          // ),
                          CachedNetworkImage(
                            imageUrl: image.replaceAll("https", "http"),
                            errorWidget: (context, url, error) =>
                                Center(child: mCircularProgresIndication),
                            // height: 200,
                            fit: BoxFit.fill,
                            width: 300,
                          ),
                          const SpaceHeightWidget(height: 20),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: fontSize16,
                                color: blackColor),
                          ),
                          const SpaceHeightWidget(height: 50),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              _makePhoneCall(mobile);
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: greyColor),
                                  padding: const EdgeInsets.all(15),
                                  child: const Icon(
                                    Icons.phone,
                                    size: 30,
                                  ),
                                ),
                                const SpaceWidthWidget(width: 15),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Mobile Number".tr(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: fontSize14,
                                          color: blackColor),
                                    ),
                                    Text(
                                      "+91 $mobile",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: fontSize16,
                                          color: blackColor),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SpaceHeightWidget(height: 25),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              _launchMail(mail);
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: greyColor),
                                  padding: const EdgeInsets.all(15),
                                  child: const Icon(
                                    Icons.mail,
                                    size: 30,
                                  ),
                                ),
                                const SpaceWidthWidget(width: 15),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Email".tr(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: fontSize14,
                                          color: blackColor),
                                    ),
                                    Text(
                                      mail,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: fontSize16,
                                          color: blackColor),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ]),
                  ),
                ),
              );
      }),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _launchMail(String mail) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: mail,
      query: 'subject=Required Help App Support',
    );

    await launchUrl(emailLaunchUri);
  }
}
