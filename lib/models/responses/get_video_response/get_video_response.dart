import 'package:ediocese_app/models/schemas/video/video.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_video_response.g.dart';

@JsonSerializable()
class GetVideoResponse {
  bool success;
  int count;
  List<Video> videos;

  GetVideoResponse({
    required this.success,
    required this.count,
    required this.videos,
  });

  factory GetVideoResponse.fromJson(Map<String, dynamic> json) =>
      _$GetVideoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetVideoResponseToJson(this);
}
