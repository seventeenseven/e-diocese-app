import 'package:flutter/material.dart';
import 'package:ediocese_app/screens/dashboard/news_tab/news_screen.dart';

import '../router_page.dart';

class NewsRouter extends RouterPage {
  NewsRouter({super.key})
      : super(navigatorKey: GlobalKey<NavigatorState>());

  @override
  PageRoute generateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) {
        switch (settings.name) {
          case '/':
            return const NewsScreen();
          default:
            return const NewsScreen();
        }
      },
    );
  }
}
