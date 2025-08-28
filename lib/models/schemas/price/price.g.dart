// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Price _$PriceFromJson(Map<String, dynamic> json) => Price(
      id: json['_id'] as String,
      label: json['label'] as String,
      value: json['value'] as int,
    );

Map<String, dynamic> _$PriceToJson(Price instance) => <String, dynamic>{
      '_id': instance.id,
      'label': instance.label,
      'value': instance.value,
    };
