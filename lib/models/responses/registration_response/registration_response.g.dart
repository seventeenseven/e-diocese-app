// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationResponse _$RegistrationResponseFromJson(
        Map<String, dynamic> json) =>
    RegistrationResponse(
        success: json['success'] as bool,
        token: json['token'] == null ? null : json['token'] as String,
        user: User.fromJson(
          json['user'] as Map<String, dynamic>,
        ),
        sessionId:
            json['sessionId'] == null ? null : json['sessionId'] as String,
        statusText:
            json['statusText'] == null ? null : json['statusText'] as String);

Map<String, dynamic> _$RegistrationResponseToJson(
        RegistrationResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'token': instance.token,
      'user': instance.user,
      'sessionId': instance.sessionId,
      'statusText': instance.statusText,
    };
