// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_only_activite_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetOnlyActiviteResponse _$GetOnlyActiviteResponseFromJson(
        Map<String, dynamic> json) =>
    GetOnlyActiviteResponse(
      success: json['success'] as bool,
      activite: Activite.fromJson(
        json['activite'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$GetOnlyActiviteResponseToJson(
        GetOnlyActiviteResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'activite': instance.activite,
    };
