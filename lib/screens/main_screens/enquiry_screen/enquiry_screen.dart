import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:help_app_flutter/commons/colors.dart';

import '../../../commons/common_functions.dart';
import '../../../commons/common_widgets.dart';
import '../../../commons/constants.dart';
import '../../../controllers/maincontroller.dart';
import '../bottombar_screen/bottombar_screen.dart';

class EnquiryScreen extends StatefulWidget {
  const EnquiryScreen({super.key});

  @override
  State<EnquiryScreen> createState() => _EnquiryScreenState();
}

class _EnquiryScreenState extends State<EnquiryScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  MainController enquiryController = Get.put(MainController());
  String? selectedId;
  String? mobile;
  String? name, mail;
  @override
  void initState() {
    super.initState();
    mobile = Constants.prefs!.getString("mobile");
    name = Constants.prefs!.getString("name");
    mail = Constants.prefs!.getString("mail");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await enquiryController.getAllCategoriesFun("init");
      if (mounted) {
        setState(() {
          mobileController.text = mobile!;
          nameController.text = name!;
          mailController.text = mail!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: commonAppBar(context, "Enquiry".tr()),
        body: Form(
          key: _formkey,
          child: Container(
            color: whiteColor,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SpaceHeightWidget(height: 20),
                  Obx(() {
                    return enquiryController.isloading.value
                        ? Center(child: mCircularProgresIndication)
                        : categoryType();
                  }),
                  const SpaceHeightWidget(height: 20),
                  CommonTextFormField(
                      hinttext: "Name".tr(),
                      keyboard: TextInputType.name,
                      textCapital: TextCapitalization.words,
                      tcontroller: nameController,
                      read: true,
                      inputformatters: [
                        LengthLimitingTextInputFormatter(50),
                        FilteringTextInputFormatter.allow(RegExp("[A-Za-z ]")),
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
                      hinttext: "Email".tr(),
                      keyboard: TextInputType.emailAddress,
                      textCapital: TextCapitalization.none,
                      tcontroller: mailController,
                      read: true,
                      inputformatters: [
                        LengthLimitingTextInputFormatter(50),
                        FilteringTextInputFormatter.deny(RegExp(r'^ +')),
                        FilteringTextInputFormatter.deny(RegExp(r'[/\\ +-]')),
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
                        } else if (!regex.hasMatch(mailController.text)) {
                          return "Please enter proper Email".tr();
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
                  Obx(() {
                    return CommonElvButton(
                      onTap: () {
                        submitFun(context);
                      },
                      name: "SUBMIT".tr(),
                      loading: enquiryController.isloading.value,
                    );
                  }),
                  const SpaceHeightWidget(height: 20),
                ],
              ),
            ),
          ),
        ));
  }

  String? slectedCat;
  Widget categoryType() {
    return DropdownButtonFormField(
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
        for (int i = 0; i < enquiryController.getAllCategories.length; i++)
          DropdownMenuItem(
            value: enquiryController.getAllCategories[i].title,
            child: Text(
              // enquiryController.getAllCategories[i].title,
              (context.locale.toString() == "en")
                  ? enquiryController.getAllCategories[i].languageEnglish
                  : enquiryController.getAllCategories[i].languageKanada,
              style: TextStyle(fontSize: fontSize16, fontFamily: "Poppins"),
            ),
            onTap: () {
              setState(() {
                slectedCat = enquiryController.getAllCategories[i].title;
                selectedId = enquiryController.getAllCategories[i].id;
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

  submitFun(cont) async {
    if (_formkey.currentState!.validate()) {
      Map mapdata = {
        "category_id": selectedId,
        "name": nameController.text,
        "email": mailController.text,
        "message": descriptionController.text,
        "mobile": mobileController.text,
      };
      dynamic res = await enquiryController.getEnquiryFun(mapdata);
      if (res['status'] == "valid") {
        toastMesg(res['message'], true);
        Timer(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
              cont,
              MaterialPageRoute(
                  builder: (cont) => const BottomBarScreen(
                        index: 0,
                      )));
        });
      } else {
        toastMesg(res['message'], false);
      }
    }
  }
}
