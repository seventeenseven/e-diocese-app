import 'package:ediocese_app/locator.dart';
import 'package:ediocese_app/screens/dashboard/bottom_tab_navigator.dart';
import 'package:ediocese_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/constants/img_urls.dart';

class BootScreen extends StatefulWidget {
  const BootScreen({super.key});

  @override
  BootScreenState createState() => BootScreenState();
}

class BootScreenState extends State<BootScreen> {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  void initState() {
    timeOut();
    super.initState();
  }

  void timeOut() async {
    Future.delayed(const Duration(seconds: 3), () async {
      await _navigationService.popAllAndNavigateTo(
        MaterialPageRoute(
          builder: (context) => const BottomTabNavigator(),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: TabAppBar(
        //     titleProp: "", context: context, backgroundColor: colorBlueSoft),
        body: Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                dioceseBg,
              ),
              fit: BoxFit.cover)),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 40.0),
      child: Center(
        child: Image.asset(dioceseLogo),
      ),
    ));
  }
}
