import 'package:ediocese_app/models/schemas/church/church.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_church_response.g.dart';

@JsonSerializable()
class GetChurchResponse {
  bool success;
  int count;
  List<Church> churchs;

  GetChurchResponse({
    required this.success,
    required this.count,
    required this.churchs,
  });

  factory GetChurchResponse.fromJson(Map<String, dynamic> json) =>
      _$GetChurchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetChurchResponseToJson(this);
}
