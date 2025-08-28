// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_videos_favoris_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetVideosFavorisResponse _$GetVideosFavorisResponseFromJson(
        Map<String, dynamic> json) =>
    GetVideosFavorisResponse(
      success: json['success'] as bool,
      videosFavoris: (json['videosFavoris'] as List<dynamic>)
          .map((e) => VideosFavoris.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetVideosFavorisResponseToJson(
        GetVideosFavorisResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'videosFavoris': instance.videosFavoris,
    };
