import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:get/get.dart';
import 'package:help_app_flutter/commons/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../commons/common_widgets.dart';
import '../../../commons/constants.dart';
import '../../../controllers/maincontroller.dart';
import '../addpost_screen/postview_screen.dart';
import 'allcategories_screen.dart';
import 'categoriesposts_screen.dart';
import 'notification_screen.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool searchWidget = false;
  TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey();
  TextEditingController otpTextController = TextEditingController();
  MainController homeController = Get.put(MainController());
  int scount = 0;
  int? categoryInd;
  int? categorySearchInd;
  bool cAutoPlay = true;
  // YoutubePlayerController _controller =
  //     YoutubePlayerController(initialVideoId: "");
  List<YoutubePlayerController> _controllers = [];
  // late PlayerState _playerState;
  List<PlayerState> playersStates = [];

  // bool _isPlayerReady = false;
  List<bool> _isPlayerReadys = [];
  List<String> _ids = [];
  int? vInd;
  homeDataFun() async {
    Map mapdata = {"mobile": Constants.prefs!.getString("mobile")};
    dynamic res = await homeController.getHomeScreenDatatFun("init", mapdata);
    if (res != null) {
      for (int i = 0;
          i < homeController.getHomeScreenData.banners.length;
          i++) {
        if (homeController.getHomeScreenData.banners[i].type == "video") {
          setState(() {
            _ids.add(homeController.getHomeScreenData.banners[i].videoId);
          });
        }
      }
      for (int i = 0; i < _ids.length; i++) {
        setState(() {
          playersStates.add(PlayerState.unknown);
          _isPlayerReadys.add(false);
          _controllers.add(YoutubePlayerController(
            initialVideoId: _ids[i],
            flags: const YoutubePlayerFlags(
              mute: false,
              autoPlay: false,
              disableDragSeek: false,
              loop: false,
              isLive: false,
              forceHD: false,
              enableCaption: true,
            ),
          )..addListener(listener));
        });
      }
    }
  }

  updateTokenFun() async {
    Map mapdata = {
      "access_token": Constants.prefs!.getString("access_token"),
      "token": Constants.prefs!.getString("device_token"),
    };
    print("mapdata....$mapdata");
    await homeController.getUpdateTokenFun(mapdata);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      homeDataFun();
      updateTokenFun();
    });
  }

  listener() async {
    for (int i = 0; i < _ids.length; i++) {
      if (_isPlayerReadys[i] && mounted) {
        setState(() {
          playersStates[i] = _controllers[i].value.playerState;
          if (playersStates[i] == PlayerState.playing) {
            vInd = i;
          }
        });
        print("mee...$playersStates");
      }
      if (playersStates.contains(PlayerState.playing)) {
        setState(() {
          cAutoPlay = false;
        });
      } else {
        setState(() {
          cAutoPlay = true;
        });
      }
      // if (playersStates[i].toString() == "PlayerState.playing") {
      //   setState(() {
      //     // if(cAutoPlay = false){
      //     _controllers[i].play();

      //     // }else{
      //     // _controllers[i].pause();

      //     // }
      //   });
      // }
    }

    // dynamic res = await cFun();
    // print("res....$res");
    // if (res == "true") {
    //   setState(() {
    //     cAutoPlay = true;
    //   });
    // } else {
    //   setState(() {
    //     cAutoPlay = false;
    //   });
    // }
  }

  String? res;

  String? cFun() {
    for (var v in playersStates) {
      if (v.toString() != "PlayerState.playing") {
        res = "true";
        break;
      } else {
        res = "false";
        break;
      }
    }
    return res;
  }

  @override
  void deactivate() {
    for (int i = 0; i < _controllers.length; i++) {
      // if (mounted) {
      //   setState(() {
      //     _controllers[i].pause();
      //   });
      // }
      if (mounted) {
        _controllers[i].pause();
      }
    }

    super.deactivate();
  }

  @override
  void dispose() {
    for (int i = 0; i < _controllers.length; i++) {
      if (mounted) {
        _controllers[i].dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          toolbarHeight: searchWidget ? 120 : 80,
          elevation: 0,
          leading: Container(),
          centerTitle: false,
          flexibleSpace: Form(
            key: _formkey,
            child: Container(
              decoration: BoxDecoration(
                  color: appThemeColor,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: (!searchWidget)
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "Help App".tr(),
                            style: TextStyle(
                                color: whiteColor,
                                fontFamily: "Poppins Medium",
                                fontSize: fontSize20),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                searchWidget = !searchWidget;
                                if (mounted) {
                                  setState(() {
                                    scount = scount + 1;
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.search_rounded,
                                color: whiteColor,
                                size: 30,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            Obx(() {
                              return homeController.isloading.value
                                  ? mCircularProgresIndication
                                  : NotificationWidget(
                                      iconColor: whiteColor,
                                      badge: homeController
                                          .getHomeScreenData.notification,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const NotificationsScreen(
                                                      from: "home",
                                                    )));
                                      },
                                    );
                            }),
                            const SpaceWidthWidget(width: 20)
                          ],
                        )
                      ],
                    ),
                    if (searchWidget)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 35,
                        ),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          controller: searchController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50),
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z ]")),
                            FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                          ],
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(
                                  Icons.search_rounded,
                                  size: 25,
                                  color: appThemeColor,
                                )),
                            suffixIcon: (searchController.text.length > 2)
                                ? GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      if (mounted) {
                                        setState(() {
                                          searchController.clear();
                                        });
                                      }
                                    },
                                    child: Icon(
                                      (Icons.close),
                                      color: appThemeColor,
                                    ),
                                  )
                                : const SizedBox(
                                    height: 0,
                                    width: 0,
                                  ),
                            hintText: "Search".tr(),
                            hintStyle: TextStyle(
                                fontFamily: "Poppins Medium",
                                fontSize: fontSize14,
                                color: appThemeColor),
                            filled: true,
                            fillColor: greyColor,
                            focusColor: greyColor,
                            hoverColor: greyColor,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: whiteColor)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: whiteColor)),
                          ),
                          onChanged: (val) async {
                            Map mapdata = {"keyword": val.toString()};
                            Timer(const Duration(milliseconds: 500), () async {
                              await homeController.getHomeSearchFun(
                                  true, mapdata);
                              if (mounted) setState(() {});
                            });
                          },
                        ),
                      ),
                    const SpaceHeightWidget(height: 10)
                  ],
                ),
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          color: appThemeColor,
          onRefresh: () async {
            if (mounted) {
              setState(() {
                searchWidget = false;
              });
            }
            homeDataFun();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Obx(() {
              return homeController.isloading.value
                  ? SizedBox(
                      height: 800,
                      child: Center(child: mCircularProgresIndication))
                  : Stack(
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CarouselSlider(
                                      items: [
                                        for (int i = 0;
                                            i <
                                                homeController.getHomeScreenData
                                                    .banners.length;
                                            i++)
                                          if (homeController.getHomeScreenData
                                                  .banners[i].type ==
                                              "image")
                                            bannerImage(i),
                                        for (int i = 0; i < _ids.length; i++)
                                          Container(
                                            margin: const EdgeInsets.all(4),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: YoutubePlayerBuilder(
                                                  player: YoutubePlayer(
                                                    controller: _controllers[i],
                                                    showVideoProgressIndicator:
                                                        false,
                                                    progressIndicatorColor:
                                                        Colors.blueAccent,
                                                    onReady: () {
                                                      _isPlayerReadys[i] = true;
                                                    },
                                                  ),
                                                  builder: (context, player) {
                                                    return player;
                                                  }),
                                            ),
                                          )
                                      ],
                                      options: CarouselOptions(
                                          height: 180.0,
                                          // aspectRatio: 16 / 11,
                                          autoPlayCurve: Curves.decelerate,
                                          enableInfiniteScroll: true,
                                          autoPlayAnimationDuration:
                                              const Duration(seconds: 1),
                                          viewportFraction: 0.94,
                                          autoPlay: cAutoPlay,
                                          onPageChanged: (index, reason) {
                                            if (vInd != null) {
                                              setState(() {
                                                _controllers[vInd!].pause();
                                              });
                                            }
                                            // if (playersStates.contains(
                                            //     PlayerState.playing)) {
                                            //   setState(() {
                                            //     cAutoPlay = false;
                                            //   });
                                            // } else {
                                            //   setState(() {
                                            //     cAutoPlay = true;
                                            //   });
                                            // }
                                            // await checkFun();
                                          })),

                                  const SpaceHeightWidget(height: 20),

                                  Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    child: Wrap(
                                      alignment: WrapAlignment.start,
                                      children: [
                                        for (int i = 0;
                                            i <
                                                homeController.getHomeScreenData
                                                    .categories.length;
                                            i++)
                                          HomeCategoryWidget(
                                              color: (categoryInd == i)
                                                  ? orangeColor
                                                  : blackColor.withOpacity(0.4),
                                              onTap: () async {
                                                categoryInd = i;
                                                if (mounted) setState(() {});
                                                Timer(
                                                    const Duration(
                                                        milliseconds: 500), () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CatagoriesPostsScreen(
                                                                from: (context
                                                                            .locale
                                                                            .toString() ==
                                                                        "en")
                                                                    ? homeController
                                                                        .getHomeScreenData
                                                                        .categories[
                                                                            i]
                                                                        .languageEnglish
                                                                    : homeController
                                                                        .getHomeScreenData
                                                                        .categories[
                                                                            i]
                                                                        .languageKanada,
                                                                id: homeController
                                                                    .getHomeScreenData
                                                                    .categories[
                                                                        i]
                                                                    .id,
                                                                categoryName:
                                                                    homeController
                                                                        .getHomeScreenData
                                                                        .categories[
                                                                            i]
                                                                        .title,
                                                              )));

                                                  categoryInd = null;
                                                  if (mounted) setState(() {});
                                                });
                                              },
                                              title:
                                                  (context.locale.toString() ==
                                                          "en")
                                                      ? homeController
                                                          .getHomeScreenData
                                                          .categories[i]
                                                          .languageEnglish
                                                      : homeController
                                                          .getHomeScreenData
                                                          .categories[i]
                                                          .languageKanada,
                                              image: homeController
                                                  .getHomeScreenData
                                                  .categories[i]
                                                  .image),
                                        moreWidget()
                                      ],
                                    ),
                                  ),
                                  // if (homeController
                                  //     .getHomeScreenData.recentPost.isNotEmpty)
                                  Text(
                                    "Recent Posts".tr(),
                                    style: TextStyle(
                                        fontFamily: "Poppins Medium",
                                        fontSize: fontSize20),
                                  ),
                                  (homeController
                                          .getHomeScreenData.recentPost.isEmpty)
                                      ? SizedBox(
                                          width: double.infinity,
                                          height: 100,
                                          child: Center(
                                            child: Text(
                                              "Not avilable".tr(),
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: fontSize10),
                                            ),
                                          ),
                                        )
                                      : SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              for (int i = 0;
                                                  i <
                                                      homeController
                                                          .getHomeScreenData
                                                          .recentPost
                                                          .length;
                                                  i++)
                                                recentPost(i),
                                            ],
                                          ),
                                        )
                                ]),
                          ),
                        ),
                        if (searchWidget == true)
                          Obx(() {
                            return (homeController.isloading.value)
                                ? wCircularProgresIndication
                                : SingleChildScrollView(
                                    child: (scount == 1 &&
                                            searchController.text == "")
                                        ? Container(
                                            height: 0,
                                            width: 0,
                                          )
                                        : Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(25),
                                            decoration: BoxDecoration(
                                                color: whiteColor,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(
                                                                10)),
                                                border: Border.all(
                                                    color: appThemeColor,
                                                    width: 3)),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  if (homeController
                                                      .getHomeSearch.isEmpty)
                                                    Center(
                                                        child: Text(
                                                      "Not avilable".tr(),
                                                      style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          fontSize: fontSize10),
                                                    )),
                                                  // : const SizedBox(
                                                  //     height: 0,
                                                  //     width: 0,
                                                  //   )
                                                  if (homeController
                                                      .getHomeSearch.isNotEmpty)
                                                    categorySearchWidget(),
                                                  const SpaceHeightWidget(
                                                      height: 20)
                                                ]),
                                          ),
                                  );
                          })
                      ],
                    );
            }),
          ),
        ));
  }

  Widget bannerImage(int ind) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
            width: 600,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: appThemeColor
                // borderRadius: BorderRadius.circular(20),
                ),
            // width: 300,
            child: CachedNetworkImage(
              imageUrl: homeController.getHomeScreenData.banners[ind].image
                  .replaceAll("https", "http"),
              errorWidget: (context, url, error) =>
                  Center(child: mCircularProgresIndication),
              height: 200,
              fit: BoxFit.fill,
              width: 600,
            )),
      ),
    );
  }

  // Widget bannerVideo(String videoId) {
  //   // final splitted = videolink.split('v=');

  //   _controller = YoutubePlayerController(
  //     initialVideoId: videoId,
  //     //  _postData.videoId,
  //     flags: const YoutubePlayerFlags(
  //       mute: false,
  //       autoPlay: false,
  //       disableDragSeek: false,
  //       loop: false,
  //       isLive: false,
  //       forceHD: false,
  //       enableCaption: true,
  //     ),
  //   )..addListener(listener);
  //   try {
  //     return Container(
  //       margin: const EdgeInsets.all(4),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(20),
  //         child: Container(
  //           height: 200,
  //           width: 600,
  //           alignment: Alignment.center,
  //           color: greyColor,
  //           child: YoutubePlayerBuilder(
  //               player: YoutubePlayer(
  //                 controller: _controller,
  //                 showVideoProgressIndicator: false,
  //                 progressIndicatorColor: Colors.blueAccent,
  //                 onReady: () {
  //                   _isPlayerReady = true;
  //                 },
  //               ),
  //               builder: (context, player) {
  //                 return player;
  //                 // Container(
  //                 //   height: 100,
  //                 //   width: 100,
  //                 //   color: appThemeColor,
  //                 // );
  //               }),

  //           // YoutubePlayer(
  //           //   actionsPadding: const EdgeInsets.all(0.0),
  //           //   showVideoProgressIndicator: true,
  //           //   aspectRatio: 16 / 10,
  //           //   controller: YoutubePlayerController(
  //           //     initialVideoId: splitted[1],
  //           //     flags: const YoutubePlayerFlags(
  //           //       autoPlay: false,
  //           //       hideThumbnail: false,
  //           //       hideControls: true,
  //           //       loop: true,
  //           //       mute: true,
  //           //       enableCaption: false,
  //           //       controlsVisibleAtStart: true,
  //           //       disableDragSeek: true,
  //           //     ),
  //           //   ),
  //           //   progressIndicatorColor: appThemeColor,
  //           // ),
  //         ),
  //       ),
  //     );
  //   } catch (e) {
  //     return Container(
  //       margin: const EdgeInsets.all(4),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(20),
  //         child: Container(
  //           width: 400,
  //           alignment: Alignment.center,
  //           color: greyColor,
  //           child: Text(
  //             "Not avilable".tr(),
  //             style: TextStyle(
  //                 fontFamily: "Poppins",
  //                 color: blackColor.withOpacity(0.5),
  //                 fontSize: fontSize10),
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  // }

  Widget recentPost(int i) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostView(
                      postid: homeController.getHomeScreenData.recentPost[i].id,
                      title:
                          homeController.getHomeScreenData.recentPost[i].title,
                      categoryName: homeController
                          .getHomeScreenData.recentPost[i].categoryName
                          .toString(),
                    )));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: appThemeColor.withOpacity(0.1))),
            height: 240,
            width: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: homeController.getHomeScreenData.recentPost[i].image!
                    .replaceAll("https", "http"),
                errorWidget: (context, url, error) =>
                    Center(child: mCircularProgresIndication),
                fit: BoxFit.fill,
                height: 240,
                width: 200,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  homeController.getHomeScreenData.recentPost[i].title,
                  style: TextStyle(
                      fontFamily: "Poppins SemiBold",
                      fontSize: fontSize16,
                      overflow: TextOverflow.ellipsis,
                      color: orangeColor),
                ),
                Text(
                  homeController.getHomeScreenData.recentPost[i].name,
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: fontSize12,
                      overflow: TextOverflow.ellipsis,
                      color: blackColor),
                ),
                if (homeController.getHomeScreenData.recentPost[i].mobile != "")
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/Call.png",
                        color: appThemeColor,
                      ),
                      const SpaceWidthWidget(width: 2),
                      Text(
                        homeController.getHomeScreenData.recentPost[i].mobile,
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: fontSize12,
                            color: blackColor.withOpacity(0.5)),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String moreSelect = "no";
  Widget moreWidget() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        // categoryInd = i;
        if (categoryInd == null) {
          if (mounted) {
            setState(() {
              moreSelect = "yes";
            });
          }

          Timer(const Duration(milliseconds: 500), () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AllCatagoriesScreen()));

            categoryInd = null;
            moreSelect = "no";
            if (mounted) setState(() {});
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
        decoration: BoxDecoration(
            border: Border.all(
                color: (moreSelect == "yes")
                    ? orangeColor
                    : blackColor.withOpacity(0.4),
                width: 1),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        height: 100,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/More.png",
              height: 50,
              width: 50,
            ),
            const SpaceHeightWidget(height: 3),
            Text(
              "More".tr(),
              style: TextStyle(fontFamily: "Poppins", fontSize: fontSize10),
            )
          ],
        ),
      ),
    );
  }

  Widget categorySearchWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < homeController.getHomeSearch.length; i++)
          HomeSearchWidget(
              color: (categorySearchInd == i)
                  ? orangeColor
                  : blackColor.withOpacity(0.4),
              onTap: () async {
                categorySearchInd = i;
                if (mounted) {
                  setState(() {});
                }
                Timer(const Duration(milliseconds: 500), () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CatagoriesPostsScreen(
                                from: homeController.getHomeSearch[i].title
                                    .toString(),
                                id: homeController.getHomeSearch[i].id,
                                categoryName:
                                    homeController.getHomeSearch[i].title,
                              )));

                  categorySearchInd = null;
                  if (mounted) {
                    setState(() {});
                  }
                });
              },
              title: homeController.getHomeSearch[i].title,
              image: homeController.getHomeSearch[i].image)
      ],
    );
  }

  // checkFun() {
  //   for (int i = 0; i < _ids.length; i++) {
  //     if (playersStates[i] == PlayerState.playing) {
  //       print("mmmmmmmm");
  //       setState(() {
  //         _controllers[i].pause();
  //       });
  //     }
  //   }
  // }
}
