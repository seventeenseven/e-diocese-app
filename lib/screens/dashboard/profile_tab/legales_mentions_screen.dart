// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:flutter/material.dart';

class LegalesMentionsScreen extends StatefulWidget {
  const LegalesMentionsScreen({super.key});

  @override
  LegalesMentionsScreenState createState() => LegalesMentionsScreenState();
}

class LegalesMentionsScreenState extends State<LegalesMentionsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
          titleProp: "Mentions légales",
          context: context,
          centerTitle: true,
          showBackButton: true,
          titleColor: colorBlueLittleDark),
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
                    child: const SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 15.0,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    "Entrez l'adresse e-mail que vous avez utilisée pour créer votre compte et nous vous enverrons par e-mail un lien pour réinitialiser votre mot de passe Entrez l'adresse e-mail que vous avez utilisée pour créer votre compte et nous vous enverrons par e-mail un lien pour réinitialiser votre mot de passeEntrez l'adresse e-mail que vous avez utilisée pour créer votre compte et nous vous enverrons par e-mail un lien pour réinitialiser votre mot de passeEntrez l'adresse e-mail que vous avez utilisée pour créer votre compte et nous vous enverrons par e-mail un lien pour réinitialiser votre mot de passe Entrez l'adresse e-mail que vous avez utilisée pour créer votre compte et nous vous enverrons par e-mail un lien pour réinitialiser votre mot de passeEntrez l'adresse e-mail que vous avez utilisée pour créer votre compte et nous vous enverrons par e-mail un lien pour réinitialiser votre mot de passeEntrez l'adresse e-mail que vous avez utilisée pour créer votre compte et nous vous enverrons par e-mail un lien pour réinitialiser votre mot de passeEntrez l'adresse e-mail que vous avez utilisée pour créer votre compte et nous vous enverrons par e-mail un lien pour réinitialiser votre mot de passe Entrez l'adresse e-mail que vous avez utilisée pour créer votre compte et nous vous enverrons par e-mail un lien pour réinitialiser votre mot de passeEntrez l'adresse e-mail que vous avez utilisée pour créer votre compte et nous vous enverrons par e-mail un lien pour réinitialiser votre mot de passeEntrez l'adresse e-mail que vous avez utilisée pour créer votre compte et nous vous enverrons par e-mail un lien pour réinitialiser votre mot de passeEntrez l'adresse e-mail que vous avez utilisée pour créer votre compte et nous vous enverrons par e-mail un lien pour réinitialiser votre mot de passeEntrez l'adresse e-mail que vous avez utilisée pour créer votre compte et nous vous enverrons par e-mail un lien pour réinitialiser votre mot de passe")
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    onRefresh: () async {}))
          ],
        ),
      )),
    );
  }
}
