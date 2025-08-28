import 'package:ediocese_app/models/schemas/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'registration_response.g.dart';

@JsonSerializable()
class RegistrationResponse {
  bool success;
  String? token;
  User user;
  String? sessionId;
  String? statusText;

  RegistrationResponse(
      {required this.success,
      this.token,
      required this.user,
      this.sessionId,
      this.statusText});

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$RegistrationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RegistrationResponseToJson(this);
}
