import 'package:ediocese_app/models/schemas/activite/activite.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_activite_response.g.dart';

@JsonSerializable()
class GetActivitesResponse {
  bool success;
  int count;
  List<Activite> activites;

  GetActivitesResponse({
    required this.success,
    required this.count,
    required this.activites,
  });

  factory GetActivitesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetActivitesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetActivitesResponseToJson(this);
}
