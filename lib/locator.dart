import 'package:ediocese_app/app_config.dart';
import 'package:ediocese_app/services/navigation_service.dart';
import 'package:ediocese_app/services/safe_secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

void setupLocator(AppConfig config) {
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton(() => SafeSecureStorage(const FlutterSecureStorage()));
}
