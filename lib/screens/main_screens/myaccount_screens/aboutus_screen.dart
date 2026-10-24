import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart' hide Trans;
import 'package:help_app_flutter/commons/api_services.dart';
import 'package:help_app_flutter/commons/colors.dart';

import '../../../commons/common_widgets.dart';
import '../../../commons/constants.dart';
import '../../../controllers/maincontroller.dart';

class AnboutUsScreen extends StatefulWidget {
  final String? from;
  const AnboutUsScreen({super.key, required this.from});

  @override
  State<AnboutUsScreen> createState() => _AnboutUsScreenState();
}

class _AnboutUsScreenState extends State<AnboutUsScreen> {
  MainController cmsController = Get.put(MainController());
  dataFun() async {
    if (widget.from == "About Us") {
      await cmsController.getCmsFun(aboutUrl);
    } else if (widget.from == "Privacy Policy") {
      await cmsController.getCmsFun(privacyAndPolicyUrl);
    } else {
      await cmsController.getCmsFun(termsAndConditionsUrl);
    }
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
          (widget.from == "About Us")
              ? "About Us".tr()
              : (widget.from == "Privacy Policy")
                  ? "Privacy Policy".tr()
                  : "Terms and conditions".tr(),
          style: TextStyle(
              fontFamily: "Poppins SemiBold",
              fontSize: fontSize20,
              color: blackColor),
        ),
      ),
      body: Obx(() {
        return cmsController.isloading.value
            ? Center(child: mCircularProgresIndication)
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: double.infinity,
                width: double.infinity,
                child: Html(
                  tagsList: Html.tags,
                  data: cmsController.getCmsData,
                )
                //     Text(
                //   "Lorem ipsum dolor sit amet consectetur. Ac sit in mi interdum malesuada ante in scelerisque. Odio mauris amet in sed justo scelerisque porttitor elit diam. Maecenas porttitor amet sociis tortor. Justo quis est habitant amet nascetur gravida. Morbi velit feugiat velit fringilla sed dictumst pretium bibendum sem. Volutpat ultricies ultricies purus nunc accumsan scelerisque nibh elit. Pellentesque ultrices tincidunt donec lobortis sit blandit. Diam scelerisque sed sed diam ultricies nibh adipiscing dapibus. Platea ac vitae ac egestas eget praesent. Bibendum vitae turpis consectetur adipiscing faucibus bibendum cursus turpis. Sollicitudin tellus urna feugiat nunc sed orci elit sagittis gravida. Facilisis nibh ipsum mauris urna vestibulum molestie ac tellus. Dignissim mauris lacus nec vitae iaculis aliquam erat aliquam. Tortor senectus tellus commodo vel.Lorem ipsum dolor sit amet consectetur. Ac sit in mi interdum malesuada ante in scelerisque. Odio mauris amet in sed justo scelerisque porttitor elit diam. Maecenas porttitor amet sociis tortor. Justo quis est habitant amet nascetur gravida. Morbi velit feugiat velit fringilla sed dictumst pretium bibendum sem. Volutpat ultricies ultricies purus nunc accumsan scelerisque nibh elit.",
                //   style: TextStyle(
                //       fontFamily: "Poppins", fontSize: 14, color: blackColor),
                // ),
                );
      }),
    );
  }
}
