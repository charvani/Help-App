import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../commons/colors.dart';
import '../../../commons/common_functions.dart';
import '../../../commons/common_widgets.dart';
import '../../../commons/constants.dart';
import '../../../controllers/maincontroller.dart';
import '../home_screens/notification_screen.dart';
import 'loading_payment_screen.dart';
import 'sucesssubscription_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  final String from;
  const SubscriptionScreen({super.key, required this.from});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  MainController subscriptionController = Get.put(MainController());

  subsciptionFun() async {
    Map mapdata = {"customer_id": Constants.prefs!.getString("user_id")};
    await subscriptionController.getSubscriptionFun(mapdata);
  }

  Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      subsciptionFun();
      _razorpay = Razorpay();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      _razorpay.on(Razorpay.PAYMENT_CANCELLED.toString(), _handleNoPayment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
            "Subscription".tr(),
            style: TextStyle(
                fontFamily: "Poppins SemiBold",
                fontSize: fontSize20,
                color: blackColor),
          ),
          // actions: [
          //   NotificationWidget(
          //       iconColor: blackColor,
          //       badge: true,
          //       onTap: () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => const NotificationsScreen(
          //                       from: "subsciption",
          //                     )));
          //       }),
          //   const SpaceWidthWidget(width: 20)
          // ],
        ),
        body: RefreshIndicator(
          color: appThemeColor,
          onRefresh: () async {
            subsciptionFun();
          },
          child: subscriptionController.isloading.value
              ? Center(child: mCircularProgresIndication)
              : Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: double.infinity,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SpaceHeightWidget(height: 20),
                            subscriptionController
                                        .getSubscriptionData.data.id !=
                                    ""
                                ? Text(
                                    "Active Subscription".tr(),
                                    style: TextStyle(
                                        fontFamily: "Poppins Medium",
                                        fontSize: fontSize14,
                                        color: blackColor),
                                  )
                                : Text(
                                    subscriptionController
                                        .getSubscriptionData.packs.text,
                                    // "Lorem ipsum dolor sit amet consectetur. Purus commodo scelerisque egestas ut scelerisque ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 12,
                                        color: blackColor),
                                  ),
                            const SpaceHeightWidget(height: 20),
                            if (subscriptionController
                                    .getSubscriptionData.data.id !=
                                "")
                              activeSubscriptionWidget(),
                            const SpaceHeightWidget(height: 20),
                            if (subscriptionController
                                .getSubscriptionData.packs.data.isNotEmpty)
                              Text(
                                "All Plans".tr(),
                                style: TextStyle(
                                    fontFamily: "Poppins Medium",
                                    fontSize: 14,
                                    color: blackColor),
                              ),
                            const SpaceHeightWidget(height: 20),
                            if (subscriptionController
                                .getSubscriptionData.packs.data.isEmpty)
                              Container(
                                height: (subscriptionController
                                            .getSubscriptionData.data.id ==
                                        "")
                                    ? MediaQuery.of(context).size.height * 0.6
                                    : MediaQuery.of(context).size.height * 0.2,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Center(
                                  child: Text(
                                    subscriptionController
                                        .getSubscriptionData.packs.message
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Poppins Medium",
                                        fontSize: 14,
                                        color: blackColor),
                                  ),
                                ),
                              ),
                            for (int i = 0;
                                i <
                                    subscriptionController
                                        .getSubscriptionData.packs.data.length;
                                i++)
                              if (subscriptionController
                                      .getSubscriptionData.data.id !=
                                  subscriptionController
                                      .getSubscriptionData.packs.data[i].id)
                                Column(
                                  children: [
                                    SubscriptionWidget(
                                      color: i == 0
                                          ? appThemeColor
                                          : i % 2 == 0
                                              ? greenColor
                                              : orangeColor,
                                      title: subscriptionController
                                          .getSubscriptionData
                                          .packs
                                          .data[i]
                                          .packageTitle,
                                      amount: subscriptionController
                                          .getSubscriptionData
                                          .packs
                                          .data[i]
                                          .packagePrice,
                                      date: subscriptionController
                                          .getSubscriptionData
                                          .packs
                                          .data[i]
                                          .billingType,
                                      tag: false,
                                      description1:
                                          "${subscriptionController.getSubscriptionData.packs.data[i].billingType} billing",
                                      description2: subscriptionController
                                          .getSubscriptionData
                                          .packs
                                          .data[i]
                                          .noOfPosts,
                                      onTap: () {
                                        bottomSheet(
                                            context,
                                            subscriptionController
                                                .getSubscriptionData
                                                .packs
                                                .data[i]
                                                .packageTitle,
                                            subscriptionController
                                                .getSubscriptionData
                                                .packs
                                                .data[i]
                                                .packagePrice,
                                            subscriptionController
                                                .getSubscriptionData
                                                .packs
                                                .data[i]
                                                .billingType,
                                            "${subscriptionController.getSubscriptionData.packs.data[i].billingType} Billing",
                                            subscriptionController
                                                .getSubscriptionData
                                                .packs
                                                .data[i]
                                                .noOfPosts,
                                            subscriptionController
                                                .getSubscriptionData
                                                .packs
                                                .data[i]
                                                .contactNumber,
                                            subscriptionController
                                                .getSubscriptionData
                                                .packs
                                                .data[i]
                                                .whatsappNumber,
                                            subscriptionController
                                                .getSubscriptionData
                                                .packs
                                                .data[i]
                                                .id);
                                      },
                                    ),
                                    const SpaceHeightWidget(height: 35),
                                  ],
                                ),
                          ],
                        ),
                      ),
                    ),
                    if (paymentLoading)
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: greyColor.withOpacity(0.5),
                        child: Center(child: mCircularProgresIndication),
                      ),
                  ],
                ),
        ),
      );
    });
  }

  bottomSheet(BuildContext context, String title, amount, date, description1,
      description2, callnum, wnum, id) {
    showModalBottomSheet<void>(
        isDismissible: false,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: blackColor.withOpacity(0.1),
                        child: Icon(
                          Icons.close,
                          color: blackColor,
                        ),
                      ),
                    )
                  ],
                ),
                Text(
                  title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: blackColor,
                      fontSize: fontSize14 + fontSize10,
                      fontFamily: "Poppins SemiBold"),
                ),
                const SpaceHeightWidget(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.done,
                      size: 14,
                    ),
                    const SpaceWidthWidget(width: 8),
                    Text(
                      description1,
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: fontSize12,
                          color: blackColor.withOpacity(0.5)),
                    ),
                  ],
                ),
                const SpaceHeightWidget(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.done,
                      size: 14,
                    ),
                    const SpaceWidthWidget(width: 8),
                    Text(
                      description2,
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: fontSize12,
                          color: blackColor.withOpacity(0.5)),
                    ),
                  ],
                ),
                const SpaceHeightWidget(height: 10),
                RichText(
                  text: TextSpan(
                      text: "₹ ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize10 + fontSize14,
                          color: blackColor),
                      children: [
                        TextSpan(
                          text: amount,
                          style: TextStyle(
                              fontFamily: "Poppins Bold",
                              fontSize: fontSize10 + fontSize14 + fontSize8,
                              color: blackColor),
                        ),
                        TextSpan(
                          text: "/$date",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: fontSize12,
                              color: blackColor),
                        ),
                      ]),
                ),
                const SpaceHeightWidget(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        _makePhoneCall(callnum);
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: appThemeColor,
                          borderRadius: BorderRadiusDirectional.circular(10),
                        ),
                        child: Image.asset(
                          "assets/images/mobile.png",
                          height: 10,
                          color: whiteColor,
                        ),
                      ),
                    ),
                    const SpaceWidthWidget(width: 10),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        var whatsappNum = "+91$wnum";

                        var whatsappAndroid = Uri.parse(
                            "whatsapp://send?phone=$whatsappNum&text=Hi, Myself${Constants.prefs!.getString("name")}, I am looking for $title subscription");
                        if (await canLaunchUrl(whatsappAndroid)) {
                          await launchUrl(whatsappAndroid);
                        } else {
                          toastMesg("Whatsapp notAvailable".tr(), false);
                        }
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: greenColor,
                          borderRadius: BorderRadiusDirectional.circular(10),
                        ),
                        child: SvgPicture.asset(
                          "assets/images/WhatsApp2.svg",
                          height: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SpaceHeightWidget(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CommonElvButton(
                    onTap: () {
                      if (subscriptionController
                              .getSubscriptionData.paymentType ==
                          "razorpay") {
                        print("mee");
                        paymentFun(context, id, amount, "subscribe");
                      } else if (subscriptionController
                              .getSubscriptionData.paymentType ==
                          "upi_payment") {
                        // instructionsDilog(context, id, amount, "subscribe");
                        loadingPaymentCheckFun(
                            context, id, amount, "subscribe");
                      } else {
                        toastMesg(
                            "Other payment gateway, not integrated", false);
                      }
                    },
                    name: "Subscribe".tr(),
                  ),
                ),
                const SpaceHeightWidget(height: 10),
              ],
            ),
          );
        });
  }

  String? paymentReqId;
  loadingPaymentCheckFun(cont, id, amount, from) async {
    setState(() {
      paymentLoading = true;
    });
    if (from == "subscribe") {
      Navigator.pop(context);
    }
    Map mapdata = {
      "customer_id": Constants.prefs!.getString("user_id"),
      "subscription_packages_id": id,
      "amount": amount
    };
    print("mappp...${mapdata}");
    dynamic resinit = await subscriptionController.getUpiInitiateFun(mapdata);
    if (resinit['status'] == "valid") {
      if (mounted) {
        setState(() {
          paymentReqId = resinit['data']['ref_id'].toString();
        });
      }
      // ignore: use_build_context_synchronously
      dynamic result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (cont) => LoadingPaymentCheckScreen(
                    url: resinit['data']['webview_url'],
                    paymentId: resinit['data']['ref_id'],
                  )));

      if (result != null) {
        // repeatingFun();
        dynamic res = await subscriptionController
            .getLoadingPaymentStatusCheckingFun(
                {"client_txn_id": paymentReqId});
        print("");
        if (res['status'] == "valid") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SucessSubscriptionScreen()));
        } else {
          toastMesg(res['message'], false);
        }
      }
      toastMesg("Please refresh/tryagain", false);

      setState(() {
        paymentLoading = false;
      });
    } else {
      toastMesg(resinit['message'], false);
      setState(() {
        paymentLoading = false;
      });
    }
  }

  instructionsDilog(conte, id, amount, from) {
    return yesNoDilog(context,
        "If any payment issue, to get status of your payment please refresh this page",
        () async {
      Navigator.pop(context);
      loadingPaymentCheckFun(conte, id, amount, from);
    });
  }

  Widget activeSubscriptionWidget() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical:
              subscriptionController.getSubscriptionData.data.renwal != "true"
                  ? 30
                  : 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: appThemeColor,
          border: Border.all(color: appThemeColor, width: 1)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // "Basic",
                subscriptionController.getSubscriptionData.data.packageTitle,
                style: TextStyle(
                    fontFamily: "Poppins Medium",
                    fontSize: 20,
                    color: whiteColor),
              ),
              RichText(
                text: TextSpan(
                    text: "₹ ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize10 + fontSize14,
                        color: whiteColor),
                    children: [
                      TextSpan(
                        text: subscriptionController
                            .getSubscriptionData.data.packagePrice,

                        // "650",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: fontSize10 + fontSize14,
                            color: whiteColor),
                      ),
                      TextSpan(
                        text:
                            "/${subscriptionController.getSubscriptionData.data.billingType}",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: fontSize12,
                            color: whiteColor),
                      ),
                    ]),
              ),
            ],
          ),
          Text(
            "${"Pack Duration".tr()}: ${subscriptionController.getSubscriptionData.data.billingType}",
            style: TextStyle(
                fontFamily: "Poppins Medium", fontSize: 10, color: whiteColor),
          ),
          Text(
            "${"Renew".tr()} : ${subscriptionController.getSubscriptionData.data.expiryDate}",
            style: TextStyle(
                fontFamily: "Poppins Medium", fontSize: 10, color: whiteColor),
          ),
          const SpaceHeightWidget(height: 15),
          if (subscriptionController.getSubscriptionData.data.renwal == "true")
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      if (subscriptionController
                              .getSubscriptionData.paymentType ==
                          "razorpay") {
                        paymentFun(
                            context,
                            subscriptionController.getSubscriptionData.data.id,
                            subscriptionController
                                .getSubscriptionData.data.packagePrice,
                            "renew");
                      } else if (subscriptionController
                              .getSubscriptionData.paymentType ==
                          "upi_payment") {
                        loadingPaymentCheckFun(
                            context,
                            subscriptionController.getSubscriptionData.data.id,
                            subscriptionController
                                .getSubscriptionData.data.packagePrice,
                            "renew");

                        // instructionsDilog(
                        //     context,
                        //     subscriptionController.getSubscriptionData.data.id,
                        //     subscriptionController
                        //         .getSubscriptionData.data.packagePrice,
                        //     "renew");
                      } else {
                        toastMesg(
                            "Other payment gateway, not integrated", false);
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(whiteColor),
                        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7))),
                        padding: const MaterialStatePropertyAll(
                            EdgeInsets.symmetric(
                                horizontal: 40, vertical: 10))),
                    child: Text(
                      "Renew".tr(),
                      style: TextStyle(
                          fontFamily: "Poppins Medium",
                          fontSize: 14,
                          color: blackColor),
                    ))
              ],
            )
        ],
      ),
    );
  }

  bool renewLoading = false;
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  bool paymentLoading = false;
  paymentFun(cont, id, amount, from) async {
    setState(() {
      paymentLoading = true;
    });
    if (from == "subscribe") {
      Navigator.pop(context);
    }

    Map mapdata = {
      "customer_id": Constants.prefs!.getString("user_id"),
      "subscription_packages_id": id,
      "amount": amount
    };
    print("mappppp....$mapdata");

    dynamic res = await subscriptionController.getPaymentInitiateFun(mapdata);
    print("REs....$res");
    if (res['razerpay_key'] != null) {
      razorpayPaymentFun(
          res['razerpay_key'], res['order_id'], amount, res['trnx_id']);
    } else {
      toastMesg(res['message'], false);
      setState(() {
        paymentLoading = false;
      });
    }
  }

  String trnId = "";
  void razorpayPaymentFun(key, orderid, amount, tranxId) async {
    int _amt = int.parse(amount) * 100;
    String rkey = key.toString();
    if (mounted) {
      setState(() {
        trnId = tranxId;
      });
    }

    var options = {
      'key': rkey,
      'amount': amount,
      'name': "Help App",
      'order_id': orderid.toString(),
      'description': "Subscription Payment",
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': Constants.prefs!.getString("mobile"),
        'email': Constants.prefs!.getString("mail")
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    print("my options....$options");
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("response ........${response}");
    print("response ........${response.toString()}");
    print("response ........${response.paymentId}");
    print("response ........${response.orderId}");
    print("response ........${response.signature}");
    print("response ........${response.obs}");
    print("response ........${response.reactive}");
    print(response);
    Map<String, dynamic> mapdata = {
      "customer_id": Constants.prefs!.getString("user_id"),
      "transaction_id": trnId,
      "order_id": response.orderId,
      "payment_id": response.paymentId
    };
    print("su..$mapdata");
    successApi(
      mapdata,
    );
  }

  successApi(
    Map<String, dynamic> mapdata,
  ) async {
    print("mapdata....$mapdata");
    var res = await subscriptionController.getPaymentSuccessFun(mapdata);
    print("getiing res......$res");
    if (res['status'] == "valid") {
      if (widget.from == "post") {
        // ignore: use_build_context_synchronously
        Navigator.pop(context, "yes");
      } else {
        toastMesg(res['message'], true);

        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const SucessSubscriptionScreen()));
      }
    }

    setState(() {
      paymentLoading = false;
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    toastMesg("Payment failure please try again".tr(), false);
    setState(() {
      paymentLoading = false;
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }
  void _handleNoPayment(dynamic response) {
    toastMesg("Payment failure please try again".tr(), false);
    setState(() {
      paymentLoading = false;
    });
  }
}
