// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activite_favoris.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiviteFavoris _$ActiviteFavorisFromJson(Map<String, dynamic> json) =>
    ActiviteFavoris(
      id: json['_id'] as String,
      activite: Activite.fromJson(
        json['activite'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ActiviteFavorisToJson(ActiviteFavoris instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'activite': instance.activite,
    };
