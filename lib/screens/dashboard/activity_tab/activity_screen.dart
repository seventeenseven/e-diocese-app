// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/components/inputs/input_field.dart';
import 'package:ediocese_app/components/loader.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/schemas/activite/activite.dart';
import 'package:ediocese_app/screens/dashboard/activity_tab/activity_details_screen.dart';
import 'package:ediocese_app/services/all_api.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:velocity_x/velocity_x.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  ActivityScreenState createState() => ActivityScreenState();
}

class ActivityScreenState extends State<ActivityScreen> {
  @override
  void initState() {
    getActivites();
    super.initState();
  }

  AllApi allApi = container<AllApi>();

  List<Activite> activites = [];
  bool gettingActivites = false;

  List<Activite> activitesCopy = [];

  bool isOrder = false;

  bool isShowSearchField = false;

  String activite = "";

  void onChangedActivite(String text) {
    _searchActivite(text);

    setState(() {
      activite = text;
    });
  }

  void _searchActivite(String activite) {
    if (activites.isEmpty) {
      setState(() {
        activites = activitesCopy;
      });
      return;
    }
    final newActivites = activitesCopy.where((element) =>
        element.titre.toLowerCase().contains(activite.toLowerCase()));
    setState(() {
      activites = newActivites.toList();
    });
  }

  void getActivites({bool order = false}) async {
    setState(() {
      gettingActivites = true;
    });

    try {
      final res = await allApi.getActivites(order: order);
      if (res.success == true) {
        setState(() {
          gettingActivites = false;
          activites = res.activites;
          activitesCopy = res.activites;
        });
      }
    } catch (error) {
      setState(() {
        gettingActivites = false;
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

  Widget _buildActiviteItem(Activite activite) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActivityDetailsScreen(
                  activiteId: activite.id,
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
                activite.image,
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
                      activite.titre,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    RichText(
                      key: const Key('rich-text'),
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: activite.description.length >= 60
                                ? '${activite.description.substring(0, 60).toLowerCase()}...'
                                : activite.description.toLowerCase(),
                            style: const TextStyle(color: Colors.black)),
                        if (activite.description.length >= 60)
                          const TextSpan(
                              text: '  Voir plus',
                              style: TextStyle(
                                color: Color.fromARGB(255, 164, 162, 162),
                              ))
                      ]),
                    ),
                    // Text(
                    //   activite.description.length >= 80
                    //       ? '${activite.description.substring(0, 80).toLowerCase()}...'
                    //       : activite.description.toLowerCase(),
                    // ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      activite.commune,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  List<Widget> _buildActiviteList() {
    return activites.isNotEmpty
        ? activites
            .mapIndexed(
              (e, index) => _buildActiviteItem(e),
            )
            .toList()
        : [const Text("Pas d'activités")];
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
          titleProp: 'Activités',
          titleColor: Colors.white,
          context: context,
          backgroundColor: colorBlueLittleDark,
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
            InkWell(
              onTap: () {
                if (isOrder == true) {
                  getActivites();
                  setState(() {
                    isOrder = false;
                  });
                  return;
                }
                getActivites(order: true);
                setState(() {
                  isOrder = true;
                });
              },
              child: Icon(isOrder == true ? Icons.sort : Icons.sort_by_alpha,
                  color: Colors.white),
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
                                    initialValue: activite,
                                    inputType: TextInputType.text,
                                    labelText: "Rechercher une activité",
                                    label: "",
                                    labelColor: colorGreyBlack,
                                    borderColor: colorGreyBlack,
                                    showErrorMessage: true,
                                    onChanged: onChangedActivite)
                                : Container(),
                            const SizedBox(
                              height: 15.0,
                            ),
                            // const Text(
                            //   "Activités",
                            //   style: TextStyle(
                            //       color: colorGreyBlack,
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: 18.0),
                            // ),
                            // const SizedBox(
                            //   height: 15.0,
                            // ),
                            Column(
                              children: gettingActivites
                                  ? [_buildLoader(context)]
                                  : _buildActiviteList(),
                            )
                          ],
                        ),
                      ),
                    ),
                    onRefresh: () async {}))
          ],
        ),
      )),
    );
  }
}
