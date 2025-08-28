// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:ediocese_app/components/custom_button.dart';
import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/components/loader.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/constants/img_urls.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/schemas/activite/activite.dart';
import 'package:ediocese_app/services/all_api.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:share_plus/share_plus.dart' as share_link;

class ActivityDetailsScreen extends StatefulWidget {
  const ActivityDetailsScreen({super.key, required this.activiteId});
  final String activiteId;

  @override
  ActivityDetailsScreenState createState() => ActivityDetailsScreenState();
}

class ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  @override
  void initState() {
    getActivite();
    getSimilarActivites();
    super.initState();
  }

  AllApi allApi = container<AllApi>();

  List<Activite> activites = [];
  bool gettingActivites = false;

  bool participating = false;

  Activite? activite;
  bool gettingActivite = false;

  void getSimilarActivites() async {
    setState(() {
      gettingActivites = true;
    });

    try {
      final res =
          await allApi.getSimilarActivites(activiteId: widget.activiteId);
      if (res.success == true) {
        setState(() {
          gettingActivites = false;
          activites = res.activites;
        });
      }
    } catch (error) {
      setState(() {
        gettingActivites = false;
      });
      _showDialog(error.toString());
    }
  }

  void getActivite() async {
    setState(() {
      gettingActivite = true;
    });

    try {
      final res = await allApi.getOnlyActivite(widget.activiteId);
      if (res.success == true) {
        setState(() {
          gettingActivite = false;
          activite = res.activite;
        });
      }
    } catch (error) {
      setState(() {
        gettingActivite = false;
      });
      _showDialog(error.toString());
    }
  }

  void addToFavoris(String actId) async {
    try {
      final res = await allApi.addToActiviteFavoris(actId);
      if (res.success == true) {
        getActivite();
        if (res.errorMessage == null) {
          _showMessage("L'activité a bien été ajoutée à vos favoris");
        } else {
          _showMessage("L'activité a bien été retirée de vos favoris");
        }
      }
    } catch (error) {
      if (error.toString().toLowerCase().contains('nosuchmethoderror')) {
        return;
      }
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
        getActivite();
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

  void _showDialog(String errorMessage) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(contextProp: context, messageProp: errorMessage);
      },
    );
  }

  _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      behavior: SnackBarBehavior.floating,
    ));
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
                height: 100.0,
                width: MediaQuery.of(context).size.width * 0.280,
                fit: BoxFit.fill,
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
                    Text(activite.description),
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
          titleProp: '',
          context: context,
          showBackButton: true,
          actionsProp: <Widget>[
            InkWell(
              onTap: () {
                addToFavoris(
                    activite != null ? activite!.id : widget.activiteId);
              },
              child: activite != null && activite!.favoris == true
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 13.0),
                      child: const Icon(
                        Icons.save_rounded,
                        color: Colors.grey,
                        size: 32.0,
                      ),
                    )
                  : Image.asset(save),
            ),
            InkWell(
              onTap: () async {
                await share_link.Share.share(
                    activite != null ? activite!.description : '',
                    subject: activite != null ? activite!.titre : '');
              },
              child: const Icon(Icons.link, color: colorGrey),
            ),
            const SizedBox(
              width: 10.0,
            ),
          ]),
      body: SafeArea(
          child: Container(
        color: Colors.white,
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
                            gettingActivite
                                ? _buildLoader(context)
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "${activite != null ? activite!.titre : ''} ${DateFormat("dd/MM/yyy").format(activite != null ? activite!.date : DateTime.now())}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        activite!.ville,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.network(
                                          activite!.image,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 250.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      const Text(
                                        "Description :",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.0,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(activite != null
                                          ? activite!.description
                                          : ''),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      CustomButton(
                                          contextProp: context,
                                          disabledProp:
                                              activite!.participate == true,
                                          onPressedProp: () {
                                            participate(activite!.id);
                                          },
                                          loader: participating,
                                          color: activite!.participate == true
                                              ? colorRedDisabled
                                              : colorBlueLittleDark,
                                          textProp:
                                              activite!.participate == true
                                                  ? "Participe déja"
                                                  : "Je participe"),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      CustomButton(
                                          contextProp: context,
                                          onPressedProp: () async {
                                            await share_link.Share.share(
                                                activite != null
                                                    ? activite!.description
                                                    : '',
                                                subject: activite != null
                                                    ? activite!.titre
                                                    : '');
                                          },
                                          color: Colors.black,
                                          textProp: "Partager à mes proches")
                                    ],
                                  ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Autres activités".toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17.0),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Column(
                              children: gettingActivites
                                  ? [_buildLoader(context)]
                                  : _buildActiviteList(),
                            )
                          ],
                        ),
                      ),
                    ),
                    onRefresh: () async {
                      getActivite();
                      getSimilarActivites();
                    }))
          ],
        ),
      )),
    );
  }
}
