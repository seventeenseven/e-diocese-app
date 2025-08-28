import 'package:json_annotation/json_annotation.dart';

part 'video.g.dart';

@JsonSerializable()
class Video {
  String id;
  String titre;
  String url;
  String description;
  bool favoris;

  Video(
      {required this.id,
      required this.titre,
      required this.url,
      required this.description,
      required this.favoris});

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
  Map<String, dynamic> toJson() => _$VideoToJson(this);
}
