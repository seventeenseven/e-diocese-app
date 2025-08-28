// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_news_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetNewsResponse _$GetNewsResponseFromJson(Map<String, dynamic> json) =>
    GetNewsResponse(
      success: json['success'] as bool,
      count: json['count'] as int,
      news: (json['news'] as List<dynamic>)
          .map((e) => News.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetNewsResponseToJson(GetNewsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'news': instance.news,
    };
