// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:ediocese_app/components/custom_button.dart';
import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/components/inputs/input_field.dart';
import 'package:ediocese_app/components/loader.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/schemas/activite_participate/activite_participate.dart';
import 'package:ediocese_app/screens/dashboard/activity_tab/activity_details_screen.dart';
import 'package:ediocese_app/services/all_api.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:velocity_x/velocity_x.dart';

class ActivitesParticipateScreen extends StatefulWidget {
  const ActivitesParticipateScreen({super.key});

  @override
  ActivitesParticipateScreenState createState() =>
      ActivitesParticipateScreenState();
}

class ActivitesParticipateScreenState
    extends State<ActivitesParticipateScreen> {
  @override
  void initState() {
    getActivitesParticipate();
    super.initState();
  }

  AllApi allApi = container<AllApi>();

  List<ActiviteParticipate> activites = [];
  bool gettingActivites = false;

  List<ActiviteParticipate> activitesCopy = [];

  bool isShowSearchField = false;

  String activite = "";

  bool participating = false;

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
        element.activite.titre.toLowerCase().contains(activite.toLowerCase()));
    setState(() {
      activites = newActivites.toList();
    });
  }

  void getActivitesParticipate() async {
    setState(() {
      gettingActivites = true;
    });

    try {
      final res = await allApi.actitivitiesParticipate();
      if (res.success == true) {
        setState(() {
          gettingActivites = false;
          activites = res.activities;
          activitesCopy = res.activities;
        });
      }
    } catch (error) {
      setState(() {
        gettingActivites = false;
      });
      _showDialog(error.toString());
    }
  }

  void participate(String actId) async {
    setState(() {
      participating = true;
    });
    try {
      final res = await allApi.addParticipateActivite(actId);
      if (res.success == true) {
        getActivitesParticipate();
        setState(() {
          participating = false;
        });
        if (res.message != null) {
          _showMessage(res.message.toString());
        } else {
          _showMessage("Vous êtes désormais inscrit à cette activité");
        }
      }
    } catch (error) {
      setState(() {
        participating = false;
      });
      if (error.toString().toLowerCase().contains('nosuchmethoderror')) {
        return;
      }
      _showDialog(error.toString());
    }
  }

  _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      behavior: SnackBarBehavior.floating,
    ));
  }

  Widget _buildActiviteItem(ActiviteParticipate activiteParticipate) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActivityDetailsScreen(
                  activiteId: activiteParticipate.activite.id,
                ),
              ));
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.only(bottom: 15.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(
                    activiteParticipate.activite.image,
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
                          activiteParticipate.activite.titre,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17.0),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(activiteParticipate.activite.description),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          activiteParticipate.activite.commune,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              CustomButton(
                  contextProp: context,
                  disabledProp: participating,
                  onPressedProp: () {
                    participate(activiteParticipate.activite.id);
                  },
                  loader: participating,
                  paddingVertical: 8.0,
                  textProp: "Annuler ma participation")
            ],
          ),
        ));
  }

  List<Widget> _buildActivitesList() {
    return activites.isNotEmpty
        ? activites
            .mapIndexed(
              (e, index) => _buildActiviteItem(e),
            )
            .toList()
        : [const Text("Vous ne participer à aucune activités")];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
        titleProp: 'Mes activités',
        titleColor: Colors.white,
        context: context,
        backgroundColor: colorBlueLittleDark,
        actionsProp: [
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
        ],
      ),
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
                            Column(
                              children: gettingActivites
                                  ? [_buildLoader(context)]
                                  : _buildActivitesList(),
                            )
                          ],
                        ),
                      ),
                    ),
                    onRefresh: () async {
                      getActivitesParticipate();
                    }))
          ],
        ),
      )),
    );
  }
}
