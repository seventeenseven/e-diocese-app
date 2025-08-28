import 'package:ediocese_app/models/schemas/news_favoris/news_favoris.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_news_favoris_response.g.dart';

@JsonSerializable()
class GetNewsFavorisResponse {
  bool success;
  List<NewsFavoris> newsFavoris;

  GetNewsFavorisResponse({required this.success, required this.newsFavoris});

  factory GetNewsFavorisResponse.fromJson(Map<String, dynamic> json) =>
      _$GetNewsFavorisResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetNewsFavorisResponseToJson(this);
}
