// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/components/loader.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/schemas/reading_day/reading_day.dart';
import 'package:ediocese_app/services/all_api.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:velocity_x/velocity_x.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  ReadingScreenState createState() => ReadingScreenState();
}

class ReadingScreenState extends State<ReadingScreen> {
  @override
  void initState() {
    getReading();
    super.initState();
  }

  AllApi allApi = container<AllApi>();

  List<ReadingDay> readings = [];
  bool gettingReadings = false;

  void getReading() async {
    setState(() {
      gettingReadings = true;
    });

    try {
      final res = await allApi.getReadingsDay();
      if (res.success == true) {
        setState(() {
          gettingReadings = false;
          readings = res.readingsDay;
        });
      }
    } catch (error) {
      setState(() {
        gettingReadings = false;
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

  List<Widget> _buildReadingList() {
    return readings.isNotEmpty
        ? readings
            .mapIndexed(
              (e, index) => _buildReadingItem(e, index),
            )
            .toList()
        : [const Text("Pas de passages")];
  }

  Widget _buildReadingItem(ReadingDay readingDay, int i) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(bottom: 20.0, top: i == 0 ? 0.0 : 20.0),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: colorGrey))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            readingDay.titre,
            style: const TextStyle(
                color: colorBlueLittleDark,
                fontWeight: FontWeight.w600,
                fontSize: 17.0),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            "« ${readingDay.passage} »",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            "(${readingDay.versets})",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            readingDay.contenu,
          )
        ],
      ),
    );
  }

  SizedBox _buildLoader(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 2.1 + 37 + 20,
      child: Center(
        child: Loader(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
        titleProp: 'Lectures du jour',
        titleColor: Colors.white,
        backButtonColor: Colors.white,
        context: context,
        centerTitle: true,
        titleFontSize: 17.0,
        backgroundColor: colorBlueLittleDark,
        showBackButton: true,
      ),
      body: SafeArea(
          child: Container(
        color: colorBlueLittleDark,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Expanded(
                child: RefreshIndicator(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const Text(
                            "Vendredi 10 avril 2020",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18.0, horizontal: 15.0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(17.0)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: gettingReadings
                                  ? [_buildLoader(context)]
                                  : _buildReadingList(),
                            ),
                          )
                        ],
                      ),
                    ),
                    onRefresh: () async {
                      getReading();
                    }))
          ],
        ),
      )),
    );
  }
}
