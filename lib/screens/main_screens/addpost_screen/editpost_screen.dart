import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:help_app_flutter/screens/main_screens/bottombar_screen/bottombar_screen.dart';
import 'package:help_app_flutter/screens/main_screens/myaccount_screens/subscription_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../commons/colors.dart';
import '../../../commons/common_functions.dart';
import '../../../commons/common_widgets.dart';
import '../../../commons/constants.dart';
import '../../../controllers/maincontroller.dart';
import '../../../model/postviewdata_model.dart';
import 'sucesspost_screen.dart';
import 'package:http/http.dart' as http;

class EditPostScreen extends StatefulWidget {
  final String postId;
  const EditPostScreen({super.key, required this.postId});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController whatsappNumController = TextEditingController();
  TextEditingController youtubeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  MainController editPostController = Get.put(MainController());
  bool clickTap = false;
  List<File> propertyImagesList = [];
  File? video;
  String? selectedId;
  String? mobile;
  String? name;
  PostViewDataModel _postData = PostViewDataModel(
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
      viewCount: "",
      languageEnglish: "",
      languageKanada: "",
      description: "",
      createdDate: "");
  List<dynamic> images = [];

  postFun() async {
    Map mapdata = {
      "posts_id": widget.postId,
      "mobile": Constants.prefs!.getString("mobile")
    };
    dynamic res = await editPostController.getPostViewFun(mapdata);
    if (res['status'] == "valid") {
      setState(() {
        _postData = PostViewDataModel.fromJson(res['data']);
      });
      res['image'].forEach((e) {
        images.add(e);
      });

      setState(() {
        titleController.text = _postData.title;
        whatsappNumController.text = _postData.whatsappNumber;
        youtubeController.text = _postData.video;
        descriptionController.text = _postData.description;
      });
      for (int i = 0; i < editPostController.getAllCategories.length; i++) {
        if (editPostController.getAllCategories[i].id == _postData.categoryId) {
          setState(() {
            selectedId = _postData.categoryId;
            slectedCat = editPostController.getAllCategories[i].title;
          });
        }
      }
      if (images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          print(i);
          var previousImage = await fileFromImageUrl(
              images[i]['image_full_path'], i.toString());

          propertyImagesList.add(previousImage);
          finalImagesList.add(images[i]['image']);
          if (mounted) setState(() {});
        }
      }
    }
  }

  Future<File> fileFromImageUrl(String url, String userName) async {
    final response = await http.get(
      Uri.parse(url),
    );
    final documentDirectory;
    if (Platform.isAndroid) {
      documentDirectory = await getExternalStorageDirectory();
    } else {
      documentDirectory = await getApplicationDocumentsDirectory();
    }
    var randomNumber = Random();

    final file = File(
        "${documentDirectory.path}${randomNumber.nextInt(100)}_$userName.png");

    file.writeAsBytesSync(response.bodyBytes);

    return file;
  }

  @override
  void initState() {
    super.initState();
    mobile = Constants.prefs!.getString("mobile");
    name = Constants.prefs!.getString("name");

    print("post id...${widget.postId}");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      dynamic res = await editPostController.getAllCategoriesFun("init");
      if (res != null) {
        postFun();
      }
      setState(() {
        mobileController.text = mobile!;
        nameController.text = name!;
      });
      await editPostController.getYoutubeInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: commonAppBar(context, "Posts".tr()),
        body: Form(
          key: _formkey,
          child: Container(
            color: whiteColor,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SpaceHeightWidget(height: 10),
                      Obx(() {
                        return editPostController.isloading.value
                            ? Center(child: mCircularProgresIndication)
                            : categoryType();
                      }),
                      const SpaceHeightWidget(height: 20),
                      CommonTextFormField(
                          hinttext: "Title".tr(),
                          keyboard: TextInputType.name,
                          textCapital: TextCapitalization.words,
                          tcontroller: titleController,
                          inputformatters: [
                            LengthLimitingTextInputFormatter(50),
                            // FilteringTextInputFormatter.allow(RegExp("[A-Za-z ]")),
                            FilteringTextInputFormatter.deny(RegExp(r'^ ')),
                          ],
                          imagePath: "assets/images/title.svg",
                          validation: (value) {
                            if (value!.isEmpty) {
                              return "Please enter title".tr();
                            } else if (value.length < 3) {
                              return "Please enter proper title".tr();
                            } else {
                              return null;
                            }
                          }),
                      const SpaceHeightWidget(height: 20),
                      CommonTextFormField(
                          read: true,
                          hinttext: "Name".tr(),
                          keyboard: TextInputType.name,
                          textCapital: TextCapitalization.words,
                          tcontroller: nameController,
                          inputformatters: [
                            LengthLimitingTextInputFormatter(50),
                            FilteringTextInputFormatter.allow(
                                RegExp("[A-Za-z ]")),
                            FilteringTextInputFormatter.deny(RegExp(r'^ ')),
                          ],
                          imagePath: "assets/images/person.svg",
                          validation: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your name".tr();
                            } else if (value.length < 3) {
                              return "Please enter proper name".tr();
                            } else {
                              return null;
                            }
                          }),
                      const SpaceHeightWidget(height: 20),
                      CommonTextFormField(
                          hinttext: "Mobile Number".tr(),
                          keyboard: TextInputType.number,
                          textCapital: TextCapitalization.none,
                          tcontroller: mobileController,
                          read: true,
                          inputformatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                            FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                          ],
                          imagePath: "assets/images/call-2.svg",
                          validation: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your mobile number".tr();
                            } else if (value.length < 10) {
                              return "Please enter 10 digits".tr();
                            } else {
                              return null;
                            }
                          }),
                      const SpaceHeightWidget(height: 20),
                      CommonTextFormField(
                          hinttext: "Whatsapp Number".tr(),
                          keyboard: TextInputType.number,
                          textCapital: TextCapitalization.none,
                          tcontroller: whatsappNumController,
                          inputformatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                            FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                          ],
                          imagePath: "assets/images/WhatsApp.svg",
                          validation: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your Whatsapp number".tr();
                            } else if (value.length < 10) {
                              return "Please enter 10 digits".tr();
                            } else {
                              return null;
                            }
                          }),
                      const SpaceHeightWidget(height: 20),
                      TextFormField(
                          textAlignVertical: TextAlignVertical.top,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textCapitalization: TextCapitalization.sentences,
                          controller: descriptionController,
                          textInputAction: TextInputAction.newline,
                          inputFormatters: [
                            // LengthLimitingTextInputFormatter(50),
                            // FilteringTextInputFormatter.allow(RegExp("[A-Za-z ]")),
                          ],
                          cursorColor: orangeColor,
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                          // minLines: 1,
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              labelText: "Description".tr(),
                              labelStyle: hintStyle,
                              hintText: "Add Description".tr(),
                              hintStyle: hintStyle,
                              filled: true,
                              fillColor: greyColor,
                              focusColor: greyColor,
                              hoverColor: greyColor,
                              // border:
                              errorBorder: errorBorder,
                              focusedBorder: normalBorder,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: whiteColor)),
                              focusedErrorBorder: errorBorder),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your description".tr();
                            } else {
                              return null;
                            }
                          }),
                      const SpaceHeightWidget(height: 20),
                      CommonTextFormField(
                          hinttext: "Youtube Video Link".tr(),
                          keyboard: TextInputType.name,
                          textCapital: TextCapitalization.none,
                          tcontroller: youtubeController,
                          inputformatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'^ +')),
                          ],
                          imagePath: "assets/images/Add Video.svg",
                          validation: (val) {
                            if (val!.isNotEmpty) {
                              RegExp regExp = RegExp(
                                  r'^((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?$');
                              String? matches = regExp.stringMatch(val);
                              if (matches == null) {
                                return "Please enter valid link"
                                    .tr(); // Always returns here while the video URL is in the content paramter
                              } else {
                                return null;
                              }
                            } else {
                              return null;
                            }
                          }),
                      const SpaceHeightWidget(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SpaceWidthWidget(width: 5),
                          Text(
                              "${"Example link".tr()}: https://www.youtube.com/watch?v=VQKMoT-6XSg",
                              style: TextStyle(
                                  fontSize: fontSize12,
                                  color: blackColor.withOpacity(0.5))),
                        ],
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          // setState(() {
                          //   clickTap = true;
                          // });
                          yInfoDilog();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SpaceWidthWidget(width: 5),
                            RichText(
                              text: TextSpan(
                                  text:
                                      "${"How to get youtube video link".tr()}?",
                                  style: TextStyle(
                                      fontSize: fontSize12,
                                      color: blackColor.withOpacity(0.5)),
                                  children: [
                                    TextSpan(
                                      text: " ${"click here".tr()}!",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: fontSize12,
                                          color: appThemeColor),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                      const SpaceHeightWidget(height: 20),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: blackColor.withOpacity(0.2), width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 15, left: 20, right: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Upload Images".tr(),
                                      style: TextStyle(
                                          fontFamily: "Poppins SemiBold",
                                          fontSize: fontSize12),
                                    ),
                                    if (propertyImagesList.isNotEmpty)
                                      CircleAvatar(
                                        backgroundColor:
                                            Colors.black12.withOpacity(0.1),
                                        child: IconButton(
                                            onPressed: () {
                                              chooseImage("image");
                                            },
                                            color: blackColor,
                                            icon: const Icon(Icons.add)),
                                      )
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: blackColor.withOpacity(0.2),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  "Upload clear images in different perspectives, for at least 3 Images"
                                      .tr(),
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: fontSize10),
                                ),
                              ),
                              imageWidget(),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 20, top: 5),
                                child: Text(
                                  "supported Format JPEG,PNG".tr(),
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: fontSize10),
                                ),
                              ),
                            ],
                          )),
                      const SpaceHeightWidget(height: 20),
                      CommonElvButton(
                        onTap: () {
                          submitFun(context);
                        },
                        name: "SUBMIT".tr(),
                        loading: bLoading,
                      ),
                      const SpaceHeightWidget(height: 10),
                    ],
                  ),
                ),
                // (clickTap)
                //     ? Container(
                //         alignment: Alignment.center,
                //         height: MediaQuery.of(context).size.height * 1,
                //         child: youtubeDilog())
                //     : const SizedBox(
                //         height: 0,
                //         width: 0,
                //       )
              ],
            ),
          ),
        ));
  }

  bool bLoading = false;
  String? slectedCat;

  Widget categoryType() {
    return DropdownButtonFormField(
      value: slectedCat,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      icon: const Icon(Icons.keyboard_arrow_down_outlined),
      focusColor: Colors.white,
      decoration: InputDecoration(
          isDense: true,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset("assets/images/category.svg"),
          ),
          labelText: "Category".tr(),
          labelStyle: hintStyle,
          hintText: "Select Category".tr(),
          hintStyle: hintStyle,
          filled: true,
          fillColor: greyColor,
          focusColor: greyColor,
          hoverColor: greyColor,
          // border:
          errorBorder: errorBorder,
          focusedBorder: normalBorder,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: whiteColor)),
          focusedErrorBorder: errorBorder),
      items: [
        for (int i = 0; i < editPostController.getAllCategories.length; i++)
          DropdownMenuItem(
            value: editPostController.getAllCategories[i].title,
            child: Text(
              // editPostController.getAllCategories[i].title,
              (context.locale.toString() == "en")
                  ? editPostController.getAllCategories[i].languageEnglish
                  : editPostController.getAllCategories[i].languageKanada,
              style: TextStyle(fontSize: fontSize16, fontFamily: "Poppins"),
            ),
            onTap: () {
              setState(() {
                slectedCat = editPostController.getAllCategories[i].title;
                selectedId = editPostController.getAllCategories[i].id;
              });
            },
          ),
      ],
      onChanged: (String? newValue) {},
      validator: (newValue) {
        if (newValue == null) {
          return 'Please select category'.tr();
        } else {
          return null;
        }
      },
    );
  }

  void chooseImage(String from) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          // backgroundColor: Colors.red,
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            height: 100,
            width: 300,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                        radius: 25,
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: appThemeColor,
                          child: IconButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: () {
                                if (from == "image") {
                                  picker("camera");
                                }
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                size: 20,
                                color: Colors.white,
                              )),
                        )),
                    const SizedBox(
                      height: 4,
                    ),
                    Text("Camera".tr())

                    // "Camera"),
                  ],
                ),
                Column(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: appThemeColor,
                        child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              if (from == "image") {
                                picker("gallery");
                              }
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.photo_library_outlined,
                              size: 20,
                              color: Colors.white,
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text("Gallery".tr())
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  bool imageLoading = false;
  List<String> finalImagesList = [];
  String? imageData;
  Future picker(String type) async {
    ImageSource? pickType;
    if (type == "gallery") {
      pickType = ImageSource.gallery;
    } else {
      pickType = ImageSource.camera;
    }
    try {
      final image = await ImagePicker().pickImage(
        source: pickType,
        imageQuality: 20,
      );
      if (image == null) return;

      File fileimgage = File(image.path);
      XFile? imgexfile = XFile(fileimgage.path);

      setState(() {
        imageLoading = true;
      });

      dynamic res =
          await editPostController.getImageUploadFun(imgexfile.path, "posts");

      if (res['status'] == true) {
        setState(() {
          propertyImagesList.add(fileimgage);

          finalImagesList.add(res['image']);
        });
      }
    } catch (e) {
      toastMesg("Please try again".tr(), false);
    }
    setState(() {
      imageLoading = false;
    });
  }

  deleteFun(int i) {
    yesNoDilog(context, "${"Do you want to delete the image".tr()}?", () async {
      propertyImagesList.remove(propertyImagesList[i]);
      finalImagesList.remove(finalImagesList[i]);
      setState(() {});
      Navigator.pop(context);
    });
  }

  Widget imageWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 4, top: 4),
                child: (propertyImagesList.isNotEmpty)
                    ? Row(
                        children: [
                          for (int i = 0; i < propertyImagesList.length; i++)
                            GestureDetector(
                              onTap: () async {
                                await imageDilog();
                              },
                              child: Container(
                                alignment: Alignment.topRight,
                                margin: const EdgeInsets.only(right: 6),
                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                width:
                                    MediaQuery.of(context).size.height * 0.14,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: orangeColor,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image:
                                            FileImage(propertyImagesList[i]))),
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.white54,
                                  child: IconButton(
                                      onPressed: () {
                                        deleteFun(i);
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color: redColor,
                                        size: 19,
                                      ),
                                      padding: const EdgeInsets.all(0),
                                      alignment: Alignment.topRight),
                                ),
                              ),
                            ),
                          imageLoading
                              ? Center(child: mCircularProgresIndication)
                              : Container()
                        ],
                      )
                    : GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          chooseImage("image");
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.14,
                          width: MediaQuery.of(context).size.height * 0.14,
                          padding: const EdgeInsets.only(
                              left: 4, right: 4, top: 4, bottom: 4),
                          child: Container(
                            decoration: BoxDecoration(
                                color: greyColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: imageLoading
                                  ? Center(child: mCircularProgresIndication)
                                  : Container(
                                      padding: const EdgeInsets.only(
                                          // left: 14,
                                          // right: 4,
                                          ),
                                      child: Image.asset(
                                        "assets/images/imagepic.png",
                                        height: 20,
                                        color: blackColor.withOpacity(0.3),
                                      )),
                            ),
                          ),
                        ),
                      )),
          ],
        ),
      ),
    );
  }

  submitFun(cont) async {
    if (_formkey.currentState!.validate() && bLoading == false) {
      if (propertyImagesList.isEmpty && youtubeController.text == "") {
        toastMesg(
            "Please upload images or  enter youtube video link".tr(), false);
      } else if (propertyImagesList.isNotEmpty &&
          propertyImagesList.length < 3) {
        toastMesg("Please upload minimum 3 images".tr(), false);
      } else {
        setState(() {
          bLoading = true;
        });
        Map mapdata = {
          "customer_id": Constants.prefs!.getString("user_id"),
          "category_id": selectedId,
          "title": titleController.text,
          "name": nameController.text,
          "mobile": mobileController.text,
          "whatsapp_number": whatsappNumController.text,
          "image": finalImagesList.join(','),
          "video": youtubeController.text,
          "id": widget.postId,
          "description": descriptionController.text
        };
        print("post mapdata......$mapdata");
        dynamic res = await editPostController.getEditPostFun(mapdata);
        if (res['status'] == "valid") {
          Navigator.pushAndRemoveUntil(
              cont,
              MaterialPageRoute(
                  builder: (cont) => const BottomBarScreen(
                        index: 3,
                      )),
              (route) => false);
        } else {
          toastMesg(res['title'], false);
          // if (res["is_subscribe"] == "no") {
          //   noSubscriptionFun(cont);
          // }
        }
      }
      setState(() {
        bLoading = false;
      });
    }
  }

  noSubscriptionFun(cont) async {
    dynamic fromSubscription;
    yesNoDilog(cont, "To continue posting please take subscription".tr(),
        () async {
      fromSubscription = await Navigator.push(
          cont,
          MaterialPageRoute(
              builder: (cont) => const SubscriptionScreen(
                    from: "post",
                  )));
    });
    if (fromSubscription != null) {
      submitFun(cont);
    }
  }

  imageDilog() {
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
                    padding: EdgeInsets.all(0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (int i = 0; i < propertyImagesList.length; i++)
                            InteractiveViewer(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Image.file(
                                  propertyImagesList[i],
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                ),
                              ),
                            ),
                        ],
                      ),
                    )),
              ),
            ));
  }

  Widget youtubeDilog() {
    return Container(
      color: whiteColor,
      child: Container(
        decoration: BoxDecoration(
            color: blackColor.withOpacity(0.05),
            border: Border.all(width: 1, color: appThemeColor),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Youtube link information",
                      style: TextStyle(
                          fontFamily: "Poppin SemiBold",
                          fontSize: fontSize16,
                          color: blackColor),
                    ),
                  ],
                ),
                const SpaceHeightWidget(height: 10),
                Html(
                  tagsList: Html.tags,
                  data: editPostController.getYoutubeInformation,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButtonWidget(
                        name: "Close",
                        textStyle: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: fontSize14,
                          color: redColor,
                        ),
                        onTapFun: () {
                          setState(() {
                            clickTap = false;
                          });
                        }),
                  ],
                )
              ]),
        ),
      ),
    );
  }

  yInfoDilog() {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String text = editPostController.getYoutubeInformation.replaceAll(exp, '');
    return showDialog(
        barrierDismissible: false,
        useSafeArea: true,
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (BuildContext cont, StateSetter myState) {
              return AlertDialog(
                  title: Text(
                    "Youtube link information".tr(),
                    style: TextStyle(
                        fontFamily: "Poppin SemiBold",
                        fontSize: fontSize16,
                        color: blackColor),
                  ),
                  content: Text(
                    text,
                    style: TextStyle(
                        fontFamily: "Poppin",
                        fontSize: fontSize12,
                        color: blackColor.withOpacity(0.5)),
                  ),
                  // Html(
                  //   tagsList: Html.tags,
                  //   data: addPostController.getYoutubeInformation,
                  // ),
                  // Text(t2),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Close".tr(),
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: fontSize14,
                            color: redColor,
                          ),
                        )),
                  ]);
            }));
  }
}
