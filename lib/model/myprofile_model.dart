import 'dart:convert';

MyProfileModel myProfileModelFromJson(String str) =>
    MyProfileModel.fromJson(json.decode(str));

String myProfileModelToJson(MyProfileModel data) => json.encode(data.toJson());

class MyProfileModel {
  MyProfileModel({
    required this.id,
    required this.accessToken,
    required this.name,
    required this.email,
    required this.mobile,
    required this.gender,
    required this.city,
    required this.image,
    required this.fullImage,
    required this.notification,
  });

  String id;
  String accessToken;
  String name;
  String email;
  String mobile;
  String gender;
  String city;
  String image;
  String fullImage;
  bool notification;

  factory MyProfileModel.fromJson(Map<String, dynamic> json) => MyProfileModel(
      id: json["id"],
      accessToken: json["access_token"],
      name: json["name"],
      email: json["email"],
      mobile: json["mobile"],
      gender: json["gender"],
      city: json["city"],
      image: json["image"],
      fullImage: json['image_full_path'],
      notification: json['notification']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "access_token": accessToken,
        "name": name,
        "email": email,
        "mobile": mobile,
        "gender": gender,
        "city": city,
        "image": image,
        "image_full_path": fullImage,
        "notification": notification
      };
}
