// ignore_for_file: import_of_legacy_library_into_null_safe, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ediocese_app/components/custom_button.dart';
import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/locator.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/responses/registration_response/registration_response.dart';
import 'package:ediocese_app/screens/onboarding/registration_screen.dart';
import 'package:ediocese_app/services/authentication_api.dart';
import 'package:ediocese_app/services/google_signin_api.dart';
import 'package:ediocese_app/services/navigation_service.dart';
import 'package:ediocese_app/services/safe_secure_storage.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:ediocese_app/constants/img_urls.dart';
import 'package:ediocese_app/screens/dashboard/bottom_tab_navigator.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  final NavigationService _navigationService = locator<NavigationService>();

  AuthenticationApi authenticationApi = container<AuthenticationApi>();
  final storage = container<SafeSecureStorage>();

  String phoneNumber = "";
  String phoneIsoCode = "";
  String country = "";
  bool hasError = true;

  bool loader = false;

  void onPhoneNumberChange(
      String number, bool isInvalid, String isoCode, String countryCode) {
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
      country = countryCode;
      hasError = isInvalid;
    });
  }

  void _showDialog(String errorMessage) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(contextProp: context, messageProp: errorMessage);
      },
    );
  }

  _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      behavior: SnackBarBehavior.floating,
    ));
  }
  void _submitPhoneNumber() async {
    print('=== AVANT LOGIN ===');
    try {
      setState(() => loader = true);

      // Appel DIRECT sans vérification
      final response = await authenticationApi.login(
          phoneNumber,
          "888888" // Code fixe pour bypass
      );
      print('=== APRES LOGIN ===');
      print('Token reçu: ${response.token}');
      print('Token stocké: ${await storage.read(key: 'token')}');
      if (response.success) {
        await setUserPreferences(response);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const BottomTabNavigator()),
                (route) => false
        );
      }
    } catch (e) {
      _showDialog("Erreur: ${e.toString()}");
    } finally {
      setState(() => loader = false);
    }
  }
  // void onPhoneEnter(BuildContext context) async {
  //   FocusScope.of(context).unfocus();
  //   setState(() {
  //     loader = true;
  //   });
  //
  //   try {
  //     final res = await authenticationApi.postVerificationCode(
  //         phoneNumber: phoneNumber);
  //     setState(() {
  //       loader = false;
  //     });
  //     if (res == true) {
  //       await Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => const VerificationScreen(),
  //               settings: RouteSettings(
  //                   arguments: LoginScreenArguments(phoneNumber))));
  //     }
  //   } catch (error) {
  //     setState(() {
  //       loader = false;
  //     });
  //     _showDialog(error.toString());
  //   }
  // }

  Future setUserPreferences(RegistrationResponse loginResponse) async {
    final prefs = await SharedPreferences.getInstance();

    await storage.write(key: "token", value: loginResponse.token.toString());
    await prefs.setString("user", jsonEncode(loginResponse.user));
    await prefs.setString("userId", loginResponse.user.id.toString());
    await prefs.setString("firstName", loginResponse.user.firstName);
    await prefs.setString("lastName", loginResponse.user.lastName);
    await prefs.setString("email", loginResponse.user.email);
    await prefs.setString("phone", loginResponse.user.phone);
    await prefs.setString("sessionId", loginResponse.sessionId.toString());
  }

  Future loginWithGoogle() async {
    try {
      final user = await GoogleSignInApi.login();
      final prefs = await SharedPreferences.getInstance();
      if (user == null) {
        _showMessage("La connexion avec google a échouée");
      } else {
        setState(() {
          loader = true;
        });

        print("user ${user.email}");
        final res = await authenticationApi.loginGoogle(user.email,
            firstName: user.displayName!.split(' ').first,
            lastName: user.displayName!.split(' ').last);
        if (res.success == true) {
          await setUserPreferences(res);
          await prefs.setBool('googleLogged', true);
          setState(() {
            loader = false;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomTabNavigator(),
              ));
        }
      }
    } catch (e) {
      setState(() {
        loader = false;
      });
      _showDialog(e.toString());
    }
  }

  Future loginWithFacebook() async {
    try {
      FacebookAuth.instance
          .login(permissions: ['public_profile', 'email']).then((value) => {
                FacebookAuth.instance.getUserData().then((userData) async {
                  final prefs = await SharedPreferences.getInstance();
                  setState(() {
                    loader = true;
                  });
                  print("user ${userData['email']}");
                  final res = await authenticationApi.loginGoogle(
                      userData['email'],
                      firstName:
                          (userData['name'] as String).split(' ').first,
                      lastName: (userData['name'] as String).split(' ').last);
                  if (res.success == true) {
                    await setUserPreferences(res);
                    await prefs.setBool('facebookLogged', true);
                    setState(() {
                      loader = false;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BottomTabNavigator(),
                        ));
                  }
                                })
              });
    } catch (e) {
      setState(() {
        loader = false;
      });
      _showDialog(e.toString());
    }
  }
  bool _isValidPhone(String phone) {
    return phone.length >= 8; // Exemple de validation basique
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
        titleProp: '',
        context: context,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF9F5F0), // Beige clair
              Color(0xFFF0EAE4), // Beige légèrement plus foncé
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 40),
                Image.asset(
                  edioBleu,
                  height: 100.0,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),
                const Text(
                  "Bienvenue",
                  style: TextStyle(
                    color: Color(0xFF5D4037), // Brun chaud
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Connectez-vous à votre compte",
                  style: TextStyle(
                    color: Color(0xFF7D6E63), // Taupe
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IntlPhoneField(
                    initialCountryCode: 'CI',
                    onChanged: (phone) {
                      setState(() {
                        phoneNumber = phone.completeNumber;
                        country = phone.countryISOCode.toUpperCase();
                        hasError = !_isValidPhone(phone.completeNumber);
                      });
                    },
                    style: const TextStyle(
                      color: Color(0xFF5D4037), // Brun chaud
                    ),
                    decoration: InputDecoration(
                      labelText: 'Téléphone',
                      labelStyle: const TextStyle(
                        color: Color(0xFFA1887F), // Taupe clair
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Pas de compte ? ",
                      style: TextStyle(color: Color(0xFF7D6E63)),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegistrationScreen(),
                            ));
                      },
                      child: const Text(
                        "Inscrivez-vous",
                        style: TextStyle(
                          color: Color(0xFF8D6E63), // Taupe rosé
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: CustomButton(
                    contextProp: context,
                    onPressedProp: () {
                      _submitPhoneNumber();
                    },
                    textProp: "Continuer",
                    disabledProp: hasError,
                    loader: loader,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
