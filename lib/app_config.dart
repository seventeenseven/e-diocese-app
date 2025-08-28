import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  const AppConfig(
      {super.key,
      required this.appName,
      required this.apiBaseUrl,
      required this.flavorName,
      required this.lockInSeconds,
      required super.child,
      required this.version,
      required this.currency,
      required this.masterKey,
        required this.token,});

  final String appName;
  final String flavorName;
  final String apiBaseUrl;
  final int lockInSeconds;
  final String version;
  final String currency;
  final int masterKey;
  final String token;

  static AppConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
