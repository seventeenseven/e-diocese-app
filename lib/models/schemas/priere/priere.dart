import 'package:json_annotation/json_annotation.dart';

part 'priere.g.dart';

@JsonSerializable()
class Priere {
  String id;
  String sujet;
  String temps;
  String periode;
  String description;
  DateTime createdAt;

  Priere({
    required this.id,
    required this.sujet,
    required this.temps,
    required this.periode,
    required this.description,
    required this.createdAt,
  });

  factory Priere.fromJson(Map<String, dynamic> json) => _$PriereFromJson(json);
  Map<String, dynamic> toJson() => _$PriereToJson(this);
}
