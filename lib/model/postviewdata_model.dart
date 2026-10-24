import 'dart:convert';

PostViewDataModel postViewDataModelFromJson(String str) =>
    PostViewDataModel.fromJson(json.decode(str));

String postViewDataModelToJson(PostViewDataModel data) =>
    json.encode(data.toJson());

class PostViewDataModel {
  PostViewDataModel({
    required this.id,
    required this.title,
    required this.name,
    required this.mobile,
    required this.whatsappNumber,
    required this.video,
    required this.status,
    required this.videoId,
    required this.createdDate,
    required this.requestedId,
    required this.categoryId,
    required this.languageEnglish,
    required this.languageKanada,
    required this.description,
    required this.viewCount,
  });

  String id;
  String title;
  String name;
  String mobile;
  String whatsappNumber;
  String video;
  String status;
  dynamic videoId;
  String createdDate, requestedId, categoryId;
  dynamic languageEnglish;
  dynamic languageKanada;
  String description, viewCount;

  factory PostViewDataModel.fromJson(Map<String, dynamic> json) =>
      PostViewDataModel(
        id: json["id"],
        title: json["title"],
        name: json["name"],
        mobile: json["mobile"],
        whatsappNumber: json["whatsapp_number"],
        video: json["video"],
        status: json["status"],
        videoId: json["video_id"],
        createdDate: json["created_date"],
        requestedId: json['request_id'],
        categoryId: json['category_id'],
        languageEnglish: json["language_english"],
        languageKanada: json["language_kanada"],
        description: json["description"],
        viewCount: json["view_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "name": name,
        "mobile": mobile,
        "whatsapp_number": whatsappNumber,
        "video": video,
        "status": status,
        "video_id": videoId,
        "created_date": createdDate,
        "request_id": requestedId,
        "category_id": categoryId,
        "language_english": languageEnglish,
        "language_kanada": languageKanada,
        "description": description,
        "view_count": viewCount
      };
}
