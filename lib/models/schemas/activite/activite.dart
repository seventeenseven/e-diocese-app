import 'package:json_annotation/json_annotation.dart';

part 'activite.g.dart';

@JsonSerializable()
class Activite {
  String id;
  String titre;
  String description;
  String image;
  String ville;
  String commune;
  DateTime date;
  bool favoris;
  bool participate;

  Activite(
      {required this.id,
      required this.titre,
      required this.description,
      required this.image,
      required this.ville,
      required this.commune,
      required this.date,
      required this.favoris,
      required this.participate});

  factory Activite.fromJson(Map<String, dynamic> json) =>
      _$ActiviteFromJson(json);
  Map<String, dynamic> toJson() => _$ActiviteToJson(this);
}
