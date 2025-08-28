// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_only_news_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetOnlyNewsResponse _$GetOnlyNewsResponseFromJson(
        Map<String, dynamic> json) =>
    GetOnlyNewsResponse(
      success: json['success'] as bool,
      news: News.fromJson(
        json['news'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$GetOnlyNewsResponseToJson(
        GetOnlyNewsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'news': instance.news,
    };
