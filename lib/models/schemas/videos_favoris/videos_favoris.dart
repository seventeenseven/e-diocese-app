import 'package:ediocese_app/models/schemas/video/video.dart';
import 'package:json_annotation/json_annotation.dart';

part 'videos_favoris.g.dart';

@JsonSerializable()
class VideosFavoris {
  String id;
  Video video;

  VideosFavoris({required this.id, required this.video});

  factory VideosFavoris.fromJson(Map<String, dynamic> json) =>
      _$VideosFavorisFromJson(json);
  Map<String, dynamic> toJson() => _$VideosFavorisToJson(this);
}
