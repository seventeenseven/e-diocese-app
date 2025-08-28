// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_video_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetVideoResponse _$GetVideoResponseFromJson(Map<String, dynamic> json) =>
    GetVideoResponse(
      success: json['success'] as bool,
      count: json['count'] as int,
      videos: (json['videos'] as List<dynamic>)
          .map((e) => Video.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetVideoResponseToJson(GetVideoResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'videos': instance.videos,
    };
