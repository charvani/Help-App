import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:help_app_flutter/commons/colors.dart';
import 'package:help_app_flutter/commons/common_functions.dart';
import 'package:help_app_flutter/screens/main_screens/addpost_screen/editpost_screen.dart';
import 'package:help_app_flutter/screens/main_screens/addpost_screen/postview_screen.dart';

import '../../../commons/common_widgets.dart';
import '../../../commons/constants.dart';
import '../../../controllers/maincontroller.dart';
import '../bottombar_screen/bottombar_screen.dart';

class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({super.key});

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {
  int buttonSelectInt = 0;
  MainController myPostsController = Get.put(MainController());
  List<String> videosdata = [];
  String thumbnail = "";
  dataFun(type) async {
    Map mapdata = {
      "customer_id": Constants.prefs!.getString("user_id"),
      "status": type,
      "start": start.toString(),
      "page": page.toString(),
    };
    print("mapdata.....$mapdata");
    dynamic res = await myPostsController.getMyPostsFun("init", start, mapdata);
    // print("res,,,,,$res");
    // if (res != null) {
    //   for (var i = 0; i < myPostsController.getMyPosts.length; i++) {
    //     // ignore: prefer_interpolation_to_compose_strings
    //     thumbnail = "https://img.youtube.com/vi/" +
    //         // myPostsController.getMyPosts[i].videoid
    //         "jBIZG_FnJ9o"
    //         // ..split('/')[1]
    //         +
    //         '/0.jpg';
    //     // 'https://img.youtube.com/vi'+videosdata[i].split('/')[1]+'/0.jpg';

    //     setState(() {
    //       videosdata.add(thumbnail);
    //     });
    //     print("vido images...$videosdata");
    //   }
    // }
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
      dataFun("pending");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      // appBar: commonAppBar(context, "My Posts"),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: whiteColor,
        toolbarHeight: MediaQuery.of(context).size.height * 0.14,
        flexibleSpace: SizedBox(
            child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Posts".tr(),
                  style: TextStyle(
                      fontFamily: "Poppins SemiBold",
                      fontSize: fontSize20,
                      color: blackColor),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: MaterialButton(
                            elevation: 0,
                            onPressed: () async {
                              setState(() {
                                buttonSelectInt = 0;
                                start = 0;
                                page = 10;
                              });
                              Map mapdata = {
                                "customer_id":
                                    Constants.prefs!.getString("user_id"),
                                "status": "pending",
                                "start": start.toString(),
                                "page": page.toString(),
                              };
                              print("mapdata.....$mapdata");
                              await myPostsController.getMyPostsFun(
                                  "init", start, mapdata);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.050),
                            color: buttonSelectInt == 0
                                ? appThemeColor
                                : unslectedButoonColor.withOpacity(0.5),
                            height:
                                (context.locale.toString() == "en") ? 35 : 45,
                            child: Text(
                              "Pending".tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Poppins Medium",
                                  fontSize: fontSize12,
                                  color: whiteColor),
                            ),
                          ),
                        ),
                        const SpaceWidthWidget(width: 8),
                        Expanded(
                          child: MaterialButton(
                            elevation: 0,
                            onPressed: () async {
                              setState(() {
                                buttonSelectInt = 1;
                                start = 0;
                                page = 10;
                              });
                              Map mapdata = {
                                "customer_id":
                                    Constants.prefs!.getString("user_id"),
                                // "1",
                                "status": "accepted",
                                "start": start.toString(),
                                "page": page.toString(),
                              };
                              print("mapdata.....$mapdata");
                              await myPostsController.getMyPostsFun(
                                  "init", start, mapdata);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.050),
                            color: buttonSelectInt == 1
                                ? appThemeColor
                                : unslectedButoonColor.withOpacity(0.5),
                            height:
                                (context.locale.toString() == "en") ? 35 : 45,
                            child: Text(
                              "Approved".tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Poppins Medium",
                                  fontSize: fontSize12,
                                  color: whiteColor),
                            ),
                          ),
                        ),
                        const SpaceWidthWidget(width: 8),
                        Expanded(
                          child: MaterialButton(
                            elevation: 0,
                            onPressed: () async {
                              setState(() {
                                buttonSelectInt = 2;
                                start = 0;
                                page = 10;
                              });
                              Map mapdata = {
                                "customer_id":
                                    Constants.prefs!.getString("user_id"),
                                "status": "rejected"
                              };
                              print("mapdata.....$mapdata");
                              await myPostsController.getMyPostsFun(
                                  "init", start, mapdata);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.050,
                            ),
                            color: buttonSelectInt == 2
                                ? appThemeColor
                                : unslectedButoonColor.withOpacity(0.5),
                            height:
                                (context.locale.toString() == "en") ? 35 : 45,
                            child: Text(
                              "Rejected".tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Poppins Medium",
                                  fontSize: fontSize12,
                                  color: whiteColor),
                            ),
                          ),
                        )
                      ]),
                )
              ],
            ),
          ),
        )),
      ),
      body: RefreshIndicator(
        color: appThemeColor,
        onRefresh: () async {
          if (mounted) {
            setState(() {
              start = 0;
              page = 10;
            });
          }
          String postsType;
          if (buttonSelectInt == 0) {
            postsType = "pending";
          } else if (buttonSelectInt == 1) {
            postsType = "accepted";
          } else {
            postsType = "rejected";
          }
          dataFun(postsType);
        },
        child: Obx(() {
          return myPostsController.isloading.value
              ? Center(child: mCircularProgresIndication)
              : myPostsController.getMyPosts.isEmpty
                  ? ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (context, ind) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: Text(
                                "Not avilable".tr(),
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: fontSize10),
                              )),
                              const SpaceHeightWidget(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: SizedBox(
                                  width: 150,
                                  child: CommonElvButton(
                                      onTap: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const BottomBarScreen(
                                                      index: 2,
                                                    )),
                                            (route) => false);
                                      },
                                      name: "Create Post".tr()),
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                              controller: scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PostView(
                                                  postid: myPostsController
                                                      .getMyPosts[index].id,
                                                  title: myPostsController
                                                      .getMyPosts[index].title,
                                                  categoryName:
                                                      myPostsController
                                                          .getMyPosts[index]
                                                          .categoryName,
                                                )));
                                  },
                                  child: PostItemWidget(
                                    imagename:
                                        // (videosdata[index] != "")
                                        //     ? videosdata[index]
                                        //     :
                                        myPostsController
                                            .getMyPosts[index].image,
                                    status: myPostsController
                                        .getMyPosts[index].status,
                                    date: myPostsController
                                        .getMyPosts[index].createdDate,
                                    name: myPostsController
                                        .getMyPosts[index].name,
                                    title: myPostsController
                                        .getMyPosts[index].title,
                                    mobile: myPostsController
                                        .getMyPosts[index].mobile,
                                    edit: myPostsController
                                        .getMyPosts[index].edit,
                                    delete: myPostsController
                                        .getMyPosts[index].delete,
                                    editFun: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditPostScreen(
                                                    postId: myPostsController
                                                        .getMyPosts[index].id,
                                                  )));
                                    },
                                    deleteFun: () async {
                                      yesNoDilog(context,
                                          "${"Do you want to delete post".tr()}?",
                                          () async {
                                        Navigator.pop(context);
                                        Map mapdata = {
                                          "posts_id": myPostsController
                                              .getMyPosts[index].id
                                        };
                                        print(mapdata);
                                        dynamic res = await myPostsController
                                            .getDeletePostFun(mapdata);
                                        print(res);
                                        if (res['status'] == "valid") {
                                          String postsType;
                                          if (buttonSelectInt == 0) {
                                            postsType = "pending";
                                          } else if (buttonSelectInt == 1) {
                                            postsType = "accepted";
                                          } else {
                                            postsType = "rejected";
                                          }
                                          dataFun(postsType);
                                        } else {
                                          toastMesg(res['title'], false);
                                        }
                                      });
                                    },
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, dint) {
                                return Divider(
                                  thickness: 1,
                                  color: unslectedButoonColor.withOpacity(0.3),
                                );
                              },
                              itemCount: myPostsController.getMyPosts.length),
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
  int page = 10;
  ScrollController scrollController = ScrollController();
  bool paginationLoading = false;
  loadMoreDataGet() async {
    setState(() {
      paginationLoading = true;
      start = start + page;
    });

    Map mapdata = {
      "customer_id": Constants.prefs!.getString("user_id"),
      "status": (buttonSelectInt == 0)
          ? "pending"
          : (buttonSelectInt == 1)
              ? "accepted"
              : "rejected",
      "start": start.toString(),
      "page": page.toString(),
    };
    print("mapdata.....$mapdata");
    await myPostsController.getMyPostsFun("pagination", start, mapdata);

    Timer(const Duration(seconds: 1), () async {
      setState(() {
        paginationLoading = false;
      });
    });
  }
}
