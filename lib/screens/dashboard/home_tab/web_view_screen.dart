import 'dart:async';

import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/components/loader.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/schemas/web_view_screen_arguments.dart';
import 'package:ediocese_app/screens/dashboard/bottom_tab_navigator.dart';
import 'package:ediocese_app/services/all_api.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  Timer? timer;
  final AllApi allApi = container<AllApi>();
  late final WebViewController _webViewController;
  bool isLoading = true; // Pour gérer l'affichage du Loader

  @override
  void initState() {
    super.initState();

    // Initialisation du contrôleur WebView
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            setState(() {
              isLoading = false; // Cache le loader une fois la page chargée
            });
          },
        ),
      );

    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 350), (time) {
      checkTransactionStatus();
    });
  }

  void checkTransactionStatus() async {
    final arguments = ModalRoute.of(context)!.settings.arguments as WebViewArguments;
    try {
      final res = await allApi.checkTransaction(arguments.transactionId);
      if (res.status == "accepted") {
        Navigator.of(context).pop(true);
      } else if (res.status == "refused") {
        _showDialog("Échec de paiement");
        _toggleBottomNavigator(true);
        Navigator.of(context).pop();
      }
    } catch (error) {
      print(error.toString());
    }
  }

  void _toggleBottomNavigator(bool show) {
    final BottomTabNavigatorState? bottomTabNavigator =
    context.findAncestorStateOfType<BottomTabNavigatorState>();
    if (bottomTabNavigator != null) {
      show ? bottomTabNavigator.showBottomTabNavigator() : bottomTabNavigator.hideBottomTabNavigator();
    }
  }

  void _showDialog(String errorMessage) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomDialog(
          contextProp: context,
          messageProp: errorMessage,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as WebViewArguments;

    return Scaffold(
      appBar: TabAppBar(
        titleProp: arguments.title,
        context: context,
        centerTitle: true,
        showBackButton: true,
        onPressedBackButton: () {
          _toggleBottomNavigator(true);
          Navigator.pop(context);
        },
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _webViewController
              ..loadRequest(Uri.parse(arguments.url)), // Charger l'URL
          ),
          if (isLoading)
             Center(child: Loader()), // Afficher le loader pendant le chargement
        ],
      ),
    );
  }
}
