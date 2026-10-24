import 'dart:convert';

CategoryPostModel categoryPostModelFromJson(String str) =>
    CategoryPostModel.fromJson(json.decode(str));

String categoryPostModelToJson(CategoryPostModel data) =>
    json.encode(data.toJson());

class CategoryPostModel {
  CategoryPostModel({
    required this.id,
    required this.requestId,
    required this.categoryId,
    required this.title,
    required this.name,
    required this.mobile,
    required this.whatsappNumber,
    required this.status,
    required this.profileImage,
    required this.postImage,
    required this.createdDate,
  });

  String id;
  String requestId;
  String categoryId;
  String title;
  String name;
  String mobile;
  String whatsappNumber;
  String status;
  String profileImage;
  String postImage;
  String createdDate;

  factory CategoryPostModel.fromJson(Map<String, dynamic> json) =>
      CategoryPostModel(
          id: json["id"],
          requestId: json["request_id"],
          categoryId: json["category_id"],
          title: json["title"],
          name: json["name"],
          mobile: json["mobile"],
          whatsappNumber: json["whatsapp_number"],
          status: json["status"],
          profileImage: json["profile_image"],
          postImage: json["post_image"],
          createdDate: json['created_date']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "request_id": requestId,
        "category_id": categoryId,
        "title": title,
        "name": name,
        "mobile": mobile,
        "whatsapp_number": whatsappNumber,
        "status": status,
        "profile_image": profileImage,
        "post_image": postImage,
        "created_date": createdDate,
      };
}
