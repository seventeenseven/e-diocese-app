import 'package:ediocese_app/models/schemas/news/news.dart';
import 'package:json_annotation/json_annotation.dart';

part 'news_favoris.g.dart';

@JsonSerializable()
class NewsFavoris {
  String id;
  News news;

  NewsFavoris({required this.id, required this.news});

  factory NewsFavoris.fromJson(Map<String, dynamic> json) =>
      _$NewsFavorisFromJson(json);
  Map<String, dynamic> toJson() => _$NewsFavorisToJson(this);
}
