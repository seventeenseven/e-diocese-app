// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:io';

import 'package:ediocese_app/components/custom_button.dart';
import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/components/loader.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/constants/img_urls.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/schemas/priere/priere.dart';
import 'package:ediocese_app/screens/dashboard/home_tab/prayer_intentions_screen.dart';
import 'package:ediocese_app/services/all_api.dart';
import 'package:ediocese_app/services/safe_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class PrayScreen extends StatefulWidget {
  const PrayScreen({super.key});

  @override
  PrayScreenState createState() => PrayScreenState();
}

class PrayScreenState extends State<PrayScreen> {
  @override
  void initState() {
    getPrieres();
    super.initState();
  }

  AllApi allApi = container<AllApi>();
  final storage = container<SafeSecureStorage>();

  bool gettingPrieres = false;
  List<Priere> prieres = [];

  String userId = "";

  Future<String?> _readToken() async {
    final tokenPref = await storage.read(key: 'token');
    return tokenPref;
  }

  void getPrieres() async {
    setState(() {
      gettingPrieres = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final getUserId = prefs.getString('userId');
    setState(() {
      userId = getUserId ?? "";
    });
    final token = await _readToken();
    if (token == null) {
      setState(() {
        gettingPrieres = false;
      });
      return;
    }

    try {
      final res = await allApi.getPrieres();
      if (res.success == true) {
        setState(() {
          gettingPrieres = false;
          prieres = res.prieres;
        });
      }
    } catch (error) {
      setState(() {
        gettingPrieres = false;
      });
      _showDialog(error.toString());
    }
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

  List<Widget> _buildPriereList() {
    return prieres.isNotEmpty
        ? prieres.mapIndexed((e, i) => _buildPriereItem(e)).toList()
        : [const Text("Aucune prières")];
  }

  SizedBox _buildLoader(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 2.1 + 37 + 20,
      child: Center(
        child: Loader(color: colorOrange),
      ),
    );
  }

  Container _buildPriereItem(Priere priere) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
          color: colorBlueLittleDark,
          borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: colorGrey.withOpacity(0.4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  "INTENTIONS",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(priere.createdAt),
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          priere.sujet,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 2.0,
                        ),
                        Text(
                          priere.periode,
                          style: const TextStyle(
                              fontSize: 17.0, color: Colors.white),
                        )
                      ],
                    ),
                    Text(
                      priere.temps,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                          color: Colors.white),
                    ),
                  ],
                ),
                Text(
                  priere.description,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 10.0,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
          titleProp: 'Intentions de prières',
          context: context,
          centerTitle: true,
          titleColor: Colors.white,
          backgroundColor: colorBlueLittleDark,
          actionsProp: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Image.asset(
                dioceseLogo,
                fit: BoxFit.contain,
                height: 30.0,
              ),
            )
          ]),
      body: SafeArea(
          child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: RefreshIndicator(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if ((Platform.isIOS &&
                                    userId != '637689ec1058d65964fb4436') ||
                                Platform.isAndroid)
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: colorBlueLittleDark.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Column(
                                  children: <Widget>[
                                    const Text(
                                      "Envoyer une nouvelle intention de prière",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    CustomButton(
                                        contextProp: context,
                                        onPressedProp: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const PrayerIntentionsScreen(),
                                              ));
                                        },
                                        color: colorBlueLittleDark,
                                        icon: const Icon(
                                          FontAwesomeIcons.pen,
                                          color: Colors.white,
                                        ),
                                        textProp: "Envoyer")
                                  ],
                                ),
                              ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Column(
                              children: gettingPrieres
                                  ? [_buildLoader(context)]
                                  : _buildPriereList(),
                            )
                          ],
                        ),
                      ),
                    ),
                    onRefresh: () async {
                      getPrieres();
                    }))
          ],
        ),
      )),
    );
  }
}
