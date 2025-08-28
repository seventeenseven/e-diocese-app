import 'package:json_annotation/json_annotation.dart';

part 'church.g.dart';

@JsonSerializable()
class Church {
  String id;
  String nom;
  String description;
  String image;
  String ville;
  String commune;
  bool favoris;
  String pays;

  Church(
      {required this.id,
      required this.nom,
      required this.description,
      required this.image,
      required this.ville,
      required this.commune,
      required this.favoris,
      required this.pays});

  factory Church.fromJson(Map<String, dynamic> json) => _$ChurchFromJson(json);
  Map<String, dynamic> toJson() => _$ChurchToJson(this);
}
