import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class RouterPage extends StatelessWidget {
  const RouterPage({super.key, required this.navigatorKey});
  final GlobalKey<NavigatorState> navigatorKey;

  PageRoute generateRoute(RouteSettings settings);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: "/",
      key: navigatorKey,
      onGenerateRoute: generateRoute,
    );
  }
}
