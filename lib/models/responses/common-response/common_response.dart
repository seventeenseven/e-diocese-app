import 'package:json_annotation/json_annotation.dart';

part 'common_response.g.dart';

@JsonSerializable()
class CommonResponse {
  bool? success;
  bool? error;
  String? errorMessage;
  int? status;
  String? statusText;
  String? message;

  CommonResponse(
      {this.success,
      this.error,
      this.errorMessage,
      this.status,
      this.statusText,
      this.message});

  factory CommonResponse.fromJson(Map<String, dynamic> json) =>
      _$CommonResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CommonResponseToJson(this);

  String get anyErrorMessage {
    String errorText =
        "Une erreur s'est produite! Prière réessayer plus tard ou contacter le service client";
    if (error == true && errorMessage != null) {
      errorText = errorMessage!;
    } else if (status != null && statusText != null) {
      errorText = statusText!;
    }
    return errorText;
  }
}
