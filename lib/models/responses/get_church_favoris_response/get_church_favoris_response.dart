import 'package:ediocese_app/models/schemas/church_favoris/church_favoris.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_church_favoris_response.g.dart';

@JsonSerializable()
class GetChurchFavorisResponse {
  bool success;
  List<ChurchFavoris> favoris;

  GetChurchFavorisResponse({required this.success, required this.favoris});

  factory GetChurchFavorisResponse.fromJson(Map<String, dynamic> json) =>
      _$GetChurchFavorisResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetChurchFavorisResponseToJson(this);
}
