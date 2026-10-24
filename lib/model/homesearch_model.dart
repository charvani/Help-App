import 'dart:convert';

HomeSearchModel homeSearchModelFromJson(String str) =>
    HomeSearchModel.fromJson(json.decode(str));

String homeSearchModelToJson(HomeSearchModel data) =>
    json.encode(data.toJson());

class HomeSearchModel {
  HomeSearchModel({
    required this.id,
    required this.title,
    required this.image,
  });

  String id;
  String title;
  String image;

  factory HomeSearchModel.fromJson(Map<String, dynamic> json) =>
      HomeSearchModel(
        id: json["id"],
        title: json["title"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
      };
}
