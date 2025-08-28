import 'dart:io';

import 'package:ediocese_app/http_overrides.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/app_config.dart';
import 'package:ediocese_app/ioc_locator.dart';
import 'package:ediocese_app/locator.dart';
import 'package:ediocese_app/screens/root/root_screen.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:package_info_plus/package_info_plus.dart';

const String defaultLocale = 'FR';
late final IocContainer container;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  HttpOverrides.global = MyHttpOverrides();
  var configuredApp = AppConfig(
    appName: 'E-Diocese',
    apiBaseUrl: 'http://10.0.2.2:8080/api',
    //'https://ediocese.tech/api',
    //http://191.101.15.174/api
    flavorName: 'development',
    lockInSeconds: 60,
    version: packageInfo.version,
    currency: 'XOF',
    masterKey: 140656,
    token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4NDYxNTgxOGEyNmFmZGY2NjExZGJjYyIsImlhdCI6MTc0OTQ3NzA0NCwiZXhwIjoxNzUwMDgxODQ0fQ.m4I3SOiH2Kob9eUtANVeu2e2CUzih7NRhgHFgX4pRz8",
    child: const AppMain(),
  );
  setupLocator(configuredApp);
  IocContainerBuilder builder = iocLocator(configuredApp);
  container = builder.toContainer();

  runApp(configuredApp);
}

class AppMain extends StatelessWidget {
  const AppMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const RootScreen();
  }
}
