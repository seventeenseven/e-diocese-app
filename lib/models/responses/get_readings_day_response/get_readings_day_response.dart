import 'package:ediocese_app/models/schemas/reading_day/reading_day.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_readings_day_response.g.dart';

@JsonSerializable()
class GetReadingsDayResponse {
  bool success;
  List<ReadingDay> readingsDay;

  GetReadingsDayResponse({
    required this.success,
    required this.readingsDay,
  });

  factory GetReadingsDayResponse.fromJson(Map<String, dynamic> json) =>
      _$GetReadingsDayResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetReadingsDayResponseToJson(this);
}
