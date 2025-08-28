// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_only_video_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetOnlyVideoResponse _$GetOnlyVideoResponseFromJson(
        Map<String, dynamic> json) =>
    GetOnlyVideoResponse(
      success: json['success'] as bool,
      video: Video.fromJson(
        json['video'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$GetOnlyVideoResponseToJson(
        GetOnlyVideoResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'video': instance.video,
    };
