import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:help_app_flutter/commons/colors.dart';
import 'package:help_app_flutter/commons/common_widgets.dart';
import 'package:help_app_flutter/commons/constants.dart';
import 'package:help_app_flutter/screens/introduction_screens/language_selection_screen.dart';
import 'package:help_app_flutter/screens/main_screens/bottombar_screen/bottombar_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../../../commons/common_functions.dart';
import '../../../controllers/maincontroller.dart';

class MyProfileScreen extends StatefulWidget {
  final String id, name, image, mail, gender, location, fullImage;
  const MyProfileScreen(
      {super.key,
      required this.name,
      required this.id,
      required this.image,
      required this.mail,
      required this.gender,
      required this.fullImage,
      required this.location});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  MainController myProfieController = Get.put(MainController());
  final GlobalKey<FormState> _formkey = GlobalKey();
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  bool edit = false;
  String? finalImage;
  @override
  void initState() {
    super.initState();
    String gen = widget.gender;
    setState(() {
      mobileController.text = Constants.prefs!.getString("mobile").toString();
      nameController.text = widget.name;
      mailController.text = widget.mail;
      locationController.text = widget.location;
      genderVal = gen.capitalizeFirst;
      finalImage = widget.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Form(
        key: _formkey,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              centerTitle: true,
              elevation: 0,
              floating: true,
              pinned: true,
              stretch: true,
              // shadowColor: redColor,
              title: Text(
                "My Profile".tr(),
                style: TextStyle(
                    fontFamily: "Poppins SemiBold",
                    fontSize: fontSize16,
                    color: whiteColor),
              ),
              flexibleSpace: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.205,
                      decoration: BoxDecoration(
                        color: appThemeColor,
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Stack(children: [
                              imageLoading
                                  ? CircleAvatar(
                                      radius: 60,
                                      backgroundColor: greyColor,
                                      child: mCircularProgresIndication
                                      // backgroundImage: const AssetImage(
                                      //     "assets/images/Image-1.png"),

                                      )
                                  : profileFileImage != null
                                      ? CircleAvatar(
                                          backgroundColor: whiteColor,
                                          radius: 60,
                                          backgroundImage:
                                              FileImage(profileFileImage!))
                                      : widget.fullImage != ""
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(80),
                                              child: Container(
                                                color: redColor,
                                                height: 120,
                                                width: 120,
                                                child: CachedNetworkImage(
                                                  imageUrl: widget.fullImage
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
                                            )
                                          : CircleAvatar(
                                              radius: 60,
                                              backgroundColor: greyColor,
                                              child: Icon(
                                                Icons.person_outline,
                                                size: 35,
                                                color:
                                                    blackColor.withOpacity(0.4),
                                              ),
                                              // backgroundImage: const AssetImage(
                                              //     "assets/images/Image-1.png"),
                                            ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      chooseImage("image");
                                    },
                                    child: CircleAvatar(
                                        radius: 18,
                                        backgroundColor: orangeColor,
                                        child: Image.asset(
                                          "assets/images/imagepic.png",
                                          height: 15,
                                          color: whiteColor,
                                        )),
                                  ))
                            ]),
                            const SpaceHeightWidget(height: 5),
                            Text(
                              Constants.prefs!.getString("name").toString(),
                              style: TextStyle(
                                  fontFamily: "Poppins SemiBold",
                                  fontSize: fontSize16,
                                  color: blackColor),
                            )
                          ],
                        ),
                      )),
                ],
              ),
              expandedHeight: MediaQuery.of(context).size.height * 0.29,
              backgroundColor: whiteColor,
              leading: BackIconButton(
                color: whiteColor,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() {
                    return TextButtonWidget(
                      onTapFun: () {
                        setState(() {
                          edit = true;
                        });
                      },
                      // onTapFun: () async {
                      //   Map mapdata = {
                      //     // "mobile": widget.mobileNum
                      //   };
                      //   dynamic res =
                      //       await myProfieController.getResendOtpFun(mapdata);
                      //   if (res['status'] != "valid") {
                      //     toastMesg(res['message'], false);
                      //   } else {}
                      // },
                      loading: myProfieController.isloading.value,
                      name: "EDIT".tr(),
                      textStyle: TextStyle(
                          fontFamily: "Poppins Bold",
                          fontSize: fontSize14,
                          color: orangeColor),
                    );
                  }),
                  const SpaceWidthWidget(width: 15),
                ],
              ),
              (edit != true)
                  ? Column(
                      children: [
                        textWidget("Email".tr(), widget.mail, "no"),
                        textWidget("Gender".tr(), widget.gender, "no"),
                        textWidget("Mobile Number".tr(),
                            Constants.prefs!.getString("mobile"), "no"),
                        textWidget("Location".tr(), widget.location, "no"),
                        textWidget(
                            "Language",
                            (context.locale.toString() == "en")
                                ? "English"
                                : "ಕನ್ನಡ",
                            "yes"),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          CommonTextFormField(
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
                                  return "Please enter proper name";
                                } else {
                                  return null;
                                }
                              }),
                          const SpaceHeightWidget(height: 20),
                          CommonTextFormField(
                              hinttext: "Mobile".tr(),
                              keyboard: TextInputType.number,
                              read: true,
                              textCapital: TextCapitalization.none,
                              tcontroller: mobileController,
                              inputformatters: [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.digitsOnly,
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]")),
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^0+')),
                              ],
                              imagePath: "assets/images/Call.svg",
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
                              hinttext: "Email".tr(),
                              keyboard: TextInputType.emailAddress,
                              textCapital: TextCapitalization.none,
                              tcontroller: mailController,
                              inputformatters: [
                                LengthLimitingTextInputFormatter(50),
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^ +')),
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'[/\\ +-]')),
                              ],
                              imagePath: "assets/images/Gmail.svg",
                              validation: (value) {
                                String pattern =
                                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                    r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                    r"{0,253}[a-zA-Z0-9])?)*$";
                                RegExp regex = RegExp(pattern);
                                if (value!.isEmpty) {
                                  return "Please enter your Email".tr();
                                } else if (!regex
                                    .hasMatch(mailController.text)) {
                                  return "Please enter proper Email".tr();
                                } else {
                                  return null;
                                }
                              }),
                          const SpaceHeightWidget(height: 20),
                          genderType(),

                          // CommonTextFormField(
                          //     hinttext: "Gender".tr(),
                          //     keyboard: TextInputType.name,
                          //     textCapital: TextCapitalization.words,
                          //     tcontroller: genderController,
                          //     inputformatters: [
                          //       LengthLimitingTextInputFormatter(50),
                          //       FilteringTextInputFormatter.allow(
                          //           RegExp("[A-Za-z]")),
                          //       FilteringTextInputFormatter.deny(
                          //           RegExp(r'^0+')),
                          //     ],
                          //     imagePath: "assets/images/Gender.svg",
                          //     validation: (value) {
                          //       if (value!.isEmpty) {
                          //         return "Please enter gender".tr();
                          //       } else {
                          //         return null;
                          //       }
                          //     }),
                          const SpaceHeightWidget(height: 20),
                          CommonTextFormField(
                              hinttext: "City".tr(),
                              keyboard: TextInputType.name,
                              textCapital: TextCapitalization.words,
                              tcontroller: locationController,
                              inputformatters: [
                                LengthLimitingTextInputFormatter(50),
                                FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z ]")),
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^0+')),
                              ],
                              imagePath: "assets/images/Location.svg",
                              validation: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter your city".tr();
                                } else {
                                  return null;
                                }
                              }),
                          const SpaceHeightWidget(height: 20),
                          Obx(() {
                            return CommonElvButton(
                              name: "SUBMIT".tr(),
                              loading: myProfieController.isloading.value,
                              onTap: () {
                                submitFun(context);
                              },
                            );
                          }),
                        ],
                      ),
                    )
            ]))
          ],
        ),
      ),
    );
  }

  Widget divider() {
    return Divider(
      color: blackColor.withOpacity(0.1),
      thickness: 1,
    );
  }

  Widget textWidget(String title, content, edit) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        divider(),
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontFamily: "Poppins Medium",
                    fontSize: fontSize16,
                    color: blackColor),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    content,
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: fontSize14,
                        color: blackColor.withOpacity(0.5)),
                  ),
                  if (edit == "yes")
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LanguageSelectionScreen()));
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Image.asset(
                            "assets/images/language_icon.png",
                            height: 35,
                          )
                          // Icon(
                          //   Icons.edit,
                          //   color: orangeColor,
                          // ),
                          ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void chooseImage(String from) {
    // setState(() {
    //   currentType = type;
    // });
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
                                picker("camera");
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
                              picker("gallery");
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
  File? profileFileImage;
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

      dynamic res = await myProfieController.getImageUploadFun(
          imgexfile.path, "profiles");
      if (res['status'] == true) {
        Map mapdata = {"id": widget.id, "image": res['image']};
        dynamic res2 =
            await myProfieController.getProfileImageUploadFun(mapdata);
        if (res2['status'] == "valid") {
          setState(() {
            profileFileImage = fileimgage;
            imageLoading = false;
          });
        }
      }
    } catch (e) {
      toastMesg("Please try again".tr(), false);
    }
  }

  submitFun(cont) async {
    if (_formkey.currentState!.validate()) {
      Map mapdata = {
        "name": nameController.text,
        "email": mailController.text,
        "location": locationController.text,
        "gender": genderVal,
        "mobile": mobileController.text,
        // "image": finalImage,
        "id": widget.id
      };
      dynamic res = await myProfieController.getProfileUpdateFun(mapdata);
      if (res['status'] == "valid") {
        Constants.prefs!.setString("name", nameController.text);
        Constants.prefs!.setString("mail", mailController.text);
        Navigator.push(
            cont,
            MaterialPageRoute(
                builder: (cont) => const BottomBarScreen(
                      index: 4,
                    )));
      } else {
        toastMesg(res['message'], false);
      }
    }
  }

  String? genderVal;
  List<String> gender = ["Male", "Female", "Other"];
  Widget genderType() {
    return DropdownButtonFormField(
      value: genderVal,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      icon: const Icon(Icons.keyboard_arrow_down_outlined),
      focusColor: Colors.white,
      decoration: InputDecoration(
          isDense: true,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset("assets/images/Gender.svg"),
          ),
          labelText: "Gender".tr(),
          labelStyle: hintStyle,
          hintText: "Select gender".tr(),
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
        for (int i = 0; i < gender.length; i++)
          DropdownMenuItem(
              value: gender[i],
              onTap: () {
                setState(() {
                  genderVal = gender[i];
                });
              },
              child: Text(
                gender[i] == "Male"
                    ? "Male".tr()
                    : gender[i] == "Female"
                        ? "Female".tr()
                        : "Other".tr(),
                style: TextStyle(fontSize: fontSize16, fontFamily: "Poppins"),
              )),
      ],
      onChanged: (String? newValue) {},
      validator: (newValue) {
        if (newValue == null) {
          return 'Please select gender'.tr();
        } else {
          return null;
        }
      },
    );
  }
}
