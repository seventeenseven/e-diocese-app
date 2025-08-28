// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_activite_participate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetActiviteParticipate _$GetActiviteParticipateFromJson(
        Map<String, dynamic> json) =>
    GetActiviteParticipate(
      success: json['success'] as bool,
      activities: (json['activities'] as List<dynamic>)
          .map((e) => ActiviteParticipate.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetActiviteParticipateToJson(
        GetActiviteParticipate instance) =>
    <String, dynamic>{
      'success': instance.success,
      'activities': instance.activities,
    };
