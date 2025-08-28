// ignore_for_file: import_of_legacy_library_into_null_safe, depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:ediocese_app/exceptions/general_exception.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/responses/get_activite_favoris_response/get_activite_favoris_response.dart';
import 'package:ediocese_app/models/responses/get_church_favoris_response/get_church_favoris_response.dart';
import 'package:ediocese_app/models/responses/get_news_favoris_response/get_news_favoris_response.dart';
import 'package:ediocese_app/models/responses/get_videos_favoris_response/get_videos_favoris_response.dart';
import 'package:ediocese_app/services/safe_secure_storage.dart';
import 'package:ediocese_app/app_config.dart';
import 'package:http/http.dart' as http;

class FavorisApi {
  final AppConfig config;
  final http.Client client;
  final String endpoint = '';
  final storage = container<SafeSecureStorage>();

  FavorisApi({
    required this.config,
    required this.client // Obligatoire
  });

  Future<GetChurchFavorisResponse> getChurchFavoris() async {
    const churchFavorisEndpoint = "/church/favoris/get";
    final String url = "${config.apiBaseUrl}$churchFavorisEndpoint";

    final token = await storage.read(key: 'token');
    final response = await client.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    print(response.body);

    final responseMap = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw const GeneralException(
          "Impossible de récupérer la liste des favoris pour le moment");
    }

    final getChurchFavorisResponse =
        GetChurchFavorisResponse.fromJson(responseMap);
    return getChurchFavorisResponse;
  }

  Future<GetActiviteFavorisResponse> getActiviteFavoris() async {
    const activiteFavorisEndpoint = "/church/activite-favoris/get";
    final String url = "${config.apiBaseUrl}$activiteFavorisEndpoint";

    final token = await storage.read(key: 'token');
    final response = await client.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    print(response.body);

    final responseMap = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw const GeneralException(
          "Impossible de récupérer la liste des favoris pour le moment");
    }

    final activiteFavorisResponse =
        GetActiviteFavorisResponse.fromJson(responseMap);
    return activiteFavorisResponse;
  }

  Future<GetNewsFavorisResponse> getNewsFavoris() async {
    const newsFavorisEndpoint = "/church/news-favoris/get";
    final String url = "${config.apiBaseUrl}$newsFavorisEndpoint";

    final token = await storage.read(key: 'token');
    final response = await client.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    print(response.body);

    final responseMap = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw const GeneralException(
          "Impossible de récupérer la liste des favoris pour le moment");
    }

    final getNewsFavorisResponse = GetNewsFavorisResponse.fromJson(responseMap);
    return getNewsFavorisResponse;
  }

  Future<GetVideosFavorisResponse> getVideosFavoris() async {
    const videosFavorisEndpoint = "/church/videos-favoris/get";
    final String url = "${config.apiBaseUrl}$videosFavorisEndpoint";

    final token = await storage.read(key: 'token');
    final response = await client.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    print(response.body);

    final responseMap = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw const GeneralException(
          "Impossible de récupérer la liste des favoris pour le moment");
    }

    final getVideosFavorisResponse =
        GetVideosFavorisResponse.fromJson(responseMap);
    return getVideosFavorisResponse;
  }
}
