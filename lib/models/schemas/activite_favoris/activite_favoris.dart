import 'package:ediocese_app/models/schemas/activite/activite.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activite_favoris.g.dart';

@JsonSerializable()
class ActiviteFavoris {
  String id;
  Activite activite;

  ActiviteFavoris({required this.id, required this.activite});

  factory ActiviteFavoris.fromJson(Map<String, dynamic> json) =>
      _$ActiviteFavorisFromJson(json);
  Map<String, dynamic> toJson() => _$ActiviteFavorisToJson(this);
}
