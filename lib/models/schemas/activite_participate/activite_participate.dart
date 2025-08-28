import 'package:ediocese_app/models/schemas/activite/activite.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activite_participate.g.dart';

@JsonSerializable()
class ActiviteParticipate {
  String id;
  Activite activite;

  ActiviteParticipate({required this.id, required this.activite});

  factory ActiviteParticipate.fromJson(Map<String, dynamic> json) =>
      _$ActiviteParticipateFromJson(json);
  Map<String, dynamic> toJson() => _$ActiviteParticipateToJson(this);
}
