// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_church_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetChurchResponse _$GetChurchResponseFromJson(Map<String, dynamic> json) =>
    GetChurchResponse(
      success: json['success'] as bool,
      count: json['count'] as int,
      churchs: (json['churchs'] as List<dynamic>)
          .map((e) => Church.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetChurchResponseToJson(GetChurchResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'churchs': instance.churchs,
    };
