import 'package:ediocese_app/models/schemas/video/video.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_only_video_response.g.dart';

@JsonSerializable()
class GetOnlyVideoResponse {
  bool success;
  Video video;

  GetOnlyVideoResponse({
    required this.success,
    required this.video,
  });

  factory GetOnlyVideoResponse.fromJson(Map<String, dynamic> json) =>
      _$GetOnlyVideoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetOnlyVideoResponseToJson(this);
}
