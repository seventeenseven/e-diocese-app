// ignore_for_file: import_of_legacy_library_into_null_safe, use_build_context_synchronously

import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/schemas/registration_screen_arguments.dart';
import 'package:ediocese_app/screens/onboarding/confirm_code_screen.dart';
import 'package:ediocese_app/services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/components/custom_button.dart';
import 'package:ediocese_app/components/inputs/input_field.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/constants/img_urls.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  bool loader = false;

  String email = "";

  UserApi userApi = container<UserApi>();

  void onChangedEmail(String text) {
    setState(() {
      email = text;
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

  void _reset() async {
    setState(() {
      loader = true;
    });
    try {
      final res = await userApi.postVerificationCode(email);
      if (res == true) {
        setState(() {
          loader = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ConfirmCodeScreen(
                    fromResetPassword: true,
                  ),
              settings:
                  RouteSettings(arguments: RegistrationScreenArguments(email))),
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
      appBar: TabAppBar(titleProp: '', context: context, showBackButton: true),
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
                          height: 40.0,
                        ),
                        const Text(
                          "Mot de passe oublié ?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22.0),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        const Text(
                          "Entrez l'adresse e-mail que vous avez utilisée pour créer votre compte et nous vous enverrons par e-mail un code pour réinitialiser votre mot de passe",
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                InputField(
                                    initialValue: email,
                                    inputType: TextInputType.emailAddress,
                                    labelText: "",
                                    label: "Adresse e-email",
                                    labelColor: colorGreyBlack,
                                    borderColor: colorGreyBlack,
                                    showErrorMessage: true,
                                    suffixIcon: Image.asset(tick),
                                    onChanged: onChangedEmail),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                CustomButton(
                                    contextProp: context,
                                    loader: loader,
                                    onPressedProp: () {
                                      if (_formKey.currentState!.validate()) {
                                        _reset();
                                      }
                                    },
                                    disabledProp: email.isEmpty,
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
