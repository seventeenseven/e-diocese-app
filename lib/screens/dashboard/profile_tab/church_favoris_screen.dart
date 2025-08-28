// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/components/inputs/input_field.dart';
import 'package:ediocese_app/components/loader.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/schemas/church/church.dart';
import 'package:ediocese_app/models/schemas/church_favoris/church_favoris.dart';
import 'package:ediocese_app/screens/dashboard/home_tab/church_details_screen.dart';
import 'package:ediocese_app/services/favoris_api.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:velocity_x/velocity_x.dart';

class ChurchFavorisScreen extends StatefulWidget {
  const ChurchFavorisScreen({super.key});

  @override
  ChurchFavorisScreenState createState() => ChurchFavorisScreenState();
}

class ChurchFavorisScreenState extends State<ChurchFavorisScreen> {
  @override
  void initState() {
    getChurch();
    super.initState();
  }

  FavorisApi favorisApi = container<FavorisApi>();

  List<ChurchFavoris> churchs = [];
  bool gettingChurch = false;

  List<ChurchFavoris> churchsCopy = [];

  bool isShowSearchField = false;

  String church = "";

  void onChangedChurch(String text) {
    _searchChurch(text);

    setState(() {
      church = text;
    });
  }

  void _searchChurch(String church) {
    if (churchs.isEmpty) {
      setState(() {
        churchs = churchsCopy;
      });
      return;
    }
    final newChurchs = churchsCopy.where((element) =>
        element.church.nom.toLowerCase().contains(church.toLowerCase()));
    setState(() {
      churchs = newChurchs.toList();
    });
  }

  void getChurch() async {
    setState(() {
      gettingChurch = true;
    });

    try {
      final res = await favorisApi.getChurchFavoris();
      if (res.success == true) {
        setState(() {
          gettingChurch = false;
          churchs = res.favoris;
          churchsCopy = res.favoris;
        });
      }
    } catch (error) {
      setState(() {
        gettingChurch = false;
      });
      _showDialog(error.toString());
    }
  }

  SizedBox _buildLoader(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 2.1 + 37 + 20,
      child: Center(
        child: Loader(),
      ),
    );
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

  Widget _buildChurchItem(Church church) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChurchDetailsScreen(
                  churchId: church.id,
                ),
              ));
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.only(bottom: 15.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(
                church.image,
                height: 94.0,
                width: MediaQuery.of(context).size.width * 0.280,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                width: 10.0,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      church.nom,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(church.description),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      church.commune,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  List<Widget> _buildChurchList() {
    return churchs.isNotEmpty
        ? churchs
            .mapIndexed(
              (e, index) => _buildChurchItem(e.church),
            )
            .toList()
        : [const Text("Pas d'églises favoris")];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
          titleProp: 'Églises favoris',
          titleColor: Colors.white,
          context: context,
          backgroundColor: colorBlueLittleDark,
          backButtonColor: Colors.white,
          showBackButton: true,
          actionsProp: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  isShowSearchField = !isShowSearchField;
                });
              },
              child: const Icon(
                Icons.search,
                color: Colors.white,
                size: 30.0,
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
          ]),
      body: SafeArea(
          child: Container(
        color: colorGreyShadeLight,
        width: MediaQuery.of(context).size.width,
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
                            isShowSearchField == true
                                ? InputField(
                                    initialValue: church,
                                    inputType: TextInputType.text,
                                    labelText: "Rechercher un favoris",
                                    label: "",
                                    labelColor: colorGreyBlack,
                                    borderColor: colorGreyBlack,
                                    showErrorMessage: true,
                                    onChanged: onChangedChurch)
                                : Container(),
                            const SizedBox(
                              height: 15.0,
                            ),
                            // const Text(
                            //   "Églises",
                            //   style: TextStyle(
                            //       color: colorGreyBlack,
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: 18.0),
                            // ),
                            // const SizedBox(
                            //   height: 15.0,
                            // ),
                            Column(
                              children: gettingChurch
                                  ? [_buildLoader(context)]
                                  : _buildChurchList(),
                            )
                          ],
                        ),
                      ),
                    ),
                    onRefresh: () async {
                      getChurch();
                    }))
          ],
        ),
      )),
    );
  }
}
