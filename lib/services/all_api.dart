// ignore_for_file: import_of_legacy_library_into_null_safe, depend_on_referenced_packages, unused_local_variable, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:ediocese_app/exceptions/general_exception.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/responses/check_transaction_status/check_transaction_status.dart';
import 'package:ediocese_app/models/responses/common-response/common_response.dart';
import 'package:ediocese_app/models/responses/get_activite_participate/get_activite_participate.dart';
import 'package:ediocese_app/models/responses/get_activite_response/get_activite_response.dart';
import 'package:ediocese_app/models/responses/get_church_response/get_church_response.dart';
import 'package:ediocese_app/models/responses/get_news_response/get_news_response.dart';
import 'package:ediocese_app/models/responses/get_only_activite_response/get_only_activite_response.dart';
import 'package:ediocese_app/models/responses/get_only_church_response/get_only_church_response.dart';
import 'package:ediocese_app/models/responses/get_only_news_response/get_only_news_response.dart';
import 'package:ediocese_app/models/responses/get_only_video_response/get_only_video_response.dart';
import 'package:ediocese_app/models/responses/get_price_response/get_price_response.dart';
import 'package:ediocese_app/models/responses/get_priere_response/get_priere_response.dart';
import 'package:ediocese_app/models/responses/get_readings_day_response/get_readings_day_response.dart';
import 'package:ediocese_app/models/responses/get_video_response/get_video_response.dart';
import 'package:ediocese_app/models/responses/transaction_response/transaction_response.dart';
import 'package:ediocese_app/models/schemas/reading_day/reading_day.dart';
import 'package:ediocese_app/services/safe_secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:ediocese_app/app_config.dart';
import 'package:http/http.dart' as http;


class AllApi {
  final AppConfig config;
  final http.Client client;
  final String endpoint = '/church/get';
  final storage = container<SafeSecureStorage>();

  AllApi({
    required this.config,
    required this.client
  });
  void _testApiCall() async {
    final token = await storage.read(key: 'token');
    print('Token utilisé: $token');

    final response = await http.get(
      Uri.parse('${config.apiBaseUrl}/church/get'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );
    print('Réponse brute: ${response.body}');
  }

  Future<GetChurchResponse> getChurch({bool order = false, limit = ''}) async {
    String url = "";
    if (order == true) {
      url = "${config.apiBaseUrl}$endpoint?order=$order&limit=$limit";
    } else {
      url = "${config.apiBaseUrl}$endpoint?limit=$limit";
    }

    final token = await storage.read(key: 'token');
    final response = await client.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${config.masterKey}',
      },
    );
    debugPrint("Request to: $url");
    print(response.body);

    final responseMap = jsonDecode(response.body);
    print(response.body);
    print('=== API RESPONSE ===');
    print('URL: $url');
    print('Status: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Body: ${response.body}');

    if (response.statusCode != 200) {
      throw const GeneralException(
          "Impossible de récupérer la liste des églises pour le moment");
    }

    final getChurchResponse = GetChurchResponse.fromJson(responseMap);
    return getChurchResponse;
  }

  Future<GetChurchResponse> getChurchNear(
      {bool order = false,
      limit = '',
      required double userLongitude,
      required double userLatitude}) async {
    String url = "";
    const churchNearEndpoint = "/church/near";
    if (order == true) {
      url = "${config.apiBaseUrl}$churchNearEndpoint?order=$order&limit=$limit";
    } else {
      url = "${config.apiBaseUrl}$churchNearEndpoint?limit=$limit";
    }

    final body = jsonEncode({
      'userLongitude': userLongitude ?? 0.00,
      'userLatitude': userLatitude ?? 0.00
    });
    final response = await client.post(Uri.parse(url),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${config.masterKey}',
        },
        body: body);

    final responseMap = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw const GeneralException(
          "Impossible de récupérer la liste des églises à proximité pour le moment");
    }

    final getChurchResponse = GetChurchResponse.fromJson(responseMap);
    return getChurchResponse;
  }

  Future<GetOnlyChurchResponse> getOnlyChurch(String churchId) async {
    final onlyChurchEndpoint = '/church/$churchId';
    final url = "${config.apiBaseUrl}$onlyChurchEndpoint";

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
          "Impossible de récupérer l'église pour le moment");
    }

    final getOnlyChurchResponse = GetOnlyChurchResponse.fromJson(responseMap);
    return getOnlyChurchResponse;
  }

  Future<GetOnlyActiviteResponse> getOnlyActivite(String activiteId) async {
    final onlyActiviteEndpoint = '/church/activite/$activiteId';
    final url = "${config.apiBaseUrl}$onlyActiviteEndpoint";

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
          "Impossible de récupérer l'activité pour le moment");
    }

    final getOnlyActiviteResponse =
        GetOnlyActiviteResponse.fromJson(responseMap);
    return getOnlyActiviteResponse;
  }

  Future<GetOnlyNewsResponse> getOnlyNews(String newsId) async {
    final onlyNewsEndpoint = '/church/news/$newsId';
    final url = "${config.apiBaseUrl}$onlyNewsEndpoint";

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
          "Impossible de récupérer l'actualité pour le moment");
    }

    final getOnlyNewsResponse = GetOnlyNewsResponse.fromJson(responseMap);
    return getOnlyNewsResponse;
  }

  Future<GetOnlyVideoResponse> getOnlyVideo(String videoId) async {
    final onlyVideoEndpoint = '/church/video/$videoId';
    final url = "${config.apiBaseUrl}$onlyVideoEndpoint";

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
          "Impossible de récupérer la vidéo pour le moment");
    }

    final getOnlyVideoResponse = GetOnlyVideoResponse.fromJson(responseMap);
    return getOnlyVideoResponse;
  }

  Future<GetActivitesResponse> getActivites(
      {bool order = false, limit = ''}) async {
    const activitesEndpoint = "/church/activites/get";
    String url = "";
    if (order == true) {
      url = "${config.apiBaseUrl}$activitesEndpoint?order=$order&limit=$limit";
    } else {
      url = "${config.apiBaseUrl}$activitesEndpoint?limit=$limit";
    }

    final token = await storage.read(key: 'token');
    print('token $token');
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
          "Impossible de récupérer la liste des activités pour le moment");
    }

    final getActivitesResponse = GetActivitesResponse.fromJson(responseMap);
    return getActivitesResponse;
  }

  Future<GetNewsResponse> getNews({limit = '', bool order = false}) async {
    const newsEndpoint = "/church/news/get";
    String url = "";

    if (order == true) {
      url = "${config.apiBaseUrl}$newsEndpoint?order=$order&limit=$limit";
    } else {
      url = "${config.apiBaseUrl}$newsEndpoint?limit=$limit";
    }

    /**
     * String url = "";
    if (order == true) {
      url = "${config.apiBaseUrl}$activitesEndpoint?order=$order&limit=$limit";
    } else {
      url = "${config.apiBaseUrl}$activitesEndpoint?limit=$limit";
    }
     */

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
          "Impossible de récupérer la liste des actualités pour le moment");
    }

    final getNewsResponse = GetNewsResponse.fromJson(responseMap);
    return getNewsResponse;
  }

  Future<GetVideoResponse> getVideos({limit = ''}) async {
    final videosEndpoint = "/church/videos/get?limit=$limit";
    final String url = "${config.apiBaseUrl}$videosEndpoint";
    print("ICI");
    final token = await storage.read(key: 'token');
    final response = await client.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    print("Vidéos ${response.body}");

    final responseMap = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw const GeneralException(
          "Impossible de récupérer la liste des vidéos pour le moment");
    }

    final getVideosResponse = GetVideoResponse.fromJson(responseMap);
    return getVideosResponse;
  }

  Future<GetVideoResponse> getVideosSimilar({required String videoId}) async {
    final videosSimilarEndpoint = "/church/videos-similar/$videoId";
    final String url = "${config.apiBaseUrl}$videosSimilarEndpoint";

    final token = await storage.read(key: 'token');
    final response = await client.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${config.masterKey}',
      },
    );

    print("Vidéos ${response.body}");

    final responseMap = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw const GeneralException(
          "Impossible de récupérer la liste des vidéos pour le moment");
    }

    final getVideosResponse = GetVideoResponse.fromJson(responseMap);
    return getVideosResponse;
  }

  Future<CommonResponse> addToFavoris(String churchId) async {
    const String favorisEndpoint = "/church/add-to-favoris";
    final String url = "${config.apiBaseUrl}$favorisEndpoint";

    final token = await storage.read(key: 'token');
    final body = jsonEncode({'church': churchId});
    final response = await client.post(Uri.parse(url),
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
          "Impossible d'ajouter au favoris pour le moment");
    }

    final favorisResponse = CommonResponse.fromJson(responseMap);
    return favorisResponse;
  }

  Future<CommonResponse> addToNewsFavoris(String newsId) async {
    const String favorisEndpoint = "/church/add-news-favoris";
    final String url = "${config.apiBaseUrl}$favorisEndpoint";

    final token = await storage.read(key: 'token');
    final body = jsonEncode({'news': newsId});
    final response = await client.post(Uri.parse(url),
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
          "Impossible d'ajouter au favoris pour le moment");
    }

    final favorisResponse = CommonResponse.fromJson(responseMap);
    return favorisResponse;
  }

  Future<TransactionResponse> addPrayer(
      {required String sujet,
      required String temps,
      required String periode,
      required String description,
      required String church}) async {
    const String addPrayerEndpoint = "/church/add-prayer";
    final String url = "${config.apiBaseUrl}$addPrayerEndpoint";

    final token = await storage.read(key: 'token');
    final body = jsonEncode({
      'sujet': sujet,
      'temps': temps,
      'periode': periode,
      'description': description,
      'church': church
      // 'currency': config.currency
    });

    final response = await client.post(Uri.parse(url),
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
          "Impossible d'envoyer une intention de prière pour le moment");
    }

    final addPrayerResponse = TransactionResponse.fromJson(responseMap);
    return addPrayerResponse;
  }

  Future<GetPriereResponse> getPrieres() async {
    const prieresEndpoint = "/church/prieres/get";
    final String url = "${config.apiBaseUrl}$prieresEndpoint";

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
          "Impossible de récupérer la liste de vos intentions de prière pour le moment");
    }

    final getPrieresResponse = GetPriereResponse.fromJson(responseMap);
    return getPrieresResponse;
  }

  Future<CommonResponse> addToActiviteFavoris(String actId) async {
    const String favorisEndpoint = "/church/add-activite-favoris";
    final String url = "${config.apiBaseUrl}$favorisEndpoint";

    final token = await storage.read(key: 'token');
    final body = jsonEncode({'activite': actId});
    final response = await client.post(Uri.parse(url),
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
          "Impossible d'ajouter au favoris pour le moment");
    }

    final favorisResponse = CommonResponse.fromJson(responseMap);
    return favorisResponse;
  }

  Future<CommonResponse> addParticipateActivite(String actId) async {
    const String activiteEndpoint = "/church/add-participate-activite";
    final String url = "${config.apiBaseUrl}$activiteEndpoint";

    final token = await storage.read(key: 'token');
    final body = jsonEncode({'activite': actId});
    final response = await client.post(Uri.parse(url),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: body);

    print(response.body);

    final responseMap = jsonDecode(response.body);

    if (response.statusCode != 200) {
      // if (response.statusCode == 400) {
      //   throw const GeneralException("Je participe déjà");
      // }
      throw const GeneralException(
          "Impossible de participer à cette activité pour le moment");
    }

    final activiteResponse = CommonResponse.fromJson(responseMap);
    return activiteResponse;
  }

  Future<CommonResponse> addVideoToFavoris(String video) async {
    const String favorisEndpoint = "/church/add-video-favoris";
    final String url = "${config.apiBaseUrl}$favorisEndpoint";

    final token = await storage.read(key: 'token');
    final body = jsonEncode({'video': video});
    final response = await client.post(Uri.parse(url),
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
          "Impossible d'ajouter au favoris pour le moment");
    }

    final favorisResponse = CommonResponse.fromJson(responseMap);
    return favorisResponse;
  }

  Future<CheckTransactionStatus> checkTransaction(String transactionId) async {
    const String checkEndpoint = "/church/transaction/check";
    final String url = "${config.apiBaseUrl}$checkEndpoint";

    final token = await storage.read(key: 'token');
    final body = jsonEncode({'transactionId': transactionId});
    final response = await client.post(Uri.parse(url),
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
          "Une erreur s'est produite lors de la vérification de la transaction");
    }

    final transactionResponse = CheckTransactionStatus.fromJson(responseMap);
    return transactionResponse;
  }

  Future<GetChurchResponse> getSimilarChurch({required String churchId}) async {
    final similarChurchEndpoint = "/church/similar/$churchId";
    final url = "${config.apiBaseUrl}$similarChurchEndpoint";

    final token = await storage.read(key: 'token');
    final response = await client.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${config.masterKey}',
      },
    );

    print(response.body);

    final responseMap = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw const GeneralException(
          "Impossible de récupérer la liste des églises pour le moment");
    }

    final getChurchResponse = GetChurchResponse.fromJson(responseMap);
    return getChurchResponse;
  }

  Future<GetActivitesResponse> getSimilarActivites(
      {required String activiteId}) async {
    final activitesSimilarEndpoint = "/church/activites-similar/$activiteId";
    final url = "${config.apiBaseUrl}$activitesSimilarEndpoint";

    final token = await storage.read(key: 'token');
    final response = await client.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${config.masterKey}',
      },
    );

    print(response.body);

    final responseMap = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw const GeneralException(
          "Impossible de récupérer la liste des activités pour le moment");
    }

    final getActivitesResponse = GetActivitesResponse.fromJson(responseMap);
    return getActivitesResponse;
  }

  Future<GetNewsResponse> getNewsSimilar({required String newsId}) async {
    final newsSimilarEndpoint = "/church/news-similar/$newsId";
    final String url = "${config.apiBaseUrl}$newsSimilarEndpoint";

    final response = await client.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${config.masterKey}',
      },
    );

    print(response.body);

    final responseMap = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw const GeneralException(
          "Impossible de récupérer la liste des actualités pour le moment");
    }

    final getNewsResponse = GetNewsResponse.fromJson(responseMap);
    return getNewsResponse;
  }

  Future<GetPriceResponse> getPrices() async {
    const priceEndpoint = "/church/donation/price";
    final String url = "${config.apiBaseUrl}$priceEndpoint";

    final response = await client.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${config.masterKey}',
      },
    );

    print(response.body);

    final responseMap = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw const GeneralException(
          "Impossible de récupérer la liste des prix pour le moment");
    }

    final getPriceResponse = GetPriceResponse.fromJson(responseMap);
    return getPriceResponse;
  }

  Future<TransactionResponse> sendDonation(int amount, String church) async {
    const String addDonationEndpoint = "/church/donation/send";
    final String url = "${config.apiBaseUrl}$addDonationEndpoint";

    final token = await storage.read(key: 'token');
    final body = jsonEncode({'amount': amount, 'church': church});

    final response = await client.post(Uri.parse(url),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: body);

    print(response.body);

    final responseMap = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw const GeneralException("Impossible de faire un don pour le moment");
    }

    final sendDonationResponse = TransactionResponse.fromJson(responseMap);
    return sendDonationResponse;
  }

  Future<GetActiviteParticipate> actitivitiesParticipate() async {
    const activitiesParticipateEndpoint = "/church/participate/activities";
    final String url = "${config.apiBaseUrl}$activitiesParticipateEndpoint";

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
          "Impossible de récupérer la liste des activités pour le moment");
    }

    final getActiviteParticipate = GetActiviteParticipate.fromJson(responseMap);
    return getActiviteParticipate;
  }

  Future<GetReadingsDayResponse> getReadingsDay() async {
    const getReadingsDayEndpoint = "/church/reading-day/get";
    final String url = "${config.apiBaseUrl}$getReadingsDayEndpoint";
    print(url);

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
          "Impossible de récupérer la liste des lectures pour le moment");
    }

    final getReadingsDayResponse = GetReadingsDayResponse.fromJson(responseMap);
    return getReadingsDayResponse;
  }

  Future<ReadingDay> getReadingDay(String id) async {
    final getReadingsDayEndpoint = "/church/reading-day/$id";
    final String url = "${config.apiBaseUrl}$getReadingsDayEndpoint";

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
          "Impossible de récupérer la lecture pour le moment");
    }

    final readingDay = ReadingDay.fromJson(responseMap);
    return readingDay;
  }
}
