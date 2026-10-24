import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../commons/colors.dart';
import '../../../controllers/maincontroller.dart';

class LoadingPaymentCheckScreen extends StatefulWidget {
  final String url, paymentId;
  const LoadingPaymentCheckScreen(
      {super.key, required this.url, required this.paymentId});

  @override
  State<LoadingPaymentCheckScreen> createState() =>
      _LoadingPaymentCheckScreenState();
}

class _LoadingPaymentCheckScreenState extends State<LoadingPaymentCheckScreen> {
  MainController _payLoadingController = Get.put(MainController());

  Timer? _timer;
  //
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
        dynamic res = await _payLoadingController
            .getLoadingPaymentStatusCheckingFun(
                {"client_txn_id": widget.paymentId});
        print("getLoadingPaymentInitFun res...$res");
        if (res['status'] == "valid") {
          Navigator.pop(context, "check");
        }
      });
      launchUrl(
        Uri.parse(widget.url),
        mode: LaunchMode.externalApplication,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: appThemeColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context, "check");
            },
          ),
          titleSpacing: 23,
          title: const Text("Help App Payment")),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.all(30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 2, color: appThemeColor)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(
                    strokeWidth: 4, color: appThemeColor),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Please complete payment"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(color: whiteColor, fontSize: 17),
                  ),
                  color: appThemeColor,
                ),
              )
            ],
          )),
    );
  }
}
