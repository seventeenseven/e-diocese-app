// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_priere_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetPriereResponse _$GetPriereResponseFromJson(Map<String, dynamic> json) =>
    GetPriereResponse(
      success: json['success'] as bool,
      count: json['count'] as int,
      prieres: (json['prieres'] as List<dynamic>)
          .map((e) => Priere.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetPriereResponseToJson(GetPriereResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'prieres': instance.prieres,
    };
