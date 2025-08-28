// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activite _$ActiviteFromJson(Map<String, dynamic> json) => Activite(
    id: json['_id'] as String,
    titre: json['titre'] as String,
    description: json['description'] as String,
    ville: json['ville'] as String,
    image: json['image'] as String,
    commune: json['commune'] as String,
    date: DateTime.parse(json['date'] as String),
    favoris: json['favoris'] as bool,
    participate: json['participate'] as bool);

Map<String, dynamic> _$ActiviteToJson(Activite instance) => <String, dynamic>{
      '_id': instance.id,
      'titre': instance.titre,
      'description': instance.description,
      'ville': instance.ville,
      'image': instance.image,
      'commune': instance.commune,
      'date': instance.date,
      'favoris': instance.favoris,
      'participate': instance.participate,
    };
