// ignore_for_file: use_build_context_synchronously, import_of_legacy_library_into_null_safe

import 'package:ediocese_app/components/custom_button.dart';
import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/components/inputs/input_field.dart';
import 'package:ediocese_app/components/loader.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/constants/img_urls.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/schemas/transaction/transaction.dart';
import 'package:ediocese_app/models/schemas/web_view_screen_arguments.dart';
import 'package:ediocese_app/screens/dashboard/bottom_tab_navigator.dart';
import 'package:ediocese_app/screens/dashboard/home_tab/prayer_intentions_successful_screen.dart';
import 'package:ediocese_app/screens/dashboard/home_tab/web_view_screen.dart';
import 'package:ediocese_app/services/all_api.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:select_form_field/select_form_field.dart';

class PrayerIntentionsScreen extends StatefulWidget {
  const PrayerIntentionsScreen({super.key});

  @override
  PrayerIntentionsScreenState createState() => PrayerIntentionsScreenState();
}

class PrayerIntentionsScreenState extends State<PrayerIntentionsScreen> {
  @override
  void initState() {
    getChurchs();
    super.initState();
  }

  AllApi allApi = container<AllApi>();

  final _formKey = GlobalKey<FormState>();

  String subject = "";
  String time = "";
  String periode = "";
  String description = "";
  String churchField = "";

  bool sending = false;

  Transaction? transaction;

  final List<Map<String, dynamic>> _items = [
    {
      'value': "5 minutes",
      'label': "5 minutes",
    },
    {
      'value': "10 minutes",
      'label': "10 minutes",
    },
    {
      'value': "15 minutes",
      'label': "15 minutes",
    },
    {
      'value': "20 minutes",
      'label': "20 minutes",
    },
    {
      'value': "25 minutes",
      'label': "25 minutes",
    },
    {
      'value': "30 minutes",
      'label': "30 minutes",
    },
    {
      'value': "35 minutes",
      'label': "35 minutes",
    },
    {
      'value': "40 minutes",
      'label': "40 minutes",
    },
    {
      'value': "45 minutes",
      'label': "45 minutes",
    },
    {
      'value': "50 minutes",
      'label': "50 minutes",
    },
    {
      'value': "55 minutes",
      'label': "55 minutes",
    },
    {
      'value': "1 heure",
      'label': "1 heure",
    },
    {
      'value': "2 heures",
      'label': "2 heures",
    },
    {
      'value': "3 heures",
      'label': "3 heures",
    },
    {
      'value': "4 heures",
      'label': "4 heures",
    },
  ];

  List<Map<String, dynamic>> churchs = [];
  bool gettingChurchs = false;

  void onChangedSubject(String text) {
    setState(() {
      subject = text;
    });
  }

  void onChangedTime(String? text) {
    setState(() {
      time = text!;
    });
  }

  void onChangedPeriode(String text) {
    setState(() {
      periode = text;
    });
  }

  void onChangedDesc(String text) {
    setState(() {
      description = text;
    });
  }

  void onChangedChurch(String? text) {
    setState(() {
      churchField = text!;
    });
  }

  void getChurchs() async {
    setState(() {
      gettingChurchs = true;
    });
    try {
      final res = await allApi.getChurch();
      if (res.success == true) {
        for (var i = 0; i < res.churchs.length; i++) {
          final Map<String, dynamic> church = {
            'value': res.churchs[i].id,
            'label': '${res.churchs[i].nom} (${res.churchs[i].pays})'
          };
          setState(() {
            churchs.add(church);
          });
        }
        setState(() {
          gettingChurchs = false;
        });
      }
    } catch (e) {
      setState(() {
        gettingChurchs = false;
      });
    }
  }

  void _send() async {
    if (time.isEmpty) {
      _showDialog("Le temps de prière est requis");
      return;
    }
    if (churchField.isEmpty) {
      _showDialog("La paroisse est requise");
      return;
    }
    setState(() {
      sending = true;
    });
    try {
      final res = await allApi.addPrayer(
          sujet: subject,
          temps: time,
          periode: periode,
          description: description,
          church: churchField);
      if (res.success == true) {
        setState(() {
          sending = false;
          transaction = res.transaction;
        });
        _toggleBottomNavigator(false);

        // _showMessage("L'intention de prière a bien été envoyée");
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const PrayerIntentionsSuccessfullScreen(),
        //     ));

        final paySuccess =
            await pushWebView(res.paymentUrl, res.transaction.id);

        if (paySuccess == true) {
          await pushConfirmationView();
          Navigator.of(context).pop(true);
        }
      }
    } catch (error) {
      setState(() {
        sending = false;
      });
      if (error.toString().toLowerCase().contains('nosuchmethoderror')) {
        return;
      }
      _showDialog(error.toString());
    }
  }

  void _toggleBottomNavigator(bool show) async {
    final BottomTabNavigatorState? bottomTabNavigator =
        context.findAncestorStateOfType<BottomTabNavigatorState>();
    if (bottomTabNavigator != null && show) {
      bottomTabNavigator.showBottomTabNavigator();
    } else if (bottomTabNavigator != null && !show) {
      bottomTabNavigator.hideBottomTabNavigator();
    }
  }

  Future pushWebView(String payLink, String transactionId) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WebViewScreen(),
        settings: RouteSettings(
          arguments: WebViewArguments(
            payLink.replaceAll('.com//', '.com/'),
            "Paiement",
            transactionId,
          ),
        ),
      ),
    );
  }

  Future pushConfirmationView() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => (const PrayerIntentionsSuccessfullScreen()),
        ));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
        titleProp: '',
        context: context,
        backgroundColor: Colors.white,
        showBackButton: true,
      ),
      body: SafeArea(
          child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: RefreshIndicator(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              girlPlanning,
                              height: 200.0,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            const Text(
                              "Intentions de prières",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorGreyBlack,
                                  fontSize: 25.0),
                            ),
                            const SizedBox(height: 15.0),
                            Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    gettingChurchs
                                        ? Loader(size: 10.0)
                                        : SelectFormField(
                                            type: SelectFormFieldType.dropdown,
                                            initialValue: "",
                                            decoration: const InputDecoration(
                                                labelText: "Paroisse",
                                                labelStyle: TextStyle(
                                                    fontSize: 16.0,
                                                    color: colorGreyBlack),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                colorGreyBlack,
                                                            width: 3.0))),
                                            items: churchs,
                                            onChanged: onChangedChurch,
                                            onSaved: onChangedChurch,
                                          ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    InputField(
                                        initialValue: subject,
                                        inputType: TextInputType.text,
                                        labelText: "",
                                        label: "Sujet de prière",
                                        labelColor: colorGreyBlack,
                                        borderColor: colorGreyBlack,
                                        showErrorMessage: true,
                                        // suffixIcon: Image.asset(tick),
                                        onChanged: onChangedSubject),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    SelectFormField(
                                      initialValue: "",
                                      // icon: Image.asset(tick),
                                      // labelText: "Temps de prière",
                                      decoration: const InputDecoration(
                                          // label: Text("Temps de prière"),
                                          labelText: "Temps de prière",
                                          labelStyle: TextStyle(
                                              fontSize: 16.0,
                                              color: colorGreyBlack),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorGreyBlack,
                                                  width: 3.0))),
                                      items: _items,
                                      onChanged: onChangedTime,
                                      onSaved: onChangedTime,
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    InputField(
                                        initialValue: periode,
                                        inputType: TextInputType.text,
                                        labelText:
                                            "Ex: pour la messe du 25/12/2023",
                                        label: "Période de prière",
                                        labelColor: colorGreyBlack,
                                        borderColor: colorGreyBlack,
                                        showErrorMessage: true,
                                        // suffixIcon: Image.asset(tick),
                                        onChanged: onChangedPeriode),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    InputField(
                                        initialValue: description,
                                        inputType: TextInputType.text,
                                        labelText: "",
                                        label: "Description de la prière",
                                        labelColor: colorGreyBlack,
                                        borderColor: colorGreyBlack,
                                        showErrorMessage: true,
                                        maxLines: 3,
                                        // suffixIcon: Image.asset(tick),
                                        onChanged: onChangedDesc),
                                    const SizedBox(
                                      height: 25.0,
                                    ),
                                    CustomButton(
                                        contextProp: context,
                                        loader: sending,
                                        onPressedProp: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _send();
                                          }
                                        },
                                        textProp: "Envoyer"),
                                    const SizedBox(
                                      height: 20.0,
                                    )
                                  ],
                                ))
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
