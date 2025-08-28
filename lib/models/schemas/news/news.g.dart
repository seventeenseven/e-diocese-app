// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) => News(
    id: json['_id'] as String,
    titre: json['titre'] as String,
    sousTitre: json['sousTitre'] as String,
    description: json['description'] as String,
    image: json['image'] as String,
    favoris: json['favoris'] as bool);

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      '_id': instance.id,
      'titre': instance.titre,
      'sousTitre': instance.sousTitre,
      'description': instance.description,
      'image': instance.image,
      'favoris': instance.favoris
    };
