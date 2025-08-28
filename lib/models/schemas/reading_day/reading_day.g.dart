// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReadingDay _$ReadingDayFromJson(Map<String, dynamic> json) => ReadingDay(
      success: json['success'] as bool,
      id: json['_id'] as String,
      titre: json['titre'] as String,
      passage: json['passage'] as String,
      versets: json['versets'] as String,
      contenu: json['contenu'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$ReadingDayToJson(ReadingDay instance) =>
    <String, dynamic>{
      'success': instance.success,
      '_id': instance.id,
      'titre': instance.titre,
      'passage': instance.passage,
      'versets': instance.versets,
      'contenu': instance.contenu,
      'date': instance.date,
    };
