import 'package:ediocese_app/models/schemas/news/news.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_news_response.g.dart';

@JsonSerializable()
class GetNewsResponse {
  bool success;
  int count;
  List<News> news;

  GetNewsResponse({
    required this.success,
    required this.count,
    required this.news,
  });

  factory GetNewsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetNewsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetNewsResponseToJson(this);
}
