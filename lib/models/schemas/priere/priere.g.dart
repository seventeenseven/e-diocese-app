// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'priere.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Priere _$PriereFromJson(Map<String, dynamic> json) => Priere(
    id: json['_id'] as String,
    sujet: json['sujet'] as String,
    temps: json['temps'] as String,
    periode: json['periode'] as String,
    description: json['description'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String));

Map<String, dynamic> _$PriereToJson(Priere instance) => <String, dynamic>{
      '_id': instance.id,
      'sujet': instance.sujet,
      'temps': instance.temps,
      'periode': instance.periode,
      'description': instance.description,
      'createdAt': instance.createdAt,
    };
