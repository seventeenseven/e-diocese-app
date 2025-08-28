import 'package:ediocese_app/screens/dashboard/profile_tab/profile_screen.dart';
import 'package:flutter/material.dart';

import '../router_page.dart';

class ProfileRouter extends RouterPage {
  ProfileRouter({super.key})
      : super(navigatorKey: GlobalKey<NavigatorState>());

  @override
  PageRoute generateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) {
        switch (settings.name) {
          case '/':
            return const ProfileScreen();
          default:
            return const ProfileScreen();
        }
      },
    );
  }
}
