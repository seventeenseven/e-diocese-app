// ignore_for_file: use_build_context_synchronously, import_of_legacy_library_into_null_safe

import 'package:ediocese_app/components/custom_button.dart';
import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/components/loader.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/constants/img_urls.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/schemas/price/price.dart';
import 'package:ediocese_app/models/schemas/priere/priere.dart';
import 'package:ediocese_app/models/schemas/transaction/transaction.dart';
import 'package:ediocese_app/models/schemas/web_view_screen_arguments.dart';
import 'package:ediocese_app/screens/dashboard/bottom_tab_navigator.dart';
import 'package:ediocese_app/screens/dashboard/home_tab/prayer_intentions_successful_screen.dart';
import 'package:ediocese_app/screens/dashboard/home_tab/web_view_screen.dart';
import 'package:ediocese_app/services/all_api.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:select_form_field/select_form_field.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  DonationScreenState createState() => DonationScreenState();
}

class DonationScreenState extends State<DonationScreen> {
  @override
  void initState() {
    _getPrices();
    _getChurchs();
    super.initState();
  }

  AllApi allApi = container<AllApi>();

  final _formKey = GlobalKey<FormState>();

  String price = "";

  bool sending = false;

  bool gettingPrieres = false;
  List<Priere> prieres = [];

  Transaction? transaction;

  List<Price> prices = [];
  bool gettingPrices = false;

  List<Map<String, dynamic>> pricesMap = [];

  String churchField = "";

  List<Map<String, dynamic>> churchs = [];
  bool gettingChurchs = false;

  void onChangedChurch(String? text) {
    setState(() {
      churchField = text!;
    });
  }

  void onChangedPrice(String? text) {
    setState(() {
      price = text!;
    });
  }

  void _getChurchs() async {
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

  void _getPrices() async {
    setState(() {
      gettingPrices = true;
    });

    try {
      final res = await allApi.getPrices();
      if (res.prices.isNotEmpty) {
        for (var i = 0; i < res.prices.length; i++) {
          Map<String, dynamic> priceMap = {
            'value': res.prices[i].value,
            'label': "${res.prices[i].value} CFA"
          };
          pricesMap.add(priceMap);
        }
        setState(() {
          gettingPrices = false;
        });
      }
    } catch (e) {
      setState(() {
        gettingPrices = false;
      });
      _showDialog(e.toString());
    }
  }

  void _send() async {
    if (churchField.isEmpty) {
      _showDialog("La paroisse est requise");
      return;
    }
    if (price.isEmpty) {
      _showDialog("Le montant est requis");
      return;
    }
    setState(() {
      sending = true;
    });
    try {
      final res = await allApi.sendDonation(int.parse(price), churchField);
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
                              height: 150.0,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            const Text(
                              "Faire un don",
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
                                    SelectFormField(
                                      initialValue: "",
                                      // icon: Image.asset(tick),
                                      // labelText: "Temps de prière",
                                      decoration: const InputDecoration(
                                          // label: Text("Temps de prière"),
                                          labelText: "Montant",
                                          labelStyle: TextStyle(
                                              fontSize: 16.0,
                                              color: colorGreyBlack),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorGreyBlack,
                                                  width: 3.0))),
                                      items: pricesMap,
                                      onChanged: onChangedPrice,
                                      onSaved: onChangedPrice,
                                    ),
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
