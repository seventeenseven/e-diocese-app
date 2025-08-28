// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_readings_day_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetReadingsDayResponse _$GetReadingsDayResponseFromJson(
        Map<String, dynamic> json) =>
    GetReadingsDayResponse(
      success: json['success'] as bool,
      readingsDay: (json['readingsDay'] as List<dynamic>)
          .map((e) => ReadingDay.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetReadingsDayResponseToJson(
        GetReadingsDayResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'readingsDay': instance.readingsDay,
    };
