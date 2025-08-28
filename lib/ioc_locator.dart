// ignore_for_file: import_of_legacy_library_into_null_safe, depend_on_referenced_packages

import 'package:ediocese_app/services/all_api.dart';
import 'package:ediocese_app/services/authentication_api.dart';
import 'package:ediocese_app/services/favoris_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ediocese_app/app_config.dart';
import 'package:ediocese_app/http_client_config.dart';
import 'package:ediocese_app/services/user_api.dart';
import 'package:ediocese_app/services/safe_secure_storage.dart';
//import 'package:get/get_navigation/src/router_report.dart';
import 'package:http/http.dart' as http;
import 'package:ioc_container/ioc_container.dart';

IocContainerBuilder iocLocator(AppConfig config) {
  var uri = Uri.parse('${config.apiBaseUrl}/boutiques/images');
  var request = http.MultipartRequest("POST", uri);

  final builder = IocContainerBuilder()
    ..addSingletonService(SafeSecureStorage(const FlutterSecureStorage()))
    ..add((container) => AuthenticationApi(
        config: config,
        client: container(),
        storage: container<SafeSecureStorage>()
    ))
    ..add((container) => UserApi(
      config: config,
      client: initHttpClient()
    ))
    ..add((container) => AllApi(
      config: config,
      client: initHttpClient()
    ))
    ..add((container) => FavorisApi(
      config: config,
      client: initHttpClient()
    ));
  return builder;
  // Build the container
  //container = builder.toContainer();

  // Retrieve your services from the container
  //final authenticationApi = container<AuthenticationApi>();
  //final userApi = container<UserApi>();
  //final secureStorage = container<SafeSecureStorage>();
  //final allApi = container<AllApi>();
  //final favorisApi = container<FavorisApi>();

  /*
  Ioc().bind(
      'userApi', (ioc) => UserApi(config: config, client: initHttpClient()));
  Ioc().bind('authenticationApi',
      (ioc) => AuthenticationApi(config: config, client: initHttpClient()));
  Ioc().bind('secureStorage',
      (ioc) => SafeSecureStorage(const FlutterSecureStorage()));
  Ioc().bind(
      'allApi', (ioc) => AllApi(config: config, client: initHttpClient()));
  Ioc().bind('favorisApi',
      (ioc) => FavorisApi(config: config, client: initHttpClient()));
  */
}
