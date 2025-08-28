// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_activite_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetActivitesResponse _$GetActivitesResponseFromJson(
        Map<String, dynamic> json) =>
    GetActivitesResponse(
      success: json['success'] as bool,
      count: json['count'] as int,
      activites: (json['activites'] as List<dynamic>)
          .map((e) => Activite.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetActivitesResponseToJson(
        GetActivitesResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'activites': instance.activites,
    };
