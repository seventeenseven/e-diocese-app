// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_only_church_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetOnlyChurchResponse _$GetOnlyChurchResponseFromJson(
        Map<String, dynamic> json) =>
    GetOnlyChurchResponse(
      success: json['success'] as bool,
      church: Church.fromJson(
        json['church'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$GetOnlyChurchResponseToJson(
        GetOnlyChurchResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'church': instance.church,
    };
