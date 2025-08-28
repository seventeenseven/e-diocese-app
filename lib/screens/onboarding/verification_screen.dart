// ignore_for_file: constant_identifier_names, import_of_legacy_library_into_null_safe, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:ediocese_app/components/custom_button.dart';
import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/components/loader.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/constants/img_urls.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/responses/registration_response/registration_response.dart';
import 'package:ediocese_app/models/schemas/login_screen_arguments.dart';
import 'package:ediocese_app/screens/dashboard/bottom_tab_navigator.dart';
import 'package:ediocese_app/services/authentication_api.dart';
import 'package:ediocese_app/services/safe_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {
  static const int RESEND_CODE_DELAY_IN_SECONDS = 60;
  int counter = RESEND_CODE_DELAY_IN_SECONDS;
  final TextEditingController pincodeController = TextEditingController();
  bool loader = false;

  Timer? timer;
  bool showTimer = true;

  LoginScreenArguments arguments = LoginScreenArguments('');
  AuthenticationApi authenticationApi = container<AuthenticationApi>();

  final SafeSecureStorage storage = container<SafeSecureStorage>();

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (time) {
      setState(() {
        if (counter == 1) {
          timer!.cancel();
          showTimer = false;
          counter = RESEND_CODE_DELAY_IN_SECONDS;
        } else {
          counter = counter - 1;
        }
      });
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    pincodeController.dispose();
    super.dispose();
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

  void login(String number) async {
    setState(() {
      loader = true;
    });
    final currentCode = pincodeController.text;

    try {
      final response = await authenticationApi.login(number, currentCode);
      setState(() {
        pincodeController.text = '';
        loader = false;
      });
      if (kDebugMode) {
        print("Réponse dans verification: ${response.toJson()}");
      }
      if (response.success == true) {
        await setUserPreferences(response);
        if (!mounted) return; // Protection critique
        setState(() => loader = false);
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const BottomTabNavigator()),
        );
      }

    } catch (error) {
      setState(() {
        loader = false;
        pincodeController.text = '';
      });
      _showDialog(error.toString());
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const BottomTabNavigator()),
      );
    }
  }

  Future setUserPreferences(RegistrationResponse loginResponse) async {
    final prefs = await SharedPreferences.getInstance();

    await storage.write(
      key: "token",
      value: loginResponse.token.toString(),
    );
    await prefs.setString("user", jsonEncode(loginResponse.user));
    await prefs.setString("userId", loginResponse.user.id.toString());
    await prefs.setString("firstName", loginResponse.user.firstName);
    await prefs.setString("lastName", loginResponse.user.lastName);
    await prefs.setString("email", loginResponse.user.email);
    await prefs.setString("phone", loginResponse.user.phone);
    await prefs.setString("sessionId", loginResponse.sessionId.toString());
  }

  void resend(String number) async {
    try {
      await authenticationApi.postVerificationCode(phoneNumber: number);
    } catch (error) {
      _showDialog(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    arguments =
        ModalRoute.of(context)!.settings.arguments as LoginScreenArguments;

    return Scaffold(
      appBar: TabAppBar(
          titleProp: '', context: context, backgroundColor: Colors.white),
      body: Container(
        padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Image.asset(
              edioBleu,
              width: MediaQuery.of(context).size.width / 2.8,
              fit: BoxFit.contain,
            ),
            Container(
              padding: const EdgeInsets.only(top: 15),
              child: const Text(
                'Code de vérification OTP',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 15.0),
              child: RichText(
                key: const Key('rich-text'),
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: const TextStyle(fontSize: 15.0),
                    children: <TextSpan>[
                      const TextSpan(
                          text:
                              "Veuillez saisir le code à 6 chiffres envoyé sur le ",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w500)),
                      TextSpan(
                          text: arguments.number,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold))
                    ]),
              ),
            ),
            loader
                ? Container(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Loader(),
                  )
                : Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(top: 30.0),
                        width: MediaQuery.of(context).size.width -
                            MediaQuery.of(context).size.width / 5,
                        alignment: Alignment.center,
                        child: PinCodeTextField(
                          mainAxisAlignment: MainAxisAlignment.center,
                          appContext: context,
                          autoFocus: true,
                          length: 6,
                          enableActiveFill: true,
                          animationType: AnimationType.scale,
                          animationDuration: const Duration(milliseconds: 190),
                          pinTheme: PinTheme(
                            fieldOuterPadding:
                                const EdgeInsets.symmetric(horizontal: 3),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            borderWidth: 1,
                            borderRadius: BorderRadius.circular(7),
                            shape: PinCodeFieldShape.box,
                            activeColor: colorBlueLittleDark,
                            activeFillColor: Colors.white,
                            selectedColor: Colors.black,
                            selectedFillColor: Colors.white,
                            inactiveColor: colorBlueLittleDark,
                            inactiveFillColor: Colors.white,
                          ),
                          controller: pincodeController,
                          autoDisposeControllers: false,
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: colorBlueLittleDark,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Helvetica Neue',
                          ),
                          keyboardType: TextInputType.number,
                          onCompleted: (value) {
                            login(arguments.number);
                          },
                          onChanged: (_) {},
                        ),
                      ),
                      !showTimer
                          ? Container(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Vous n'avez pas reçu le code ?",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15.0),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showTimer = true;
                                      });
                                      startTimer();
                                      resend(arguments.number);
                                    },
                                    child: const Text(
                                      'Renvoyer',
                                      style: TextStyle(
                                          color: colorBlueLittleDark,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                          fontSize: 15.0),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                'Renvoyez le code dans ${counter.toString()}s',
                                style: const TextStyle(color: colorOrange),
                              ),
                            )
                    ],
                  ),
            Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomButton(
                        contextProp: context,
                        color: colorBlueLittleDark,
                        onPressedProp: () {
                          login(arguments.number);
                        },
                        disabledProp:
                            pincodeController.text.length < 6 || loader == true,
                        textProp: "Valider le code"),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
