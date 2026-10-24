import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:help_app_flutter/commons/colors.dart';
import 'package:help_app_flutter/commons/common_functions.dart';
import 'package:help_app_flutter/model/myprofile_model.dart';
import 'package:help_app_flutter/screens/authentication_screens/signin_screen.dart';
import 'package:help_app_flutter/screens/main_screens/bottombar_screen/bottombar_screen.dart';
import 'package:help_app_flutter/screens/main_screens/home_screens/notification_screen.dart';
import 'package:help_app_flutter/screens/main_screens/myaccount_screens/help_screen.dart';

import '../../../commons/common_widgets.dart';
import '../../../commons/constants.dart';
import '../../../controllers/maincontroller.dart';
import '../../authentication_screens/signup_screen.dart';
import 'aboutus_screen.dart';
import 'myprofile_screen.dart';
import 'subscription_screen.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  MainController myaccountController = Get.put(MainController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Map mapdata = {
        "customer_id": Constants.prefs!.getString("user_id"),
      };
      await myaccountController.getMyProfileFun("init", mapdata);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appThemeColor,
        appBar: AppBar(
          backgroundColor: appThemeColor,
          toolbarHeight: 160,
          elevation: 0,
          flexibleSpace: Container(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "My Account".tr(),
                        style: TextStyle(
                            color: whiteColor,
                            fontFamily: "Poppins Medium",
                            fontSize: fontSize20),
                      ),
                    ],
                  ),
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyProfileScreen(
                                      id: myaccountController.getProfileData.id,
                                      image: myaccountController
                                          .getProfileData.image,
                                      name: myaccountController
                                          .getProfileData.name,
                                      mail: myaccountController
                                          .getProfileData.email,
                                      location: myaccountController
                                          .getProfileData.city,
                                      gender: myaccountController
                                          .getProfileData.gender,
                                      fullImage: myaccountController
                                          .getProfileData.fullImage,
                                    )));
                      },
                      child: Container(
                        height: 90,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Obx(() {
                          return myaccountController.isloading.value
                              ? Center(child: mCircularProgresIndication)
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                      const SpaceWidthWidget(width: 25),
                                      (myaccountController
                                                  .getProfileData.fullImage ==
                                              "")
                                          ? CircleAvatar(
                                              radius: 35,

                                              backgroundColor: greyColor,
                                              child: Icon(
                                                Icons.person_outline,
                                                size: 35,
                                                color:
                                                    blackColor.withOpacity(0.4),
                                              ),
                                              // backgroundImage:
                                              //     AssetImage("assets/images/Image-1.png"),
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: SizedBox(
                                                height: 70,
                                                width: 70,
                                                child: CachedNetworkImage(
                                                  imageUrl: myaccountController
                                                      .getProfileData.fullImage
                                                      .replaceAll(
                                                          "https", "http"),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Center(
                                                          child:
                                                              mCircularProgresIndication),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                      const SpaceWidthWidget(width: 10),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            (Constants.prefs!
                                                        .getString("name")
                                                        .toString() !=
                                                    "null")
                                                ? Constants.prefs!
                                                    .getString("name")
                                                    .toString()
                                                : "",
                                            style: TextStyle(
                                                fontFamily: "Poppins SemiBold",
                                                fontSize: fontSize16,
                                                color: orangeColor),
                                          ),
                                          Text(
                                            Constants.prefs!
                                                        .getString("mobile")
                                                        .toString() !=
                                                    "null"
                                                ? "+91 ${Constants.prefs!.getString("mobile").toString()}"
                                                : "",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: fontSize14,
                                                color: blackColor
                                                    .withOpacity(0.5)),
                                          ),
                                        ],
                                      ),
                                      const Spacer()
                                    ]);
                        }),
                      ))
                ],
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          color: appThemeColor,
          onRefresh: () async {
            Map mapdata = {
              "customer_id": Constants.prefs!.getString("user_id"),
            };
            await myaccountController.getMyProfileFun("init", mapdata);
          },
          child: Stack(
            children: [
              Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SpaceHeightWidget(height: 25),
                          MyProfileWidget(
                            imagename: "Home-menu.svg",
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const BottomBarScreen(index: 0)));
                            },
                            title: "Home".tr(),
                          ),
                          MyProfileWidget(
                            imagename: "My Subscription-menu.svg",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SubscriptionScreen(
                                            from: "profile",
                                          )));
                            },
                            title: "Subscription".tr(),
                          ),
                          MyProfileWidget(
                            imagename: "My Posts-menu.svg",
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const BottomBarScreen(
                                            index: 3,
                                          )));
                            },
                            title: "My Posts".tr(),
                          ),
                          Obx(() {
                            return myaccountController.isloading.value
                                ? MyProfileWidget(
                                    imagename: "Notifications-menu2.svg",
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const NotificationsScreen(
                                                    from: "profile",
                                                  )));
                                    },
                                    title: "Notifications".tr(),
                                  )
                                : MyProfileWidget(
                                    imagename: myaccountController
                                            .getProfileData.notification
                                        ? "Notifications-menu.svg"
                                        : "Notifications-menu2.svg",
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const NotificationsScreen(
                                                    from: "profile",
                                                  )));
                                    },
                                    title: "Notifications".tr(),
                                  );
                          }),
                          MyProfileWidget(
                            imagename: "About Us-menu.svg",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AnboutUsScreen(
                                            from: "About Us",
                                          )));
                            },
                            title: "About Us".tr(),
                          ),
                          MyProfileWidget(
                            imagename: "Terms and Condition-menu.svg",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AnboutUsScreen(
                                            from: "Terms and Conditions",
                                          )));
                            },
                            title: "Terms and conditions".tr(),
                          ),
                          MyProfileWidget(
                            imagename: "Privacy Policy-menu.svg",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AnboutUsScreen(
                                            from: "Privacy Policy",
                                          )));
                            },
                            title: "Privacy Policy".tr(),
                          ),
                          MyProfileWidget(
                            imagename: "Support-menu.svg",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HelpScreen()));
                            },
                            title: "Support".tr(),
                          ),
                          MyProfileWidget(
                            imagename: "logout-menu.svg",
                            onTap: () async {
                              yesNoDilog(
                                  context, "${"Do you want Logout".tr()}?",
                                  () async {
                                setState(() {
                                  loading = true;
                                });
                                Navigator.pop(context);
                                Map mapData = {
                                  "customers_id":
                                      Constants.prefs!.getString("user_id")
                                };
                                dynamic res = await myaccountController
                                    .getLogOutFun(mapData);
                                if (res['status'] == "valid") {
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SigninScreen()),
                                      (route) => false);
                                  Constants.prefs!.remove("device_token");
                                  Constants.prefs!.remove("login");
                                  Constants.prefs!.remove("mobile");
                                  Constants.prefs!.remove("mail");
                                  Constants.prefs!.remove("name");
                                  Constants.prefs!.remove("user_id");
                                  Constants.prefs!.remove("access_token");
                                } else {
                                  toastMesg(res['message'], false);
                                }
                                setState(() {
                                  loading = false;
                                });
                              });
                            },
                            title: "Logout".tr(),
                          ),
                          MyProfileWidget(
                            imagename: "Delete2.svg",
                            onTap: () {
                              deleteAccountDilog(context);
                              // "${"Do you want delete your account".tr()}?\nYour account will be deleted permanently, action can't be undo.",
                            },
                            title: "Account Delete".tr(),
                          ),
                        ],
                      ),
                    ),
                  )),
              if (loading)
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: greyColor.withOpacity(0.5),
                  child: Center(child: mCircularProgresIndication),
                ),
            ],
          ),
        ));
  }

  bool loading = false;
  deleteAccountDilog(cont) {
    return showDialog(
        barrierDismissible: false,
        useSafeArea: true,
        context: context,
        builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter myState) {
              return AlertDialog(
                  title: Text("${"Do you want delete your account".tr()}?"),
                  content: Text(
                      "${"Your account will be deleted permanently, action can't be undo".tr()}.",
                      style: TextStyle(
                          fontSize: fontSize12,
                          color: blackColor.withOpacity(0.5))),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          Navigator.pop(context);
                          Map mapData = {
                            "access_token":
                                Constants.prefs!.getString("access_token")
                          };
                          // dynamic res =
                          //     await myaccountController.getLogOutFun(mapData);
                          dynamic res = await myaccountController
                              .getAccountDeleteFun(mapData);
                          print("res....$res");
                          if (res['status'] == "valid") {
                            // ignore: use_build_context_synchronously
                            Navigator.pushAndRemoveUntil(
                                cont,
                                MaterialPageRoute(
                                    builder: (cont) => const SignUpScreen()),
                                (route) => false);
                            Constants.prefs!.remove("device_token");
                            Constants.prefs!.remove("login");
                            Constants.prefs!.remove("mobile");
                            Constants.prefs!.remove("mail");
                            Constants.prefs!.remove("name");
                            Constants.prefs!.remove("user_id");
                            Constants.prefs!.remove("access_token");
                          } else {
                            toastMesg(res['message'], false);
                          }
                          setState(() {
                            loading = false;
                          });
                        },
                        child: Text(
                          "Yes".tr(),
                          style: TextStyle(color: orangeColor),
                        )),
                    TextButton(
                      child: Text(
                        "No".tr(),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ]);
            }));
  }
}
