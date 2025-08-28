import 'package:ediocese_app/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/constants/img_urls.dart';

class PrayerIntentionsSuccessfullScreen extends StatefulWidget {
  const PrayerIntentionsSuccessfullScreen({super.key});

  @override
  PrayerIntentionsSuccessfullScreenState createState() =>
      PrayerIntentionsSuccessfullScreenState();
}

class PrayerIntentionsSuccessfullScreenState
    extends State<PrayerIntentionsSuccessfullScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: TabAppBar(
        //     titleProp: "",
        //     context: context,
        //     showBackButton: true,
        //     backgroundColor: Colors.transparent),
        body: SafeArea(
            child: Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                dioceseBg,
              ),
              fit: BoxFit.cover)),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 100.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  Image.asset(giftImage),
                  const SizedBox(
                    height: 50.0,
                  ),
                  const Text(
                    "Félicitations, votre intention de prière a été envoyée",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  CustomButton(
                      contextProp: context,
                      onPressedProp: () {
                        Navigator.pop(context);
                      },
                      color: Colors.white,
                      textColor: Colors.black,
                      textProp: "Retour")
                ],
              ),
            ),
          ))
        ],
      ),
    )));
  }
}
