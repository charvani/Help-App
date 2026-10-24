// To parse this JSON data, do
//
//     final subscriptionsDisableModel = subscriptionsDisableModelFromJson(jsonString);

import 'dart:convert';

SubscriptionsDisableModel subscriptionsDisableModelFromJson(String str) =>
    SubscriptionsDisableModel.fromJson(json.decode(str));

String subscriptionsDisableModelToJson(SubscriptionsDisableModel data) =>
    json.encode(data.toJson());

class SubscriptionsDisableModel {
  SubscriptionsDisableModel({
    required this.status,
    required this.heading,
    required this.heading1,
    required this.data,
    required this.title,
    required this.packs,
  });

  String status;
  String heading;
  String heading1;
  Data1 data;
  String title;
  Packs1 packs;

  factory SubscriptionsDisableModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionsDisableModel(
        status: json["status"],
        heading: json["heading"],
        heading1: json["heading1"],
        data: Data1.fromJson(json["data"]),
        title: json["title"],
        packs: Packs1.fromJson(json["packs"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "heading": heading,
        "heading1": heading1,
        "data": data.toJson(),
        "title": title,
        "packs": packs.toJson(),
      };
}

class Data1 {
  Data1({
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

  factory Data1.fromJson(Map<String, dynamic> json) => Data1(
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

class Packs1 {
  Packs1({
    required this.status,
    required this.message,
  });

  String status;
  String message;

  factory Packs1.fromJson(Map<String, dynamic> json) => Packs1(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
