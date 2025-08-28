import 'package:ediocese_app/models/schemas/priere/priere.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_priere_response.g.dart';

@JsonSerializable()
class GetPriereResponse {
  bool success;
  int count;
  List<Priere> prieres;

  GetPriereResponse({
    required this.success,
    required this.count,
    required this.prieres,
  });

  factory GetPriereResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPriereResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetPriereResponseToJson(this);
}
