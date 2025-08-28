import 'package:json_annotation/json_annotation.dart';

part 'reading_day.g.dart';

@JsonSerializable()
class ReadingDay {
  bool success;
  String id;
  String titre;
  String passage;
  String versets;
  String contenu;
  DateTime date;

  ReadingDay({
    required this.success,
    required this.id,
    required this.titre,
    required this.passage,
    required this.versets,
    required this.contenu,
    required this.date,
  });

  factory ReadingDay.fromJson(Map<String, dynamic> json) =>
      _$ReadingDayFromJson(json);
  Map<String, dynamic> toJson() => _$ReadingDayToJson(this);
}
