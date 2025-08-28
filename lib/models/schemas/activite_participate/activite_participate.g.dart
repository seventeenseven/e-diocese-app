// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activite_participate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiviteParticipate _$ActiviteParticipateFromJson(Map<String, dynamic> json) =>
    ActiviteParticipate(
      id: json['_id'] as String,
      activite: Activite.fromJson(
        json['activite'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ActiviteParticipateToJson(
        ActiviteParticipate instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'activite': instance.activite,
    };
