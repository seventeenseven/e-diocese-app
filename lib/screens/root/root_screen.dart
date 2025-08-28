// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/screens/onboarding/boot_sceen.dart';
import 'package:ediocese_app/services/safe_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/app_config.dart';
import 'package:ediocese_app/locator.dart';
import 'package:ediocese_app/screens/dashboard/bottom_tab_navigator.dart';
import 'package:ediocese_app/services/navigation_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  RootScreenState createState() => RootScreenState();
}

class RootScreenState extends State<RootScreen> with WidgetsBindingObserver {
  String _token = '';
  DateTime? _backgroundTime;

  final NavigationService _navigationService = locator<NavigationService>();
  final storage = container<SafeSecureStorage>();

  @override
  void initState() {
    super.initState();
    _subscribeAppLifeCycle();
    _readToken();
  }

  Future<void> _readToken() async {
    final tokenPref = await storage.read(key: 'token');
    setState(() {
      _token = tokenPref ?? "";
    });
  }

  void _subscribeAppLifeCycle() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    _unsubscribeAppLifeCycle();
  }

  void _unsubscribeAppLifeCycle() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _lockScreenIfNecessary();
    } else if (state == AppLifecycleState.paused) {
      _startLockTimer();
    }
  }

  void _lockScreenIfNecessary() async {
    if (_backgroundTime != null) {
      if (await _isLockNecessary()) {
        // unawaited(
        //     _navigationService.popAllAndNavigateTo(MaterialPageRoute<void>(
        //   builder: (BuildContext context) => PasscodeScreen(),
        // )));
      }
    }
    _backgroundTime = null;
  }

  Future<bool> _isLockNecessary() async {
    final currentTime = DateTime.now();
    final elapsedDuration = currentTime.difference(_backgroundTime!);
    final lockInSeconds = AppConfig.of(context)!.lockInSeconds;

    await _readToken();
    return elapsedDuration.inSeconds > lockInSeconds;
  }

  void _startLockTimer() {
    _backgroundTime ??= DateTime.now();
  }

  Widget _getHomeScreen() =>
      _token != null ? const BottomTabNavigator() : const BootScreen();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      supportedLocales: const [Locale('fr', 'FR')],
      navigatorKey: _navigationService.navigationKey,
      home: _getHomeScreen(),
    );
  }
}
