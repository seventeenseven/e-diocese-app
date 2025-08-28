import 'package:json_annotation/json_annotation.dart';

part 'news.g.dart';

@JsonSerializable()
class News {
  String id;
  String titre;
  String sousTitre;
  String description;
  String image;
  bool favoris;

  News(
      {required this.id,
      required this.titre,
      required this.sousTitre,
      required this.description,
      required this.image,
      required this.favoris});

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);
  Map<String, dynamic> toJson() => _$NewsToJson(this);
}
