import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.languageEnglish,
    required this.languageKanada,
    required this.title,
    required this.image,
  });

  String id;
  String languageEnglish;
  String languageKanada;
  String title;
  String image;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        languageEnglish: json["language_english"],
        languageKanada: json["language_kanada"],
        title: json["title"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "language_english": languageEnglish,
        "language_kanada": languageKanada,
        "title": title,
        "image": image,
      };
}
