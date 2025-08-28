// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
    id: json['_id'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    picture: json['picture'] == null ? null : json['picture'] as String,
    emailVerified: json['emailVerified'] as bool,
    phoneVerified: json['phoneVerified'] as bool);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'picture': instance.picture,
      'emailVerified': instance.emailVerified,
      'phoneVerified': instance.phoneVerified,
    };
