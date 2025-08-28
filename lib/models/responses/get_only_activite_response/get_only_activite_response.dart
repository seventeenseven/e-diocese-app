import 'package:ediocese_app/models/schemas/activite/activite.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_only_activite_response.g.dart';

@JsonSerializable()
class GetOnlyActiviteResponse {
  bool success;
  Activite activite;

  GetOnlyActiviteResponse({
    required this.success,
    required this.activite,
  });

  factory GetOnlyActiviteResponse.fromJson(Map<String, dynamic> json) =>
      _$GetOnlyActiviteResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetOnlyActiviteResponseToJson(this);
}
