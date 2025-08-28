// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_activite_favoris_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetActiviteFavorisResponse _$GetActiviteFavorisResponseFromJson(
        Map<String, dynamic> json) =>
    GetActiviteFavorisResponse(
      success: json['success'] as bool,
      activiteFavoris: (json['activiteFavoris'] as List<dynamic>)
          .map((e) => ActiviteFavoris.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetActiviteFavorisResponseToJson(
        GetActiviteFavorisResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'activiteFavoris': instance.activiteFavoris,
    };
