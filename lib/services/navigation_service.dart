import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  BuildContext get context => _navigationKey.currentState!.overlay!.context;

  void pop() {
    return _navigationKey.currentState!.pop();
  }

  Future<dynamic> navigateTo(Route route) {
    return _navigationKey.currentState!.push(route);
  }

  Future<dynamic> popAllAndNavigateTo(Route route) {
    return _navigationKey.currentState!
        .pushAndRemoveUntil(route, (route) => false);
  }
}
