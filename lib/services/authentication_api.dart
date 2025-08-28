// ignore_for_file: import_of_legacy_library_into_null_safe, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:ediocese_app/components/utils/phone-utils.dart';
import 'package:ediocese_app/exceptions/general_exception.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/responses/common-response/common_response.dart';
import 'package:ediocese_app/models/responses/registration_response/registration_response.dart';
import 'package:ediocese_app/services/google_signin_api.dart';
import 'package:ediocese_app/services/safe_secure_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:ediocese_app/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationApi {
  final AppConfig config;
  final http.Client client;
  final String endpoint = '/auth';
  final SafeSecureStorage storage;

  AuthenticationApi({
    required this.config,
    required this.client,required this.storage});

  Future<bool> postVerificationCode({required String phoneNumber}) async {
    final String url = '${config.apiBaseUrl}$endpoint/send-verification-code';
    final body = jsonEncode({
      'phone': PhoneUtils.getNormalizedNumber(phoneNumber),
    });
    final response = await client.post(Uri.parse(url),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: body);

    Map<String, dynamic> responseMap = jsonDecode(response.body);

    if (response.statusCode != 200) {
      if (response.statusCode == 404) {
        throw const GeneralException("Ce numéro n'est associé à aucun compte");
      }
      throw GeneralException(
          CommonResponse.fromJson(responseMap).anyErrorMessage);
    }
    return true;
  }
  Future<RegistrationResponse> login2(String phone, String code) async {
    final String url = "${config.apiBaseUrl}$endpoint/login";

    final body = jsonEncode({'phone': phone, 'code': "888888"}); // Toujours 888888

    final response = await client.post(
        Uri.parse("$url/login"),
        headers: {"Content-Type": "application/json"},
        body: body
    );

    return RegistrationResponse.fromJson(jsonDecode(response.body));
  }

  Future<RegistrationResponse> login(String phoneNumber, String code) async {
    final String url = "${config.apiBaseUrl}$endpoint/login";

    try{
      final body = jsonEncode(
          {'phone': PhoneUtils.getNormalizedNumber(phoneNumber), 'code': code});
      final response = await client.post(Uri.parse(url),
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: body);

      print('=== API RESPONSE ===');
      print('URL: $url');
      print('Status: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Body: ${response.body}');
      final responseMap = jsonDecode(response.body);

      if (response.statusCode != 200) {
        if (response.statusCode == 400 ||
            response.statusCode == 403 ||
            response.statusCode == 404) {
          throw const GeneralException("Code Incorrecte");
        }
        throw GeneralException(
            CommonResponse.fromJson(responseMap).anyErrorMessage);
      }

      final authenticationResponse = RegistrationResponse.fromJson(responseMap);
      return authenticationResponse;
    } catch (e) {
      print('!!! ERREUR CRITIQUE DANS login() !!!');
      print('Error: $e');
      rethrow;
    }
  }

  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('sessionId');

    final String url = "${config.apiBaseUrl}$endpoint/logout/$sessionId";

    final token = await storage.read(key: 'token');

    final response = await client.delete(
      Uri.parse(url),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    //print(response.body);

    final responseMap = jsonDecode(response.body);

    final logoutResponse = CommonResponse.fromJson(responseMap);

    if (response.statusCode != 200) {
      if (response.statusCode == 403 || response.statusCode == 404) {
        throw GeneralException(logoutResponse.statusText.toString());
      }
      throw GeneralException(
          CommonResponse.fromJson(responseMap).anyErrorMessage);
    }

    return true;
  }

  Future<RegistrationResponse> loginGoogle(String email,
      {String? firstName, String? lastName}) async {
    final String url = "${config.apiBaseUrl}/users/auth/google";

    final body = jsonEncode(
        {'email': email, 'firstName': firstName, 'lastName': lastName});
    final response = await client.post(Uri.parse(url),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${config.masterKey}',
        },
        body: body);

    final responseMap = jsonDecode(response.body);

    if (response.statusCode != 200) {
      if (response.statusCode == 400 ||
          response.statusCode == 403 ||
          response.statusCode == 404) {
        if (response.statusCode == 404) {
          await GoogleSignInApi.logout();
          await FacebookAuth.instance.logOut();
        }
        throw const GeneralException("Utilisateur introuvable");
      }
      throw GeneralException(
          CommonResponse.fromJson(responseMap).anyErrorMessage);
    }

    final authenticationResponse = RegistrationResponse.fromJson(responseMap);

    return authenticationResponse;
  }
}
