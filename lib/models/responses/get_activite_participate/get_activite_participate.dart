import 'package:ediocese_app/models/schemas/activite_participate/activite_participate.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_activite_participate.g.dart';

@JsonSerializable()
class GetActiviteParticipate {
  bool success;
  List<ActiviteParticipate> activities;

  GetActiviteParticipate({required this.success, required this.activities});

  factory GetActiviteParticipate.fromJson(Map<String, dynamic> json) =>
      _$GetActiviteParticipateFromJson(json);
  Map<String, dynamic> toJson() => _$GetActiviteParticipateToJson(this);
}
