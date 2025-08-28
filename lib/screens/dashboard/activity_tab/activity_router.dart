import 'package:ediocese_app/screens/dashboard/activity_tab/activity_screen.dart';
import 'package:flutter/material.dart';

import '../router_page.dart';

class ActivityRouter extends RouterPage {
  ActivityRouter({super.key})
      : super(navigatorKey: GlobalKey<NavigatorState>());

  @override
  PageRoute generateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) {
        switch (settings.name) {
          case '/':
            return const ActivityScreen();
          default:
            return const ActivityScreen();
        }
      },
    );
  }
}
