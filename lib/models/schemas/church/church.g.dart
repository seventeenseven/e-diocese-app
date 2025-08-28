// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Church _$ChurchFromJson(Map<String, dynamic> json) => Church(
      id: json['_id'] as String,
      nom: json['nom'] as String,
      description: json['description'] as String,
      ville: json['ville'] as String,
      image: json['image'] as String,
      commune: json['commune'] as String,
      favoris: json['favoris'] as bool,
      pays: json['pays'] as String,
    );

Map<String, dynamic> _$ChurchToJson(Church instance) => <String, dynamic>{
      '_id': instance.id,
      'nom': instance.nom,
      'description': instance.description,
      'ville': instance.ville,
      'image': instance.image,
      'commune': instance.commune,
      'bool': instance.favoris,
      'pays': instance.pays,
    };
