// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_church_favoris_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetChurchFavorisResponse _$GetChurchFavorisResponseFromJson(
        Map<String, dynamic> json) =>
    GetChurchFavorisResponse(
      success: json['success'] as bool,
      favoris: (json['favoris'] as List<dynamic>)
          .map((e) => ChurchFavoris.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetChurchFavorisResponseToJson(
        GetChurchFavorisResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'favoris': instance.favoris,
    };
