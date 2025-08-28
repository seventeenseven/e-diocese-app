import 'package:flutter/material.dart';
import 'package:ediocese_app/screens/dashboard/home_tab/home_screen.dart';

import '../router_page.dart';

class HomeRouter extends RouterPage {
  HomeRouter({super.key})
      : super(navigatorKey: GlobalKey<NavigatorState>());

  @override
  PageRoute generateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) {
        switch (settings.name) {
          case '/':
            return const HomeScreen();
          default:
            return const HomeScreen();
        }
      },
    );
  }
}
