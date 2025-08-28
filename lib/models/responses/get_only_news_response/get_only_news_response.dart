import 'package:ediocese_app/models/schemas/news/news.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_only_news_response.g.dart';

@JsonSerializable()
class GetOnlyNewsResponse {
  bool success;
  News news;

  GetOnlyNewsResponse({
    required this.success,
    required this.news,
  });

  factory GetOnlyNewsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetOnlyNewsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetOnlyNewsResponseToJson(this);
}
