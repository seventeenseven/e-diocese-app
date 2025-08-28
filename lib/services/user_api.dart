// ignore_for_file: import_of_legacy_library_into_null_safe, depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:ediocese_app/components/utils/phone-utils.dart';
import 'package:ediocese_app/exceptions/general_exception.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/responses/common-response/common_response.dart';
import 'package:ediocese_app/models/responses/registration_response/registration_response.dart';
import 'package:ediocese_app/models/responses/verify_code_response/verify_code_response.dart';
import 'package:ediocese_app/models/schemas/user/user.dart';
import 'package:ediocese_app/services/safe_secure_storage.dart';
import 'package:ediocese_app/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserApi {
  late final AppConfig config;
  late final http.Client client;
  final String endpoint = '/users';
  final storage = container<SafeSecureStorage>();

  UserApi({required this.config, required this.client});

  Future<RegistrationResponse> registration(
      {required String firstName,
      required String lastName,
      String? email,
      required String phone,
      required String country,
      required String ville}) async {
    final String url = "${config.apiBaseUrl}$endpoint/registration";

    print(url);

    final body = jsonEncode({
      'firstName': firstName,
      'lastName': lastName,
      if (email != null) 'email': email,
      'phone': PhoneUtils.getNormalizedNumber(phone),
      'country': country,
      'ville': ville
    });
    final response = await client.post(Uri.parse(url),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: body);

    print(response.body);
    print('=== API RESPONSE ===');
    print('URL: $url');
    print('Status: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Body: ${response.body}');

    final responseMap = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw const GeneralException(
          "Impossible d'effectuer l'inscription pour le moment, Réessayer plus tard");
    }

    final registrationResponse = RegistrationResponse.fromJson(responseMap);
    return registrationResponse;
  }

  Future<CommonResponse> checkVerificationCode(
      String email, String code) async {
    final String url = "${config.apiBaseUrl}$endpoint/check-verification-code";

    print(url);

    final body = jsonEncode({'email': email, 'code': code});
    final response = await client.post(Uri.parse(url),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: body);

    print(response.body);

    final responseMap = jsonDecode(response.body);

    final verificationResponse = CommonResponse.fromJson(responseMap);

    if (response.statusCode != 200) {
      if (response.statusCode == 404 || response.statusCode == 400) {
        throw GeneralException(verificationResponse.statusText.toString());
      }
      throw GeneralException(
          CommonResponse.fromJson(responseMap).anyErrorMessage);
    }

    return verificationResponse;
  }

  Future<VerifyCodeResponse> verifyCodeReset(String email, String code) async {
    final String url = "${config.apiBaseUrl}$endpoint/verify-code-reset";

    print(url);

    final body = jsonEncode({'email': email, 'code': code});
    final response = await client.post(Uri.parse(url),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: body);

    print(response.body);

    final responseMap = jsonDecode(response.body);

    final verificationResponse = VerifyCodeResponse.fromJson(responseMap);

    if (response.statusCode != 200) {
      if (response.statusCode == 404 || response.statusCode == 400) {
        throw GeneralException(verificationResponse.statusText.toString());
      }
      throw GeneralException(
          CommonResponse.fromJson(responseMap).anyErrorMessage);
    }

    return verificationResponse;
  }

  Future<bool> postVerificationCode(String email) async {
    final String url = "${config.apiBaseUrl}$endpoint/send-verification-code";
    final body = jsonEncode({'email': email});
    final response = await client.post(Uri.parse(url),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: body);

    Map<String, dynamic> responseMap = jsonDecode(response.body);

    final verificationCodeResponse = CommonResponse.fromJson(responseMap);

    if (response.statusCode != 200) {
      if (response.statusCode == 404 || response.statusCode == 400) {
        throw GeneralException(verificationCodeResponse.statusText.toString());
      }
      throw GeneralException(
          CommonResponse.fromJson(responseMap).anyErrorMessage);
    }
    return true;
  }

  Future<CommonResponse> updatePassword(String newPassword) async {
    final String url = "${config.apiBaseUrl}$endpoint/update-password";

    print(url);

    final token = await storage.read(key: 'tempToken');

    final body = jsonEncode({'newPassword': newPassword});
    final response = await client.put(Uri.parse(url),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: body);

    print(response.body);

    final responseMap = jsonDecode(response.body);

    final updateResponse = CommonResponse.fromJson(responseMap);

    if (response.statusCode != 200) {
      if (response.statusCode == 400) {
        throw GeneralException(updateResponse.statusText.toString());
      }
      throw GeneralException(
          CommonResponse.fromJson(responseMap).anyErrorMessage);
    }

    return updateResponse;
  }

  Future<RegistrationResponse> getMe() async {
    final String url = "${config.apiBaseUrl}$endpoint/me";

    final token = await storage.read(key: 'token');

    final response = await client.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    final responseMap = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw const GeneralException(
          "Impossible de récupérer vos informations pour le moment, Réessayer plus tard");
    }

    final getMeResponse = RegistrationResponse.fromJson(responseMap);
    return getMeResponse;
  }

  Future<RegistrationResponse> updateMe(User user) async {
    final String url = "${config.apiBaseUrl}$endpoint/update-me";

    final token = await storage.read(key: 'token');

    print(url);

    final body = jsonEncode({
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'phone': user.phone
    });
    final response = await client.put(Uri.parse(url),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: body);

    print(response.body);

    final responseMap = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw const GeneralException(
          "Impossible de modifier vos informations pour le moment, Réessayer plus tard");
    }

    final updateMeResponse = RegistrationResponse.fromJson(responseMap);
    return updateMeResponse;
  }

  Future<bool> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final String url = "${config.apiBaseUrl}$endpoint/delete-account/$userId";

    final token = await storage.read(key: 'token');

    print(url);

    final response = await client.delete(
      Uri.parse(url),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw const GeneralException(
          "Impossible de supprimer votre compte pour le moment, Réessayer plus tard");
    }

    return true;
  }
}
