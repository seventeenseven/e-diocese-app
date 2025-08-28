// ignore_for_file: import_of_legacy_library_into_null_safe, use_build_context_synchronously

import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/schemas/login_screen_arguments.dart';
import 'package:ediocese_app/screens/dashboard/profile_tab/cgu_screen.dart';
import 'package:ediocese_app/screens/onboarding/verification_screen.dart';
import 'package:ediocese_app/services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/components/custom_button.dart';
import 'package:ediocese_app/components/inputs/input_field.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/constants/img_urls.dart';
import 'package:ediocese_app/screens/onboarding/login_screen.dart';
// import 'package:ediocese_app/screens/onboarding/welcome_first_screen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  @override
  void initState() {
    super.initState();
  }

  String phoneNumber = "";
  String phoneIsoCode = "";
  String country = "";
  bool hasError = true;

  UserApi userApi = container<UserApi>();

  final _formKey = GlobalKey<FormState>();
  bool loader = false;

  String email ="";
  String fullName = "";
  String ville = "";

  bool register = false;
  bool isChecked = false;

  void onPhoneNumberChange(
      String number, bool isInvalid, String isoCode, String countryCode) {
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
      country = countryCode;
      hasError = isInvalid;
    });
  }

  void onChangedEmail(String text) {
    setState(() {
      email = text;
    });
  }

  void onChangedVille(String text) {
    setState(() {
      ville = text;
    });
  }

  void onChangedFullName(String text) {
    setState(() {
      fullName = text;
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
  bool _isValidPhone(String phone) {
    return phone.length >= 8; // Exemple de validation basique
  }

  void _registration() async {
    FocusScope.of(context).unfocus();

    if (isChecked == false) {
      _showDialog(
          "Vous devez accepter les conditions d'utilisations avant de continuer");
      return;
    }

    setState(() {
      register = true;
    });
    try {
      final firstName = fullName.split(' ').first;
      final lastName = fullName.split(' ').last;
      final res = await userApi.registration(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phoneNumber,
          country: country,
          ville: ville);

      if (res.success == true) {
        setState(() {
          register = false;
        });
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const VerificationScreen(),
                settings: RouteSettings(
                    arguments: LoginScreenArguments(phoneNumber))));
      }
    } catch (error) {
      setState(() {
        register = false;
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "S'inscrire",
                            style: TextStyle(
                                color: colorGreyBlack,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                InputField(
                                    initialValue: fullName,
                                    inputType: TextInputType.text,
                                    labelText: "",
                                    label: "Nom & prénom(s)",
                                    labelColor: colorGreyBlack,
                                    borderColor: colorGreyBlack,
                                    showErrorMessage: true,
                                    suffixIcon: Image.asset(tick),
                                    onChanged: onChangedFullName),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                InputField(
                                    initialValue: email ,
                                    inputType: TextInputType.emailAddress,
                                    labelText: "",
                                    label: "Email",
                                    labelColor: colorGreyBlack,
                                    borderColor: colorGreyBlack,
                                    suffixIcon: Image.asset(tick),
                                    onChanged: onChangedEmail),
                                const SizedBox(
                                  height: 25.0,
                                ),
                                Center(
                                  child: IntlPhoneField(
                                    initialCountryCode: 'CI',
                                    onChanged: (phone) {
                                      setState(() {
                                        phoneNumber = phone.completeNumber;
                                        country = phone.countryISOCode.toUpperCase();
                                        hasError = !_isValidPhone(phone.completeNumber);
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Téléphone',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 25.0,
                                ),
                                InputField(
                                    initialValue: ville,
                                    inputType: TextInputType.text,
                                    labelText: "",
                                    label: "Ville",
                                    labelColor: colorGreyBlack,
                                    borderColor: colorGreyBlack,
                                    showErrorMessage: true,
                                    suffixIcon: Image.asset(tick),
                                    onChanged: onChangedVille),
                                const SizedBox(
                                  height: 25.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                      checkColor: Colors.white,
                                      fillColor: MaterialStateProperty.all(
                                          colorBlueLittleDark),
                                      value: isChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isChecked = value!;
                                        });
                                      },
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const CguScreen()));
                                      },
                                      child: const Text(
                                          "J'accepte les conditions d'utilisations"),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                CustomButton(
                                    contextProp: context,
                                    loader: register,
                                    disabledProp: hasError,
                                    onPressedProp: () {
                                      if (_formKey.currentState!.validate()) {
                                        _registration();
                                      }
                                    },
                                    textProp: "Continuer"),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text("Déjà un compte ?"),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen(),
                                            ));
                                      },
                                      child: const Text(
                                        "Se connecter",
                                        style: TextStyle(
                                            color: colorBlueLittleDark,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    const Text("ici")
                                  ],
                                ),
                                // const SizedBox(
                                //   height: 10.0,
                                // ),
                                // const Text("OU"),
                                // const SizedBox(
                                //   height: 10.0,
                                // ),
                                // TextButton(
                                //     style: ButtonStyle(
                                //         shape: MaterialStateProperty.all<
                                //                 OutlinedBorder>(
                                //             const RoundedRectangleBorder(
                                //                 borderRadius: BorderRadius.all(
                                //           Radius.circular(5.0),
                                //         ))),
                                //         backgroundColor:
                                //             MaterialStateProperty.all(
                                //                 Colors.blue)),
                                //     onPressed: () {},
                                //     child: Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.center,
                                //       children: const <Widget>[
                                //         Icon(
                                //           FontAwesomeIcons.facebook,
                                //           color: Colors.white,
                                //         ),
                                //         SizedBox(
                                //           width: 15.0,
                                //         ),
                                //         Text(
                                //           "S'inscrire avec Facebook",
                                //           style: TextStyle(color: Colors.white),
                                //         )
                                //       ],
                                //     )),
                                // const SizedBox(
                                //   height: 10.0,
                                // ),
                                // TextButton(
                                //     style: ButtonStyle(
                                //         shape: MaterialStateProperty.all<
                                //                 OutlinedBorder>(
                                //             const RoundedRectangleBorder(
                                //                 borderRadius: BorderRadius.all(
                                //           Radius.circular(5.0),
                                //         ))),
                                //         backgroundColor:
                                //             MaterialStateProperty.all(
                                //                 colorRed.withOpacity(0.9))),
                                //     onPressed: () {},
                                //     child: Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.center,
                                //       children: const <Widget>[
                                //         Icon(
                                //           FontAwesomeIcons.googlePlus,
                                //           color: Colors.white,
                                //         ),
                                //         SizedBox(
                                //           width: 15.0,
                                //         ),
                                //         Text(
                                //           "S'inscrire avec Google",
                                //           style: TextStyle(color: Colors.white),
                                //         )
                                //       ],
                                //     ))
                              ],
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(
              height: 20.0,
            )
          ],
        ),
      )),
    );
  }
}
