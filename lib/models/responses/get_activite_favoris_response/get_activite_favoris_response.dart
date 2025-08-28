import 'package:ediocese_app/models/schemas/activite_favoris/activite_favoris.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_activite_favoris_response.g.dart';

@JsonSerializable()
class GetActiviteFavorisResponse {
  bool success;
  List<ActiviteFavoris> activiteFavoris;

  GetActiviteFavorisResponse(
      {required this.success, required this.activiteFavoris});

  factory GetActiviteFavorisResponse.fromJson(Map<String, dynamic> json) =>
      _$GetActiviteFavorisResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetActiviteFavorisResponseToJson(this);
}
