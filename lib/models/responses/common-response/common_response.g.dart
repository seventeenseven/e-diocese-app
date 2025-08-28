// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommonResponse _$CommonResponseFromJson(Map<String, dynamic> json) =>
    CommonResponse(
      success: json['success'] as bool?,
      error: json['error'] as bool?,
      errorMessage: json['errorMessage'] as String?,
      status: json['status'] as int?,
      statusText: json['statusText'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$CommonResponseToJson(CommonResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'errorMessage': instance.errorMessage,
      'status': instance.status,
      'statusText': instance.statusText,
      'message': instance.message,
    };
