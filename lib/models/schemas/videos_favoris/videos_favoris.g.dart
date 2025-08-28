// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'videos_favoris.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideosFavoris _$VideosFavorisFromJson(Map<String, dynamic> json) =>
    VideosFavoris(
      id: json['_id'] as String,
      video: Video.fromJson(
        json['video'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$VideosFavorisToJson(VideosFavoris instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'video': instance.video,
    };
