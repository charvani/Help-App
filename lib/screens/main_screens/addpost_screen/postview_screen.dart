import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:help_app_flutter/commons/colors.dart';
import 'package:help_app_flutter/commons/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../commons/common_functions.dart';
import '../../../commons/constants.dart';
import '../../../controllers/maincontroller.dart';
import '../../../model/postviewdata_model.dart';

class PostView extends StatefulWidget {
  final String postid, title, categoryName;
  const PostView(
      {super.key,
      required this.postid,
      required this.title,
      required this.categoryName});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  MainController postViewController = Get.put(MainController());
  int activeindx = 0;
  PostViewDataModel _postData = PostViewDataModel(
      description: "",
      categoryId: "",
      requestedId: "",
      id: "",
      title: "",
      name: "",
      mobile: "",
      whatsappNumber: "",
      video: "",
      status: "",
      videoId: "",
      createdDate: "",
      viewCount: "",
      languageEnglish: "",
      languageKanada: "");
  List<dynamic> images = [];
  postFun() async {
    Map mapdata = {
      "posts_id": widget.postid,
      "mobile": Constants.prefs!.getString("mobile")
    };
    print(mapdata);
    dynamic res = await postViewController.getPostViewFun(mapdata);
    if (res['status'] == "valid") {
      if(mounted)
      setState(() {
        _postData = PostViewDataModel.fromJson(res['data']);
      });
      res['image'].forEach((e) {
        images.add(e);
      });
      if (_postData.videoId != null && _postData.videoId != "") {
        setState(() {
          _controller = YoutubePlayerController(
            initialVideoId: _postData.videoId,
            flags: const YoutubePlayerFlags(
              mute: false,
              autoPlay: false,
              disableDragSeek: false,
              loop: false,
              isLive: false,
              forceHD: false,
              enableCaption: true,
            ),
          )..addListener(listener);
          _playerState = PlayerState.unknown;
        });
      }
    }
  }

  YoutubePlayerController _controller =
      YoutubePlayerController(initialVideoId: "");

  late PlayerState _playerState;

  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      postFun();
    });
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
      });
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: appThemeColor,
          toolbarHeight: 330,
          elevation: 0,
          leading: const SizedBox(
            height: 0,
            width: 0,
          ),
          flexibleSpace: SafeArea(
            child: Container(
              // margin: const EdgeInsets.only(top: 30),

              color: whiteColor,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    color: appThemeColor,
                    alignment: Alignment.topLeft,
                    height: 60,
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          alignment: Alignment.topLeft,
                          child: BackIconButton(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              color: whiteColor),
                        ),
                        Container(
                            // width: MediaQuery.of(context).size.width * 0.84,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                      fontFamily: "Poppins SemiBold",
                                      fontSize: fontSize18,
                                      color: whiteColor),
                                ),
                                Text(
                                  "(${widget.categoryName})",
                                  style: TextStyle(
                                      fontFamily: "Poppins SemiBold",
                                      fontSize: fontSize12,
                                      color: whiteColor),
                                )
                              ],
                            )
                            // Text(
                            //   "${widget.title}\n(${widget.categoryName})",
                            //   style: TextStyle(
                            //       fontFamily: "Poppins SemiBold",
                            //       fontSize: fontSize18,
                            //       color: whiteColor),
                            // ),
                            )
                      ],
                    ),
                  ),
                  CarouselSlider(
                    items: [
                      for (int i = 0; i < images.length; i++) bannerImage(i)
                    ],
                    options: CarouselOptions(
                      height: 235,
                      // aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.decelerate,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: const Duration(seconds: 1),
                      viewportFraction: 0.94,
                      autoPlay: true,
                      onPageChanged: (index, reason) =>
                          setState(() => activeindx = index),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < images.length; i++)
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          padding: const EdgeInsets.all(2.0),
                          child: CircleAvatar(
                            radius: activeindx == i ? 6 : 4,
                            backgroundColor:
                                activeindx == i ? appThemeColor : orangeColor,
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        body: (postViewController.isloading.value)
            ? Center(child: mCircularProgresIndication)
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/title.png",
                              color: orangeColor,
                              height: 25,
                            ),
                            const SpaceWidthWidget(width: 10),
                            Text(
                              _postData.title,
                              style: TextStyle(
                                  fontFamily: "Poppins SemiBold",
                                  fontSize: fontSize14 + fontSize8,
                                  color: orangeColor),
                            ),
                          ],
                        ),
                        const SpaceHeightWidget(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Post Id".tr(),
                              style: TextStyle(
                                  fontFamily: "Poppins Medium",
                                  fontSize: fontSize16,
                                  color: blackColor),
                            ),
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: greenColor,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.remove_red_eye,
                                    color: whiteColor,
                                    size: 13,
                                  ),
                                  const SpaceWidthWidget(width: 2),
                                  Text(
                                    (_postData.viewCount != "")
                                        ? _postData.viewCount
                                        : "0",
                                    style: TextStyle(
                                        fontFamily: "Poppins Medium",
                                        fontSize: fontSize10,
                                        color: whiteColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "#${_postData.requestedId}",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: fontSize14,
                              color: blackColor.withOpacity(0.6)),
                        ),
                        const SpaceHeightWidget(height: 10),
                        Text(
                          "Posted By".tr(),
                          style: TextStyle(
                              fontFamily: "Poppins Medium",
                              fontSize: fontSize16,
                              color: blackColor),
                        ),
                        Text(
                          _postData.name,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: fontSize14,
                              color: blackColor.withOpacity(0.6)),
                        ),
                        const SpaceHeightWidget(height: 10),
                        Text(
                          "Posted Date".tr(),
                          style: TextStyle(
                              fontFamily: "Poppins Medium",
                              fontSize: fontSize16,
                              color: blackColor),
                        ),
                        Text(
                          _postData.createdDate,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: fontSize14,
                              color: blackColor.withOpacity(0.6)),
                        ),
                        const SpaceHeightWidget(height: 20),
                        detailsWidget(
                            "assets/images/category.png",
                            "Service Type".tr(),
                            (context.locale.toString() == "en")
                                ? _postData.languageEnglish
                                : _postData.languageKanada,
                            "yes",
                            "service"),
                        const SpaceHeightWidget(height: 25),
                        detailsWidget("assets/images/call3.png", "Call".tr(),
                            _postData.mobile, "no", "call"),
                        const SpaceHeightWidget(height: 25),
                        detailsWidget(
                            "assets/images/WhatsApp.png",
                            "Whatsapp".tr(),
                            _postData.whatsappNumber,
                            "no",
                            "wcall"),
                        const SpaceHeightWidget(height: 25),

                        Text(
                          "Description".tr(),
                          style: TextStyle(
                              fontFamily: "Poppins Medium",
                              fontSize: fontSize16,
                              color: blackColor),
                        ),
                        const SpaceHeightWidget(height: 10),

                        description(_postData.description),
                        const SpaceHeightWidget(height: 25),
                        Text(
                          "Video".tr(),
                          style: TextStyle(
                              fontFamily: "Poppins Medium",
                              fontSize: fontSize16,
                              color: blackColor),
                        ),
                        const SpaceHeightWidget(height: 10),
                        // Container(
                        //     height: 200,
                        //     width: double.infinity,
                        //     alignment: Alignment.center,
                        //     child: _controller.value.isInitialized
                        //         ? VideoPlayer(
                        //             _controller,
                        //           )
                        //         : mCircularProgresIndication),
                        // bannerVideo(_postData.video, _postData.videoId),
                        // Text(_postData.videoId.toString()),
                        // Text(_postData.video.toString()),
                        // Text(_postData.id),
                        (_postData.videoId != "" && _postData.videoId != null)
                            ? YoutubePlayerBuilder(
                                player: YoutubePlayer(
                                  controller: _controller,
                                  showVideoProgressIndicator: false,
                                  progressIndicatorColor: Colors.blueAccent,
                                  onReady: () {
                                    _isPlayerReady = true;
                                  },
                                ),
                                builder: (context, player) {
                                  return ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child:
                                          SizedBox(height: 250, child: player));
                                  // Container(
                                  //   height: 100,
                                  //   width: 100,
                                  //   color: appThemeColor,
                                  // );
                                })
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  height: 200,
                                  alignment: Alignment.center,
                                  color: greyColor,
                                  child: Text(
                                    "Not avilable".tr(),
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: blackColor.withOpacity(0.5),
                                        fontSize: fontSize10),
                                  ),
                                ),
                              ),
                        // bannerVideo(
                        //     "https://www.youtube.com/watch?v=svQOxQde0bg",
                        //     "svQOxQde0bg"),
                        const SpaceHeightWidget(height: 50)
                      ]),
                ),
              ),
      );
    });
  }

  Widget bannerImage(int ind) {
    return Container(
        margin: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              //  images[ind]['image_full_path']
              //                           .replaceAll("https", "http"),
              imageDilog(
                  images[ind]['image_full_path'].replaceAll("https", "http"));
            },
            child: Container(
                width: 400,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.1, color: appThemeColor)),
                child: CachedNetworkImage(
                  imageUrl: images[ind]['image_full_path']
                      .replaceAll("https", "http"),
                  errorWidget: (context, url, error) =>
                      Center(child: mCircularProgresIndication),
                  fit: BoxFit.fill,
                  width: 400,
                )),
          ),
        ));
  }

  Widget detailsWidget(String image, type, data, from, name) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if (_postData.mobile == "" || _postData.whatsappNumber == "") {
          toastMesg("Please take subscription to get details", false);
        } else {
          if (name == "call" && _postData.mobile != "") {
            _makePhoneCall(_postData.mobile);
          } else if (name == "wcall" && _postData.whatsappNumber != "") {
            var whatsappNum = "+91${_postData.whatsappNumber}";

            var whatsappAndroid = Uri.parse(
                "whatsapp://send?phone=$whatsappNum&text=Hi, Myself${Constants.prefs!.getString("name")}, I am looking for #${_postData.requestedId}");
            if (await canLaunchUrl(whatsappAndroid)) {
              await launchUrl(whatsappAndroid);
            } else {
              toastMesg("Whatsapp notAvailable", false);
            }
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: greyColor,
            borderRadius: BorderRadiusDirectional.circular(10)),
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Image.asset(
                image,
                color: orangeColor,
                height: 18,
              ),
              const SpaceWidthWidget(width: 10),
              Text(
                type,
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: fontSize14,
                    color: blackColor.withOpacity(0.6)),
              ),
            ]),
            Text(
              (from != "yes")
                  ? (data != "")
                      ? "+91 $data"
                      : "XX-XXXX-XXXX"
                  : data,
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: fontSize14,
                  color: blackColor.withOpacity(0.6)),
            )
          ],
        ),
      ),
    );
  }

  Widget description(data) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
          color: greyColor, borderRadius: BorderRadiusDirectional.circular(10)),
      padding: const EdgeInsets.all(15),
      child: Text(
        data,
        style: TextStyle(
            fontFamily: "Poppins",
            fontSize: fontSize14,
            color: blackColor.withOpacity(0.6)),
      ),
    );
  }

  Widget bannerVideo(String videolink, videoId) {
    try {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          // await launchUrl(Uri.parse(
          //     // videolink
          //     "https://www.youtube.com/watch?v=$videoId"));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 200,
            width: double.infinity,
            alignment: Alignment.center,
            color: greyColor,
            child: YoutubePlayer(
              showVideoProgressIndicator: true,
              controller: YoutubePlayerController(
                initialVideoId: videoId,
                flags: const YoutubePlayerFlags(
                  autoPlay: false,
                  hideThumbnail: false,
                  hideControls: true,
                  loop: true,
                  mute: true,
                  enableCaption: false,
                  controlsVisibleAtStart: true,
                  disableDragSeek: true,
                ),
              ),
              progressIndicatorColor: appThemeColor,
            ),
          ),
        ),
      );
    } catch (e) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 200,
          alignment: Alignment.center,
          color: greyColor,
          child: Text(
            "Not avilable".tr(),
            style: TextStyle(
                fontFamily: "Poppins",
                color: blackColor.withOpacity(0.5),
                fontSize: fontSize10),
          ),
        ),
      );
    }
  }

  imageDilog(String image) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              titlePadding: EdgeInsets.all(0),
              contentPadding: EdgeInsets.all(0),
              actionsPadding: EdgeInsets.all(0),
              insetPadding: EdgeInsets.all(5),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.45,
                alignment: Alignment.center,
                // color: Colors.amber,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // for (int i = 0; i < images.length; i++)
                          InteractiveViewer(
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: CachedNetworkImage(
                                  imageUrl: image,
                                  // images[i]['image_full_path']
                                  //     .replaceAll("https", "http"),
                                  errorWidget: (context, url, error) =>
                                      Center(child: mCircularProgresIndication),
                                  fit: BoxFit.fill,
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                )),
                          ),
                        ],
                      ),
                    )),
              ),
            ));
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
