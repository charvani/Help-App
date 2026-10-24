import 'dart:convert';

SubscriptionModel subscriptionModelFromJson(String str) =>
    SubscriptionModel.fromJson(json.decode(str));

String subscriptionModelToJson(SubscriptionModel data) =>
    json.encode(data.toJson());

class SubscriptionModel {
  SubscriptionModel({
    required this.status,
    required this.data,
    required this.packs,
    required this.paymentType,
  });

  String status;
  dynamic paymentType;
  Data data;
  Packs packs;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionModel(
        status: json["status"],
        paymentType: json["payment_gateway"],
        data: (json["data"].toString() != "[]")
            ? Data.fromJson(json["data"])
            : Data(
                id: "",
                packageTitle: "",
                packagePrice: "",
                billingType: "",
                noOfPosts: "",
                renwal: "",
                expiryDate: ""),
        packs: Packs.fromJson(json["packs"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "payment_gateway": paymentType,
        "data": data.toJson(),
        "packs": packs.toJson(),
      };
}

class Data {
  Data({
    required this.id,
    required this.packageTitle,
    required this.packagePrice,
    required this.billingType,
    required this.noOfPosts,
    required this.renwal,
    required this.expiryDate,
  });

  String id;
  String packageTitle;
  String packagePrice;
  String billingType;
  String noOfPosts;
  String renwal;
  String expiryDate;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        packageTitle: json["package_title"],
        packagePrice: json["package_price"],
        billingType: json["billing_type"],
        noOfPosts: json["no_of_posts"],
        renwal: json["renwal"],
        expiryDate: json["expiry_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "package_title": packageTitle,
        "package_price": packagePrice,
        "billing_type": billingType,
        "no_of_posts": noOfPosts,
        "renwal": renwal,
        "expiry_date": expiryDate,
      };
}

class Packs {
  Packs({
    required this.status,
    required this.text,
    required this.message,
    required this.data,
  });

  String status, message;
  String text;
  List<Datum> data;

  factory Packs.fromJson(Map<String, dynamic> json) => Packs(
        status: json["status"],
        text: json["text"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "text": text,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.packageTitle,
    required this.packagePrice,
    required this.packagePriceFor,
    required this.billingType,
    required this.noOfPosts,
    required this.contactNumber,
    required this.whatsappNumber,
  });

  String id;
  String packageTitle;
  String packagePrice;
  String packagePriceFor;
  String billingType;
  String noOfPosts;
  String contactNumber;
  String whatsappNumber;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        packageTitle: json["package_title"],
        packagePrice: json["package_price"],
        packagePriceFor: json["package_price_for"],
        billingType: json["billing_type"],
        noOfPosts: json["no_of_posts"],
        contactNumber: json["contact_number"],
        whatsappNumber: json["whatsapp_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "package_title": packageTitle,
        "package_price": packagePrice,
        "package_price_for": packagePriceFor,
        "billing_type": billingType,
        "no_of_posts": noOfPosts,
        "contact_number": contactNumber,
        "whatsapp_number": whatsappNumber,
      };
}
