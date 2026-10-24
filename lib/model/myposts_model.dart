import 'dart:convert';

MyPostModel myPostModelFromJson(String str) =>
    MyPostModel.fromJson(json.decode(str));

String myPostModelToJson(MyPostModel data) => json.encode(data.toJson());

class MyPostModel {
  MyPostModel({
    required this.id,
    required this.title,
    required this.name,
    required this.mobile,
    required this.whatsappNumber,
    required this.status,
    required this.createdDate,
    required this.edit,
    required this.delete,
    required this.image,
    required this.categoryName,
  });

  String id;
  String title;
  String name;
  String mobile;
  String whatsappNumber;
  String status;
  String createdDate;
  String edit;
  String delete;
  String image, categoryName;

  factory MyPostModel.fromJson(Map<String, dynamic> json) => MyPostModel(
        id: json["id"],
        title: json["title"],
        name: json["name"],
        mobile: json["mobile"],
        whatsappNumber: json["whatsapp_number"],
        status: json["status"],
        createdDate: json["created_date"],
        edit: json["edit"],
        delete: json["delete"],
        image: json["image"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "name": name,
        "mobile": mobile,
        "whatsapp_number": whatsappNumber,
        "status": status,
        "created_date": createdDate,
        "edit": edit,
        "delete": delete,
        "image": image,
        "category_name": categoryName
      };
}
