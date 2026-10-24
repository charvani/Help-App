import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:help_app_flutter/commons/colors.dart';
import 'package:help_app_flutter/commons/common_functions.dart';
import 'package:help_app_flutter/commons/constants.dart';
import 'package:help_app_flutter/screens/main_screens/addpost_screen/postview_screen.dart';

import '../../../commons/common_widgets.dart';
import '../../../controllers/maincontroller.dart';

class NotificationsScreen extends StatefulWidget {
  final dynamic from;
  const NotificationsScreen({super.key, required this.from});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  MainController notificationController = Get.put(MainController());
  notificationDataFun() async {
    Map mapdata = {
      "access_token": Constants.prefs!.getString("access_token"),
      "start": start.toString(),
      "page": page.toString()
    };
    await notificationController.getNotificationsFun(
      "init",
      start,
      mapdata,
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (mounted) setState(() {});
        Future.delayed(const Duration(seconds: 0), () {
          loadMoreDataGet();
          if (mounted) setState(() {});
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      notificationDataFun();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: whiteColor,
        leading: BackIconButton(
          color: blackColor,
          onTap: () {
            if (widget.from == "pushnotification") {
              SystemNavigator.pop();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        centerTitle: true,
        title: Text(
          "Notifications".tr(),
          style: TextStyle(
              fontFamily: "Poppins SemiBold",
              fontSize: fontSize16,
              color: blackColor),
        ),
        actions: [
          Obx(() {
            return notificationController.isloading.value
                ? wCircularProgresIndication
                : (notificationController.getNotifications.isNotEmpty)
                    ? TextButtonWidget(
                        name: "Clear All".tr(),
                        textStyle: TextStyle(
                            fontFamily: "Poppins Bold",
                            fontSize: fontSize14,
                            color: redColor),
                        onTapFun: () {
                          yesNoDilog(context,
                              "${"Do you want to clear notifications".tr()}?",
                              () async {
                            Navigator.pop(context);
                            Map mapdata = {
                              "customer_id":
                                  Constants.prefs!.getString("user_id")
                            };
                            dynamic res = await notificationController
                                .getClearNotificationFun(mapdata);
                            print(res);
                            if (res['status'] == "valid") {
                              setState(() {
                                start = 0;
                                page = 15;
                              });
                              notificationDataFun();
                            }
                          });
                        },
                      )
                    : Container(
                        height: 0,
                        width: 0,
                      );
          }),
          const SpaceWidthWidget(width: 15)
        ],
      ),
      body: RefreshIndicator(
        color: appThemeColor,
        onRefresh: () async {
          setState(() {
            start = 0;
            page = 15;
          });
          notificationDataFun();
        },
        child: Obx(() {
          return notificationController.isloading.value
              ? Center(child: mCircularProgresIndication)
              : notificationController.getNotifications.isEmpty
                  ? ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (context, ind) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.85,
                          child: Center(
                              child: Text(
                            "Not avilable".tr(),
                            style: TextStyle(
                                fontFamily: "Poppins", fontSize: fontSize10),
                          )),
                        );
                      })
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              controller: scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: notificationController
                                  .getNotifications.length,
                              itemBuilder: (context, ind) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () async {
                                      if (notificationController
                                              .getNotifications[ind]
                                              .viewStatus !=
                                          "seen") {
                                        dilogFun(ind);
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PostView(
                                                      postid:
                                                          notificationController
                                                              .getNotifications[
                                                                  ind]
                                                              .orderId,
                                                      title:
                                                          notificationController
                                                              .getNotifications[
                                                                  ind]
                                                              .title
                                                              .toString(),
                                                      categoryName:
                                                          notificationController
                                                              .getNotifications[
                                                                  ind]
                                                              .categoryName
                                                              .toString(),
                                                    )));
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 4,
                                                backgroundColor:
                                                    (notificationController
                                                                .getNotifications[
                                                                    ind]
                                                                .viewStatus !=
                                                            "seen")
                                                        ? redColor
                                                        : whiteColor,
                                              ),
                                              const SpaceWidthWidget(width: 3),
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundColor: orangeColor,
                                                child: Icon(
                                                  Icons.notifications_none,
                                                  size: 23,
                                                  color: whiteColor,
                                                ),
                                              ),
                                              const SpaceWidthWidget(width: 5),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      notificationController
                                                          .getNotifications[ind]
                                                          .message,
                                                      style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          fontSize: fontSize14,
                                                          color: blackColor),
                                                    ),
                                                    Wrap(
                                                      children: [
                                                        if (notificationController
                                                                    .getNotifications[
                                                                        ind]
                                                                    .viewStatus ==
                                                                "seen" &&
                                                            notificationController
                                                                    .getNotifications[
                                                                        ind]
                                                                    .description !=
                                                                "")
                                                          Text(
                                                            notificationController
                                                                .getNotifications[
                                                                    ind]
                                                                .description,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Poppins",
                                                                fontSize:
                                                                    fontSize8,
                                                                color:
                                                                    blackColor),
                                                          ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        if (notificationController
                                                .getNotifications[ind]
                                                .viewStatus ==
                                            "seen")
                                          Text(
                                            notificationController
                                                .getNotifications[ind]
                                                .createdAt,
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: fontSize8,
                                                color: blackColor
                                                    .withOpacity(0.6)),
                                          )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                        paginationLoading
                            ? mCircularProgresIndication
                            : const SizedBox(
                                height: 0,
                                width: 0,
                              )
                      ],
                    );
        }),
      ),
    );
  }

  int start = 0;
  int page = 15;
  ScrollController scrollController = ScrollController();
  bool paginationLoading = false;
  loadMoreDataGet() async {
    setState(() {
      paginationLoading = true;
      start = start + page;
    });

    Map mapdata = {
      "access_token": Constants.prefs!.getString("access_token"),
      "start": start.toString(),
      "page": page.toString()
    };
    await notificationController.getNotificationsFun(
        "pagination", start, mapdata);

    Timer(const Duration(seconds: 1), () async {
      setState(() {
        paginationLoading = false;
      });
    });
  }

  dilogFun(int ind) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              notificationController.getNotifications[ind].message,
              style: TextStyle(
                  fontFamily: "Poppin SemiBold",
                  fontSize: fontSize16,
                  color: blackColor),
            ),
            content: Text(
              "${notificationController.getNotifications[ind].description} \nRecieved ${notificationController.getNotifications[ind].createdAt}",
              style: TextStyle(
                  fontFamily: "Poppin SemiBold",
                  fontSize: fontSize14,
                  color: blackColor),
            ),
            actions: [
              TextButtonWidget(
                  name: "Close".tr(),
                  textStyle: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: fontSize12,
                    color: redColor,
                  ),
                  onTapFun: () {
                    Navigator.pop(context);
                  })
            ],
          );
        });
    Map mapdata = {"id": notificationController.getNotifications[ind].id};
    dynamic res = await notificationController.getNotificationReadFun(
        mapdata, widget.from);
    if (res['status'] == "valid") {
      notificationDataFun();
    } else {
      toastMesg(res['message'], false);
    }
  }
}
