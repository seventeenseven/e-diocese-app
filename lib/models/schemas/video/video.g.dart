// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
      id: json['_id'] as String,
      titre: json['titre'] as String,
      url: json['url'] as String,
      description: json['description'] as String,
      favoris: json['favoris'] as bool,
    );

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      '_id': instance.id,
      'titre': instance.titre,
      'url': instance.url,
      'description': instance.description,
      'favoris': instance.favoris
    };
