// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_code_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyCodeResponse _$VerifyCodeResponseFromJson(Map<String, dynamic> json) =>
    VerifyCodeResponse(
        success: json['success'] as bool,
        token: json['token'] as String,
        statusText:
            json['statusText'] == null ? null : json['statusText'] as String);

Map<String, dynamic> _$VerifyCodeResponseToJson(VerifyCodeResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'token': instance.token,
      'statusText': instance.statusText,
    };
