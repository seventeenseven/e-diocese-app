import 'package:ediocese_app/models/schemas/videos_favoris/videos_favoris.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_videos_favoris_response.g.dart';

@JsonSerializable()
class GetVideosFavorisResponse {
  bool success;
  List<VideosFavoris> videosFavoris;

  GetVideosFavorisResponse(
      {required this.success, required this.videosFavoris});

  factory GetVideosFavorisResponse.fromJson(Map<String, dynamic> json) =>
      _$GetVideosFavorisResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetVideosFavorisResponseToJson(this);
}
