// ignore_for_file: use_build_context_synchronously, import_of_legacy_library_into_null_safe, constant_identifier_names

import 'dart:async';

import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/locator.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/schemas/registration_screen_arguments.dart';
import 'package:ediocese_app/screens/onboarding/change_password_screen.dart';
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

class ConfirmCodeScreen extends StatefulWidget {
  const ConfirmCodeScreen({super.key, this.fromResetPassword});
  final bool? fromResetPassword;

  @override
  ConfirmCodeScreenState createState() => ConfirmCodeScreenState();
}

class ConfirmCodeScreenState extends State<ConfirmCodeScreen> {
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  bool loader = false;

  static const int RESEND_CODE_DELAY_IN_SECONDS = 60;
  int counter = RESEND_CODE_DELAY_IN_SECONDS;

  String code = "";
  Timer? timer;
  bool showTimer = true;

  RegistrationScreenArguments arguments = RegistrationScreenArguments('');

  UserApi userApi = container<UserApi>();

  final NavigationService _navigationService = locator<NavigationService>();

  final SafeSecureStorage storage = container<SafeSecureStorage>();

  void onChangedCode(String text) {
    setState(() {
      code = text;
    });
  }

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

  void _confirm(String email) async {
    setState(() {
      loader = true;
    });
    try {
      final res = await userApi.checkVerificationCode(email, code);
      if (res.success == true) {
        setState(() {
          loader = false;
        });
        _showMessage(
            "Votre adresse email a bien été confirmée ! Vous pouvez vous connecter maintenant");
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ));
      }
    } catch (error) {
      setState(() {
        loader = false;
      });
      _showDialog(error.toString());
    }
  }

  void _confirmAndChangePassword(String email) async {
    setState(() {
      loader = true;
    });
    try {
      final res = await userApi.verifyCodeReset(email, code);
      if (res.success == true) {
        setState(() {
          loader = false;
        });
        await storage.write(key: 'tempToken', value: res.token);

        await _navigationService.popAllAndNavigateTo(
          MaterialPageRoute(
            builder: (context) => const ChangePasswordScreen(),
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

  void _resend(String email) async {
    try {
      await userApi.postVerificationCode(email);
    } catch (error) {
      _showDialog(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context)!.settings.arguments
        as RegistrationScreenArguments;

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
                          girlPlanning,
                          height: 180.0,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        const Text(
                          "Confirmation de l'adresse e-mail",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22.0),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          "Entrez le code que vous avez reçu sur ${arguments.email}",
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
                                    initialValue: code,
                                    inputType: TextInputType.number,
                                    labelText: "",
                                    label: "Code",
                                    labelColor: colorGreyBlack,
                                    borderColor: colorGreyBlack,
                                    showErrorMessage: true,
                                    maxLength: 6,
                                    suffixIcon: Image.asset(tick),
                                    onChanged: onChangedCode),
                                !showTimer
                                    ? Container(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
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
                                                _resend(arguments.email);
                                              },
                                              child: const Text(
                                                'Renvoyer',
                                                style: TextStyle(
                                                    color: colorBlueLittleDark,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontSize: 15.0),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          'Renvoyez le code dans ${counter.toString()}s',
                                          style: const TextStyle(
                                              color: colorBlueLittleDark,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                CustomButton(
                                    contextProp: context,
                                    loader: loader,
                                    disabledProp:
                                        code.length < 6 || loader == true,
                                    onPressedProp: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (widget.fromResetPassword == true) {
                                          _confirmAndChangePassword(
                                              arguments.email);
                                        } else {
                                          _confirm(arguments.email);
                                        }
                                      }
                                    },
                                    textProp: "Vérifier"),
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
