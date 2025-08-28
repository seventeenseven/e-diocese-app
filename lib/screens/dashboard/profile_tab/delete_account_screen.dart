// ignore_for_file: non_constant_identifier_names, import_of_legacy_library_into_null_safe

import 'package:ediocese_app/components/custom_button.dart';
import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/locator.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/screens/onboarding/login_screen.dart';
import 'package:ediocese_app/services/navigation_service.dart';
import 'package:ediocese_app/services/safe_secure_storage.dart';
import 'package:ediocese_app/services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  DeleteAccountScreenState createState() => DeleteAccountScreenState();
}

class DeleteAccountScreenState extends State<DeleteAccountScreen> {
  @override
  void initState() {
    super.initState();
  }

  final NavigationService _navigationService = locator<NavigationService>();

  UserApi userApi = container<UserApi>();
  bool deletingAccount = false;

  void _showDialog(String errorMessage) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          contextProp: context,
          messageProp: errorMessage,
        );
      },
    );
  }

  void _confirmDeletion(String errorMessage) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
            contextProp: context,
            messageProp: errorMessage,
            positiveButtonTextProp: "Oui",
            positiveButtonOnPressProp: () {
              _deleteAcount();
            },
            negativeButtonTextProp: "Non",
            showNegativeButtonProp: true,
            negativeButtonOnPressProp: () {
              Navigator.of(context).pop();
            });
      },
    );
  }

  _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      behavior: SnackBarBehavior.floating,
    ));
  }

  _logout() async {
    final prefs = await SharedPreferences.getInstance();
    final SafeSecureStorage storage = container<SafeSecureStorage>();

    await storage.deleteAll();
    await prefs.clear();

    await _navigationService.popAllAndNavigateTo(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void _deleteAcount() async {
    setState(() {
      deletingAccount = true;
    });
    try {
      final res = await userApi.deleteAccount();
      if (res == true) {
        setState(() {
          deletingAccount = false;
        });
        _showMessage(
            "Votre compte a bien été supprimer de notre plateforme ! À bientôt.");
        _logout();
      }
    } catch (error) {
      setState(() {
        deletingAccount = false;
      });
      _showDialog(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
          titleProp: "Suppression de compte",
          context: context,
          centerTitle: true,
          showBackButton: true,
          titleColor: colorBlueLittleDark),
      body: SafeArea(
          child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: RefreshIndicator(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          children: <Widget>[
                            const Icon(Icons.info),
                            const SizedBox(
                              width: 5.0,
                            ),
                            const Text(
                              "Prenez le temps de lire ses quelques lignes avant d'appuyer sur le bouton de suppression",
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            const Text(
                              "La suppression de votre compte est irréversible, et entrainera la suppression de toutes vos données de notre plateforme",
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            const Text(
                              "Êtes-vous sûr de vouloir supprimer votre compte ?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            CustomButton(
                                contextProp: context,
                                onPressedProp: () {
                                  _confirmDeletion("Supprimer votre compte ?");
                                },
                                loader: deletingAccount,
                                color: Colors.red,
                                textProp: "Supprimer mon compte")
                          ],
                        ),
                      ),
                    ),
                    onRefresh: () async {},
                  ))
                ],
              ))),
    );
  }
}
