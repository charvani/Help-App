import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_app_flutter/commons/colors.dart';
import 'package:help_app_flutter/commons/common_functions.dart';
import 'package:help_app_flutter/commons/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class SpaceHeightWidget extends StatelessWidget {
  final double? height;
  const SpaceHeightWidget({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class SpaceWidthWidget extends StatelessWidget {
  final double? width;
  const SpaceWidthWidget({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}

class NotificationWidget extends StatelessWidget {
  final Color iconColor;
  final bool badge;
  final VoidCallback onTap;
  const NotificationWidget(
      {super.key,
      required this.iconColor,
      required this.badge,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: badge
          ? Container(
              alignment: Alignment.center,
              child: Badge(
                  backgroundColor: redColor,
                  smallSize: 11,
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Icon(Icons.notifications_none,
                      size: 30, color: iconColor)),
            )
          : Icon(Icons.notifications_none, size: 30, color: iconColor),
    );
  }
}

class TextButtonWidget extends StatelessWidget {
  final String? name;
  final TextStyle? textStyle;
  final VoidCallback onTapFun;
  final bool? loading;
  const TextButtonWidget({
    super.key,
    required this.name,
    required this.textStyle,
    required this.onTapFun,
    this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onTapFun,
        child: loading == true
            ? wCircularProgresIndication
            : Text(
                name.toString(),
                style: textStyle,
              ));
  }
}

class BackIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color? color;
  const BackIconButton({super.key, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onTap,
        icon: Icon(
          Icons.arrow_back_ios,
          color: color,
          size: 18,
        ));
  }
}

PreferredSizeWidget commonAppBar(BuildContext context, String title) {
  return AppBar(
    elevation: 0,
    backgroundColor: whiteColor,
    leadingWidth: 0,
    // leading: BackIconButton(
    //   color: blackColor,
    //   onTap: () {
    //     Navigator.pop(context);
    //   },
    // ),
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(
          fontFamily: "Poppins SemiBold",
          fontSize: fontSize20,
          color: blackColor),
    ),
  );
}

TextStyle hintStyle = TextStyle(
  fontFamily: "Poppins",
  fontSize: fontSize14,
  color: blackColor.withOpacity(0.5),
);

OutlineInputBorder errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: redColor));

OutlineInputBorder normalBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: orangeColor));

class CommonTextFormField extends StatefulWidget {
  final TextEditingController tcontroller;
  final String? hinttext;
  final String imagePath;
  final String? Function(String?) validation;
  final TextCapitalization textCapital;
  final List<TextInputFormatter> inputformatters;
  final TextInputType keyboard;
  final bool? read;

  const CommonTextFormField(
      {super.key,
      required this.tcontroller,
      required this.hinttext,
      required this.imagePath,
      required this.validation,
      required this.inputformatters,
      required this.textCapital,
      required this.keyboard,
      this.read});

  @override
  State<CommonTextFormField> createState() => _CommonTextFormFieldState();
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: widget.keyboard,
      textCapitalization: widget.textCapital,
      controller: widget.tcontroller,
      inputFormatters: widget.inputformatters,
      cursorColor: orangeColor,
      readOnly: (widget.read == true) ? true : false,
      decoration: InputDecoration(
          isDense: true,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset(
              widget.imagePath,
            ),
          ),
          labelText: widget.hinttext,
          labelStyle: hintStyle,
          hintText: widget.hinttext,
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
      validator: widget.validation,
    );
  }
}

class CommonElvButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? name;
  final bool? loading;
  const CommonElvButton(
      {super.key, required this.onTap, required this.name, this.loading});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: orangeColor,
      minWidth: double.infinity,
      height: 50,
      child: loading == true
          ? wCircularProgresIndication
          : Text(
              name.toString(),
              style: TextStyle(
                  fontFamily: "Poppins SemiBold",
                  fontSize: fontSize18,
                  color: whiteColor),
            ),
    );
  }
}

class PostItemWidget extends StatelessWidget {
  final String? imagename, name, title, date, status, mobile, edit, delete;
  final VoidCallback editFun;
  final VoidCallback deleteFun;
  const PostItemWidget({
    super.key,
    required this.imagename,
    required this.title,
    required this.date,
    required this.status,
    required this.mobile,
    required this.name,
    required this.edit,
    required this.delete,
    required this.editFun,
    required this.deleteFun,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(children: [
        Container(
          height: 130,
          width: MediaQuery.of(context).size.width * 0.45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // image: DecorationImage(
              //     image: AssetImage(
              //       "assets/images/$imagename",
              //     ),
              //     fit: BoxFit.cover)
              border:
                  Border.all(width: 0.3, color: blackColor.withOpacity(0.1))),
          child: CachedNetworkImage(
            imageUrl: imagename!.replaceAll("https", "http"),
            errorWidget: (context, url, error) =>
                Center(child: mCircularProgresIndication),
            fit: BoxFit.fill,
          ),
        ),
        Container(
            // height: 110,
            padding: const EdgeInsets.only(left: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toString(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: orangeColor,
                      fontFamily: "Poppins SemiBold",
                      fontSize: fontSize16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/person.svg",
                      height: 10,
                    ),
                    const SpaceWidthWidget(width: 3),
                    Text(
                      name.toString(),
                      style: TextStyle(
                          color: blackColor.withOpacity(0.7),
                          fontFamily: "Poppins",
                          fontSize: fontSize10),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/Calendar.svg",
                      height: 10,
                    ),
                    const SpaceWidthWidget(width: 3),
                    Text(
                      date.toString(),
                      style: TextStyle(
                          color: blackColor.withOpacity(0.7),
                          fontFamily: "Poppins",
                          fontSize: fontSize10),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/Call.svg",
                      height: 10,
                    ),
                    const SpaceWidthWidget(width: 3),
                    Text(
                      "+91 $mobile",
                      style: TextStyle(
                          color: blackColor.withOpacity(0.7),
                          fontFamily: "Poppins",
                          fontSize: fontSize10),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/clock.svg",
                      height: 10,
                    ),
                    const SpaceWidthWidget(width: 3),
                    Text(
                      status.toString(),
                      style: TextStyle(
                          color: (status == "Pending")
                              ? orangeColor
                              : (status == "Approved")
                                  ? greenColor
                                  : redColor,
                          fontFamily: "Poppins",
                          fontSize: fontSize10),
                    ),
                  ],
                ),
                const SpaceHeightWidget(height: 3),
                SizedBox(
                  height: 28,
                  child: Row(
                    children: [
                      if (edit == "true")
                        ElevatedButton(
                          style: ButtonStyle(
                              padding: const MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(horizontal: 5)),
                              backgroundColor:
                                  MaterialStatePropertyAll(greenColor)),
                          onPressed: editFun,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment:
                                  (context.locale.toString() == "en")
                                      ? CrossAxisAlignment.center
                                      : CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  "assets/images/Edit.svg",
                                  height: 10,
                                ),
                                const SpaceWidthWidget(width: 2),
                                Text(
                                  'Edit'.tr(),
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: fontSize10,
                                      color: whiteColor),
                                ),
                              ]), // <-- Text
                        ),
                      const SpaceWidthWidget(width: 5),
                      if (delete == "true")
                        ElevatedButton(
                          style: ButtonStyle(
                              padding: const MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(horizontal: 5)),
                              backgroundColor:
                                  MaterialStatePropertyAll(redColor)),
                          onPressed: deleteFun,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment:
                                (context.locale.toString() == "en")
                                    ? CrossAxisAlignment.center
                                    : CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                "assets/images/Delete.svg",
                                height: 10,
                              ),
                              const SpaceWidthWidget(width: 2),
                              Text(
                                'Delete'.tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: fontSize10,
                                    color: whiteColor),
                              ),
                            ],
                          ),
                          // icon: SvgPicture.asset(
                          //   "assets/images/Delete.svg",
                          //   height: 10,
                          // ),
                          // label: Text(
                          //   'Delete'.tr(),
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(
                          //       fontFamily: "Poppins",
                          //       fontSize: fontSize10,
                          //       color: whiteColor),
                          // ), // <-- Text
                        ),
                    ],
                  ),
                ),
              ],
            ))
      ]),
    );
  }
}

class MyProfileWidget extends StatelessWidget {
  final String? imagename, title;
  final VoidCallback onTap;
  const MyProfileWidget(
      {super.key,
      required this.imagename,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: ListTile(
        leading: SvgPicture.asset("assets/images/$imagename"),
        title: Text(
          title.toString(),
          style: TextStyle(
              fontSize: fontSize18, fontFamily: "Poppins", color: blackColor),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: blackColor,
        ),
      ),
    );
  }
}

class SubscriptionWidget extends StatefulWidget {
  final Color color;
  final bool tag;
  final String title, amount, date, description1, description2;

  final VoidCallback onTap;
  const SubscriptionWidget(
      {super.key,
      required this.color,
      required this.title,
      required this.amount,
      required this.date,
      required this.description1,
      required this.description2,
      required this.tag,
      required this.onTap});

  @override
  State<SubscriptionWidget> createState() => _SubscriptionWidgetState();
}

class _SubscriptionWidgetState extends State<SubscriptionWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: (widget.tag)
              ? const EdgeInsets.only(top: 20)
              : const EdgeInsets.only(top: 0),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: widget.color.withOpacity(0.2),
              border: Border.all(color: widget.color, width: 1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: fontSize12,
                                color: blackColor.withOpacity(0.5)),
                          ),
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                            text: "₹ ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize10 + fontSize14,
                                color: blackColor),
                            children: [
                              TextSpan(
                                text: widget.amount,
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: fontSize10 + fontSize14,
                                    color: blackColor),
                              ),
                              TextSpan(
                                text: "/${widget.date}",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: fontSize12,
                                    color: blackColor),
                              ),
                            ]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.done,
                            size: 14,
                          ),
                          const SpaceWidthWidget(width: 4),
                          Flexible(
                            child: Text(
                              widget.description1,
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: fontSize12,
                                  color: blackColor.withOpacity(0.5)),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.done,
                            size: 14,
                          ),
                          const SpaceWidthWidget(width: 4),
                          Flexible(
                            child: Text(
                              widget.description2,
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: fontSize12,
                                  color: blackColor.withOpacity(0.5)),
                            ),
                          ),
                        ],
                      )
                    ]),
              ),
              ElevatedButton(
                onPressed: widget.onTap,
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(widget.color),
                    shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(color: widget.color)),
                    ),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10))),
                child: Text(
                  "Subscribe".tr(),
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: fontSize14,
                      color: whiteColor),
                ),
              )
            ],
          ),
        ),
        if (widget.tag)
          Positioned(
              left: 20,
              right: 20,
              height: 40,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: whiteColor,
                    border: Border.all(color: widget.color, width: 0.5)),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: widget.color.withOpacity(0.2),
                      border: Border.all(color: widget.color, width: 0.5)),
                  child: Text(
                    "Best Offer",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: fontSize14,
                        color: widget.color),
                  ),
                ),
              ))
      ],
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final String imagename,
      name,
      title,
      personImage,
      mobile,
      whatsapp,
      postid,
      date;
  final VoidCallback onTap;
  const CategoryWidget(
      {super.key,
      required this.imagename,
      required this.name,
      required this.title,
      required this.personImage,
      required this.mobile,
      required this.onTap,
      required this.whatsapp,
      required this.postid,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: CachedNetworkImage(
                          imageUrl: personImage.replaceAll("https", "http"),
                          errorWidget: (context, url, error) =>
                              Center(child: mCircularProgresIndication),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SpaceWidthWidget(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                              fontFamily: "Poppins Medium",
                              fontSize: fontSize12,
                              color: blackColor),
                        ),
                        Text(
                          title,
                          style: TextStyle(
                              fontFamily: "Poppins Medium",
                              fontSize: fontSize10,
                              color: blackColor.withOpacity(0.5)),
                        ),
                        Text(
                          "$date posted",
                          style: TextStyle(
                              fontFamily: "Poppins Medium",
                              fontSize: fontSize10,
                              color: blackColor.withOpacity(0.5)),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (mobile != "")
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          _makePhoneCall(mobile);
                        },
                        child: CircleAvatar(
                          radius: 17,
                          backgroundColor: appThemeColor,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              "assets/images/call3.png",
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    const SpaceWidthWidget(width: 10),
                    if (whatsapp != "")
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          var whatsappNum = "+91$whatsapp";

                          var whatsappAndroid = Uri.parse(
                              "whatsapp://send?phone=$whatsappNum&text=Hi, Myself${Constants.prefs!.getString("name")}, I am looking for #$postid");
                          if (await canLaunchUrl(whatsappAndroid)) {
                            await launchUrl(whatsappAndroid);
                          } else {
                            toastMesg("Whatsapp notAvailable", false);
                          }
                        },
                        child: CircleAvatar(
                          radius: 17,
                          backgroundColor: greenColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                SvgPicture.asset("assets/images/WhatsApp2.svg"),
                          ),
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
          const SpaceHeightWidget(height: 10),
          Container(
              decoration: BoxDecoration(
                  border: Border.all(color: appThemeColor.withOpacity(0.1))),
              height: 300,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: imagename.replaceAll("https", "http"),
                errorWidget: (context, url, error) =>
                    Center(child: mCircularProgresIndication),
                fit: BoxFit.fill,
              )),
          const SpaceHeightWidget(height: 10)
        ]),
      ),
    );
  }
}

class HomeCategoryWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String image, title;
  final Color color;
  const HomeCategoryWidget(
      {super.key,
      required this.onTap,
      required this.color,
      required this.image,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
        decoration: BoxDecoration(
            border: Border.all(color: color, width: 1),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        height: 100,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: image.replaceAll("https", "http"),
              errorWidget: (context, url, error) => mCircularProgresIndication,
              height: 50,
              width: 50,
              fit: BoxFit.fill,
            ),
            const SpaceHeightWidget(height: 3),
            Text(
              title,
              style: TextStyle(fontFamily: "Poppins", fontSize: fontSize10),
            )
          ],
        ),
      ),
    );
  }
}

class HomeSearchWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String image, title;
  final Color color;
  const HomeSearchWidget(
      {super.key,
      required this.onTap,
      required this.color,
      required this.image,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
        decoration: BoxDecoration(
            border: Border.all(color: color, width: 1),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        height: 70,
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SpaceWidthWidget(width: 10),
            CachedNetworkImage(
              imageUrl: image.replaceAll("https", "http"),
              errorWidget: (context, url, error) => mCircularProgresIndication,
              height: MediaQuery.of(context).size.height * 0.02,
              width: MediaQuery.of(context).size.width * 0.02,
              fit: BoxFit.fill,
            ),
            const SpaceWidthWidget(width: 10),
            Text(
              title,
              style: TextStyle(fontFamily: "Poppins", fontSize: fontSize10),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> _makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}
