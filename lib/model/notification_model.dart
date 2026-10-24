import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.message,
    required this.customerId,
    required this.orderId,
    required this.viewStatus,
    required this.createdAt,
    required this.description,
    required this.title,
    required this.categoryName,
  });

  String id;
  String message;
  String customerId;
  String orderId;
  String viewStatus;
  String createdAt, description;
  dynamic title, categoryName;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        message: json["message"],
        customerId: json["customer_id"],
        orderId: json["order_id"],
        viewStatus: json["view_status"],
        createdAt: json["created_at"],
        description: json["description"],
        categoryName: json["category"],
        title: json["post"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "customer_id": customerId,
        "order_id": orderId,
        "view_status": viewStatus,
        "created_at": createdAt,
        "description": description,
        "post": title,
        "category": categoryName
      };
}
