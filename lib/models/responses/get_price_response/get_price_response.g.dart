// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_price_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetPriceResponse _$GetPriceResponseFromJson(Map<String, dynamic> json) =>
    GetPriceResponse(
      success: json['success'] as bool,
      prices: (json['prices'] as List<dynamic>)
          .map((e) => Price.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetPriceResponseToJson(GetPriceResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'prices': instance.prices,
    };
