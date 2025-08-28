import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String? picture;
  bool emailVerified;
  bool phoneVerified;

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone,
      this.picture,
      required this.emailVerified,
      required this.phoneVerified});

  User.withValues(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone,
      this.picture,
      required this.emailVerified,
      required this.phoneVerified});

  User clone(
      {id,
      firstName,
      lastName,
      email,
      phone,
      picture,
      emailVerified,
      phoneVerified}) {
    return User.withValues(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        picture: picture ?? this.picture,
        phoneVerified: phoneVerified ?? this.phoneVerified,
        emailVerified: emailVerified ?? this.emailVerified);
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
