// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/locator.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/screens/onboarding/login_screen.dart';
import 'package:ediocese_app/services/navigation_service.dart';
import 'package:ediocese_app/services/safe_secure_storage.dart';
import 'package:ediocese_app/services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/components/custom_button.dart';
import 'package:ediocese_app/components/inputs/input_field.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/constants/img_urls.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ChangePasswordScreenScreenState createState() =>
      ChangePasswordScreenScreenState();
}

class ChangePasswordScreenScreenState extends State<ChangePasswordScreen> {
  @override
  void initState() {
    super.initState();
  }

  final NavigationService _navigationService = locator<NavigationService>();

  final SafeSecureStorage storage = container<SafeSecureStorage>();

  final _formKey = GlobalKey<FormState>();
  bool loader = false;

  String newPassword = "";
  String confirmNewPassword = "";

  UserApi userApi = container<UserApi>();

  void onChangedNewPassword(String text) {
    setState(() {
      newPassword = text;
    });
  }

  void onChangedConfirmNewPassword(String text) {
    setState(() {
      confirmNewPassword = text;
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

  void _change() async {
    setState(() {
      loader = true;
    });
    try {
      final res = await userApi.updatePassword(newPassword);
      if (res.success == true) {
        await storage.deleteAll();
        _showMessage(
            "Votre mot de passe a bien été changer. Vous pouvez vous connecter maintenant");
        await _navigationService.popAllAndNavigateTo(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    } catch (error) {
      setState(() {
        loader = false;
      });
      _showDialog(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
        titleProp: '',
        context: context,
      ),
      body: SafeArea(
          child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 17.0, right: 17.0, top: 20.0),
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          lockIcon,
                          fit: BoxFit.contain,
                          height: 130.0,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Réinitialisation du mot de passe",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0,
                                color: colorGreyBlack),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                InputField(
                                    initialValue: newPassword,
                                    inputType: TextInputType.text,
                                    labelText: "",
                                    label: "Nouveau mot de passe",
                                    obscureText: true,
                                    labelColor: colorGreyBlack,
                                    borderColor: colorGreyBlack,
                                    showErrorMessage: true,
                                    suffixIcon: Image.asset(tick),
                                    onChanged: onChangedNewPassword),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                InputField(
                                    initialValue: confirmNewPassword,
                                    inputType: TextInputType.text,
                                    labelText: "",
                                    label:
                                        "Confirmation du nouveau mot de passe",
                                    obscureText: true,
                                    labelColor: colorGreyBlack,
                                    borderColor: colorGreyBlack,
                                    showErrorMessage: true,
                                    suffixIcon: Image.asset(tick),
                                    onChanged: onChangedConfirmNewPassword),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                CustomButton(
                                    contextProp: context,
                                    loader: loader,
                                    onPressedProp: () {
                                      if (_formKey.currentState!.validate()) {
                                        _change();
                                      }
                                    },
                                    textProp: "Envoyer"),
                                const SizedBox(
                                  height: 30.0,
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      )),
    );
  }
}
