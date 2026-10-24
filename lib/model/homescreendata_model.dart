// To parse this JSON data, do
//
//     final homeScreenDataModel = homeScreenDataModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

HomeScreenDataModel homeScreenDataModelFromJson(String str) =>
    HomeScreenDataModel.fromJson(json.decode(str));

String homeScreenDataModelToJson(HomeScreenDataModel data) =>
    json.encode(data.toJson());

class HomeScreenDataModel {
  HomeScreenDataModel({
    required this.banners,
    required this.categories,
    required this.recentPost,
    required this.notification,
  });

  List<Banner> banners;
  List<Category> categories;
  List<RecentPost> recentPost;
  bool notification;

  factory HomeScreenDataModel.fromJson(Map<String, dynamic> json) =>
      HomeScreenDataModel(
        banners:
            List<Banner>.from(json["banners"].map((x) => Banner.fromJson(x))),
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
        recentPost: List<RecentPost>.from(
            json["recent_post"].map((x) => RecentPost.fromJson(x))),
        notification: json["notification"],
      );

  Map<String, dynamic> toJson() => {
        "banners": List<dynamic>.from(banners.map((x) => x.toJson())),
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "recent_post": List<dynamic>.from(recentPost.map((x) => x.toJson())),
        "notification": notification,
      };
}

class Banner {
  Banner({
    required this.id,
    required this.type,
    required this.image,
    required this.video,
    required this.videoId,
  });

  String id;
  String type;
  String image;
  String video, videoId;

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        id: json["id"],
        type: json["type"],
        image: json["image"],
        video: json["video"],
        videoId: json["video_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "image": image,
        "video": video,
        "video_id": videoId
      };
}

class Category {
  Category({
    required this.id,
    required this.title,
    required this.languageEnglish,
    required this.languageKanada,
    required this.image,
  });

  String id;
  String title;
  String languageEnglish;
  String languageKanada;
  String image;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        title: json["title"],
        languageEnglish: json["language_english"],
        languageKanada: json["language_kanada"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "language_english": languageEnglish,
        "language_kanada": languageKanada,
        "image": image,
      };
}

class RecentPost {
  RecentPost({
    required this.id,
    required this.requestId,
    required this.title,
    required this.name,
    required this.mobile,
    required this.image,
    required this.categoryName,
  });

  String id;
  String requestId;
  String title;
  String name;
  String mobile;
  String? image, categoryName;

  factory RecentPost.fromJson(Map<String, dynamic> json) => RecentPost(
      id: json["id"],
      requestId: json["request_id"],
      title: json["title"],
      name: json["name"],
      mobile: json["mobile"],
      image: json["image"],
      categoryName: json['category_name']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "request_id": requestId,
        "title": title,
        "name": name,
        "mobile": mobile,
        "image": image,
        "category_name": categoryName
      };
}
