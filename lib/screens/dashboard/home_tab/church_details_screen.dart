// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/components/loader.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/constants/img_urls.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/schemas/church/church.dart';
import 'package:ediocese_app/services/all_api.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:share_plus/share_plus.dart' as share_link;

class ChurchDetailsScreen extends StatefulWidget {
  const ChurchDetailsScreen({super.key, required this.churchId});
  final String churchId;

  @override
  ChurchDetailsScreenState createState() => ChurchDetailsScreenState();
}

class ChurchDetailsScreenState extends State<ChurchDetailsScreen> {
  @override
  void initState() {
    getChurch();
    getSimilarChurch();
    super.initState();
  }

  AllApi allApi = container<AllApi>();

  List<Church> churchs = [];
  bool gettingSimilarChurch = false;

  Church? church;
  bool gettingChurch = false;

  void getSimilarChurch() async {
    setState(() {
      gettingSimilarChurch = true;
    });

    try {
      final res = await allApi.getSimilarChurch(churchId: widget.churchId);
      if (res.success == true) {
        setState(() {
          gettingSimilarChurch = false;
          churchs = res.churchs;
        });
      }
    } catch (error) {
      setState(() {
        gettingSimilarChurch = false;
      });
      _showDialog(error.toString());
    }
  }

  void getChurch() async {
    setState(() {
      gettingChurch = true;
    });

    try {
      final res = await allApi.getOnlyChurch(widget.churchId);
      if (res.success == true) {
        setState(() {
          gettingChurch = false;
          church = res.church;
        });
      }
    } catch (error) {
      setState(() {
        gettingChurch = false;
      });
      _showDialog(error.toString());
    }
  }

  void addToFavoris(String churchId) async {
    try {
      final res = await allApi.addToFavoris(churchId);
      if (res.success == true) {
        getChurch();
        if (res.errorMessage == null) {
          _showMessage("L'église a bien été ajoutée à vos favoris");
        } else {
          _showMessage("L'église a bien été retirée de vos favoris");
        }
      }
    } catch (error) {
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
              (e, index) => _buildChurchItem(e),
            )
            .toList()
        : [const Text("Pas d'autres églises à proximité")];
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
                addToFavoris(church != null ? church!.id : widget.churchId);
              },
              child: church != null && church!.favoris == true
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
                share_link.Share.share(
                    church != null ? church!.description : '',
                    subject: church != null ? church!.nom : '');
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
                            gettingChurch
                                ? _buildLoader(context)
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        church != null ? church!.nom : '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        church != null ? church!.commune : '',
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
                                          church!.image,
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
                                        "Description: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.0,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(church != null
                                          ? church!.description
                                          : ''),
                                    ],
                                  ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Autres églises à proximité".toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17.0),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Column(
                              children: gettingSimilarChurch
                                  ? [_buildLoader(context)]
                                  : _buildChurchList(),
                            )
                          ],
                        ),
                      ),
                    ),
                    onRefresh: () async {
                      getChurch();
                      getSimilarChurch();
                    }))
          ],
        ),
      )),
    );
  }
}
