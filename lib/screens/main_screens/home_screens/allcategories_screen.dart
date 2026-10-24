import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import '../../../commons/colors.dart';
import '../../../commons/common_widgets.dart';
import '../../../commons/constants.dart';
import '../../../controllers/maincontroller.dart';
import 'categoriesposts_screen.dart';

class AllCatagoriesScreen extends StatefulWidget {
  const AllCatagoriesScreen({super.key});

  @override
  State<AllCatagoriesScreen> createState() => _AllCatagoriesScreenState();
}

class _AllCatagoriesScreenState extends State<AllCatagoriesScreen> {
  MainController allcategoryController = Get.put(MainController());
  int? categoryInd;
  dataFun() async {
    await allcategoryController.getAllCategoriesFun("init");
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
          "More".tr(),
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
              categoryInd = null;
            });
          }
          dataFun();
        },
        child: Obx(() {
          return allcategoryController.isloading.value
              ? Center(child: mCircularProgresIndication)
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SpaceHeightWidget(height: 20),
                      (allcategoryController.getAllCategories.isNotEmpty)
                          ? Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              // color: appThemeColor,
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                children: [
                                  for (int i = 0;
                                      i <
                                          allcategoryController
                                              .getAllCategories.length;
                                      i++)
                                    HomeCategoryWidget(
                                        color: (categoryInd == i)
                                            ? orangeColor
                                            : blackColor.withOpacity(0.4),
                                        onTap: () async {
                                          categoryInd = i;
                                          setState(() {});
                                          Timer(
                                              const Duration(milliseconds: 500),
                                              () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CatagoriesPostsScreen(
                                                          from: (allcategoryController
                                                                      .getAllCategories[
                                                                          i]
                                                                      .languageEnglish !=
                                                                  "")
                                                              ? allcategoryController
                                                                  .getAllCategories[
                                                                      i]
                                                                  .languageEnglish
                                                              : allcategoryController
                                                                  .getAllCategories[
                                                                      i]
                                                                  .languageKanada,
                                                          id: allcategoryController
                                                              .getAllCategories[
                                                                  i]
                                                              .id,
                                                          categoryName:
                                                              allcategoryController
                                                                  .getAllCategories[
                                                                      i]
                                                                  .title,
                                                        )));

                                            categoryInd = null;
                                            setState(() {});
                                          });
                                        },
                                        title:
                                            (context.locale.toString() == "en")
                                                ? allcategoryController
                                                    .getAllCategories[i]
                                                    .languageEnglish
                                                : allcategoryController
                                                    .getAllCategories[i]
                                                    .languageKanada,
                                        image: allcategoryController
                                            .getAllCategories[i].image),
                                ],
                              ),
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: Center(
                                  child: Text(
                                "Not avilable".tr(),
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: fontSize10),
                              )),
                            ),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
