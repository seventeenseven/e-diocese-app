// ignore_for_file: import_of_legacy_library_into_null_safe, use_build_context_synchronously

import 'package:ediocese_app/components/custom_button.dart';
import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/components/inputs/input_field.dart';
import 'package:ediocese_app/components/loader.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:ediocese_app/constants/img_urls.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/schemas/user/user.dart';
import 'package:ediocese_app/screens/dashboard/profile_tab/profile_screen.dart';
import 'package:ediocese_app/services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  ProfileDetailsScreenState createState() => ProfileDetailsScreenState();
}

class ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  String firstName = "";
  String lastName = "";
  String email = "";
  String phone = "";
  bool loader = false;
  bool _savingInfos = false;
  User? _currentUserInfos;

  UserApi userApi = container<UserApi>();

  @override
  void initState() {
    _getUserInfos();
    super.initState();
  }

  void onChangedFirstname(String text) {
    setState(() {
      firstName = text;
    });
  }

  void onChangedLastname(String text) {
    setState(() {
      lastName = text;
    });
  }

  void onChangedEmail(String text) {
    setState(() {
      email = text;
    });
  }

  void onChangedPhone(String text) {
    setState(() {
      phone = text;
    });
  }

  _showDialog(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(contextProp: context, messageProp: message);
      },
    );
  }

  _getUserInfos() async {
    try {
      setState(() {
        loader = true;
      });
      final res = await userApi.getMe();
      final User user = res.user;
      setState(() {
        loader = false;
        _currentUserInfos = user;
        _updateControllersWithNewInfo(user);
      });
    } catch (error) {
      setState(() {
        loader = false;
      });
      _showDialog(error.toString());
    }
  }

  void _saveUserInfos() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        _savingInfos = true;
      });
      final User newUserInfo = _currentUserInfos!.clone(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: _currentUserInfos!.phone);

      final res = await userApi.updateMe(newUserInfo);
      final User user = res.user;

      setState(() {
        _savingInfos = false;
        _currentUserInfos = user;
        _updateControllersWithNewInfo(user);
      });
      await prefs.setString('firstName', user.firstName);
      await prefs.setString('lastName', user.lastName);
      await prefs.setString('email', user.email);
      await prefs.setString('phone', user.phone);

      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ));
    } catch (error) {
      setState(() {
        _savingInfos = false;
      });
      _showDialog(error.toString());
    }
  }

  _updateControllersWithNewInfo(User userInfo) {
    firstName = userInfo.firstName;
    lastName = userInfo.lastName;
    email = userInfo.email;
    phone = userInfo.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
          titleProp: "Modifier mes informations",
          context: context,
          centerTitle: true,
          showBackButton: true),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Expanded(
                  child: RefreshIndicator(
                onRefresh: () async {},
                child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Image.asset(loginIllustration),
                          loader
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Center(child: Loader(size: 50)),
                                )
                              : Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      InputField(
                                          initialValue: firstName,
                                          inputType: TextInputType.text,
                                          onChanged: onChangedFirstname,
                                          showErrorMessage: true,
                                          label: "Votre nom",
                                          labelText: "votre nom"),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      InputField(
                                          initialValue: lastName,
                                          inputType: TextInputType.text,
                                          onChanged: onChangedLastname,
                                          showErrorMessage: true,
                                          label: "Votre prénom",
                                          labelText: "Votre prénom"),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      InputField(
                                          initialValue: email,
                                          inputType: TextInputType.emailAddress,
                                          onChanged: onChangedEmail,
                                          showErrorMessage: true,
                                          label: "Adresse e-mail",
                                          labelText: "Adresse e-mail"),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      InputField(
                                          initialValue: phone,
                                          inputType: TextInputType.phone,
                                          onChanged: onChangedPhone,
                                          showErrorMessage: true,
                                          label: "Numéro de téléphone",
                                          labelText: "Numéro de téléphone"),
                                    ],
                                  ))
                        ],
                      )),
                ),
              )),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0),
                child: CustomButton(
                    disabledProp: _savingInfos,
                    contextProp: context,
                    loader: _savingInfos,
                    onPressedProp: () {
                      if (_formKey.currentState!.validate()) {
                        _saveUserInfos();
                      }
                    },
                    textProp: "Modifier"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
