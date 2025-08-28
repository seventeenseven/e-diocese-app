import 'package:ediocese_app/models/schemas/church/church.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_only_church_response.g.dart';

@JsonSerializable()
class GetOnlyChurchResponse {
  bool success;
  Church church;

  GetOnlyChurchResponse({
    required this.success,
    required this.church,
  });

  factory GetOnlyChurchResponse.fromJson(Map<String, dynamic> json) =>
      _$GetOnlyChurchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetOnlyChurchResponseToJson(this);
}
