import 'package:ediocese_app/models/schemas/church/church.dart';
import 'package:json_annotation/json_annotation.dart';

part 'church_favoris.g.dart';

@JsonSerializable()
class ChurchFavoris {
  String id;
  Church church;

  ChurchFavoris({required this.id, required this.church});

  factory ChurchFavoris.fromJson(Map<String, dynamic> json) =>
      _$ChurchFavorisFromJson(json);
  Map<String, dynamic> toJson() => _$ChurchFavorisToJson(this);
}
