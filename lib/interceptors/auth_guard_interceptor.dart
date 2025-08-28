// ignore_for_file: avoid_print

import 'package:ediocese_app/locator.dart';
import 'package:ediocese_app/screens/onboarding/login_screen.dart';
import 'package:ediocese_app/services/navigation_service.dart';
import 'package:ediocese_app/services/safe_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';

class AuthGuardInterceptor implements InterceptorContract {
  final NavigationService _navigationService = locator<NavigationService>();
  final SafeSecureStorage _storage = locator<SafeSecureStorage>();

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    // Pas de modification nécessaire pour les requêtes
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    // Vérifie les réponses 401 Unauthorized
    if (data.statusCode == 401) {
      // Exclure l'endpoint de login pour éviter une boucle
      if (!data.url.toString().contains('login')) {
        await _logout();
      }
    }
    return data;
  }

  Future<void> _logout() async {
    try {
      // Supprimer le token
      await _storage.delete(key: 'token');

      // Navigation vers l'écran de login
      await _navigationService.navigateTo(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
    }
  }

  @override
  Future<bool> shouldInterceptRequest() async => true;

  @override
  Future<bool> shouldInterceptResponse() async => true;
}
