// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  AboutScreenState createState() => AboutScreenState();
}

class AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
          titleProp: "À propos de E-Diocese",
          context: context,
          titleColor: colorBlueLittleDark,
          centerTitle: true,
          showBackButton: true),
      body: SafeArea(
          child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Expanded(
                child: RefreshIndicator(
                    child: const SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 15.0,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("© 2023 Ediocèse Tous droits réservés")
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    onRefresh: () async {}))
          ],
        ),
      )),
    );
  }
}
