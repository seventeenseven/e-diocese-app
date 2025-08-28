// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_favoris.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChurchFavoris _$ChurchFavorisFromJson(Map<String, dynamic> json) =>
    ChurchFavoris(
      id: json['_id'] as String,
      church: Church.fromJson(
        json['church'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ChurchFavorisToJson(ChurchFavoris instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'church': instance.church,
    };
