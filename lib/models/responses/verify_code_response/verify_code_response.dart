import 'package:json_annotation/json_annotation.dart';

part 'verify_code_response.g.dart';

@JsonSerializable()
class VerifyCodeResponse {
  bool success;
  String token;
  String? statusText;

  VerifyCodeResponse({
    required this.success,
    required this.token,
    this.statusText,
  });

  factory VerifyCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyCodeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$VerifyCodeResponseToJson(this);
}
