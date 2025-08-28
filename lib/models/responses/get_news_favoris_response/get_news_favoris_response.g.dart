// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_news_favoris_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetNewsFavorisResponse _$GetNewsFavorisResponseFromJson(
        Map<String, dynamic> json) =>
    GetNewsFavorisResponse(
      success: json['success'] as bool,
      newsFavoris: (json['newsFavoris'] as List<dynamic>)
          .map((e) => NewsFavoris.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetNewsFavorisResponseToJson(
        GetNewsFavorisResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'newsFavoris': instance.newsFavoris,
    };
