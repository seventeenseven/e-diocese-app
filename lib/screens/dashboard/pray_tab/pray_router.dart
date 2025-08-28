import 'package:ediocese_app/screens/dashboard/pray_tab/pray_screen.dart';
import 'package:flutter/material.dart';

import '../router_page.dart';

class PrayRouter extends RouterPage {
  PrayRouter({super.key})
      : super(navigatorKey: GlobalKey<NavigatorState>());

  @override
  PageRoute generateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) {
        switch (settings.name) {
          case '/':
            return const PrayScreen();
          default:
            return const PrayScreen();
        }
      },
    );
  }
}
