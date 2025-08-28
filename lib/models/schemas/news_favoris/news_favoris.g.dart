// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_favoris.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsFavoris _$NewsFavorisFromJson(Map<String, dynamic> json) => NewsFavoris(
      id: json['_id'] as String,
      news: News.fromJson(
        json['news'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$NewsFavorisToJson(NewsFavoris instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'news': instance.news,
    };
