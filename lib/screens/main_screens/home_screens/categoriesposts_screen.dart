import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:help_app_flutter/screens/main_screens/addpost_screen/postview_screen.dart';

import '../../../commons/colors.dart';
import '../../../commons/common_widgets.dart';
import '../../../commons/constants.dart';
import '../../../controllers/maincontroller.dart';

class CatagoriesPostsScreen extends StatefulWidget {
  final String from, id, categoryName;

  const CatagoriesPostsScreen(
      {super.key,
      required this.from,
      required this.id,
      required this.categoryName});

  @override
  State<CatagoriesPostsScreen> createState() => _CatagoriesPostsScreenState();
}

class _CatagoriesPostsScreenState extends State<CatagoriesPostsScreen> {
  MainController categoryController = Get.put(MainController());
  categoryDataFun() async {
    Map mapdata = {
      "category_id": widget.id,
      "start": start.toString(),
      "page": page.toString(),
      "mobile": Constants.prefs!.getString("mobile")
    };
    await categoryController.getCategoriesPostsFun("init", start, mapdata);
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
      categoryDataFun();
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
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          widget.from,
          style: TextStyle(
              fontFamily: "Poppins SemiBold",
              fontSize: fontSize20,
              color: blackColor),
        ),
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
          categoryDataFun();
        },
        child: Obx(() {
          return categoryController.isloading.value
              ? Center(child: mCircularProgresIndication)
              : categoryController.getCategoriesPosts.isEmpty
                  ? ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (context, ind) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
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
                              itemCount:
                                  categoryController.getCategoriesPosts.length,
                              itemBuilder: (context, i) {
                                return CategoryWidget(
                                  imagename: categoryController
                                      .getCategoriesPosts[i].postImage,
                                  personImage: categoryController
                                      .getCategoriesPosts[i].profileImage,
                                  name: categoryController
                                      .getCategoriesPosts[i].name,
                                  title: categoryController
                                      .getCategoriesPosts[i].title,
                                  mobile: categoryController
                                      .getCategoriesPosts[i].mobile,
                                  whatsapp: categoryController
                                      .getCategoriesPosts[i].whatsappNumber,
                                  postid: categoryController
                                      .getCategoriesPosts[i].requestId,
                                  date: categoryController
                                      .getCategoriesPosts[i].createdDate,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PostView(
                                                  postid: categoryController
                                                      .getCategoriesPosts[i].id,
                                                  title: categoryController
                                                      .getCategoriesPosts[i]
                                                      .title,
                                                  categoryName:
                                                      widget.categoryName,
                                                )));
                                  },
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
  int page = 10;
  ScrollController scrollController = ScrollController();
  bool paginationLoading = false;
  loadMoreDataGet() async {
    setState(() {
      paginationLoading = true;
      start = start + page;
    });

    Map mapdata = {
      "category_id": widget.id,
      "start": start.toString(),
      "page": page.toString(),
      "mobile": Constants.prefs!.getString("mobile")
    };
    await categoryController.getCategoriesPostsFun(
        "pagination", start, mapdata);

    Timer(const Duration(seconds: 1), () async {
      setState(() {
        paginationLoading = false;
      });
    });
  }
}
