// ignore_for_file: non_constant_identifier_names, unused_import

import 'package:ediocese_app/constants/colors.dart';
import 'package:flutter/material.dart';

PreferredSize CustomTabAppBar(
    {required BuildContext context,
    Function? onPressBackButton,
    required String title}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(100),
    child: SafeArea(
      child: Container(
        color: colorBluePure,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  TextButton(
                      onPressed: () {
                        onPressBackButton != null
                            ? onPressBackButton()
                            : Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 30.0,
                      )),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      )),
                ],
              ),
              TextButton(
                  onPressed: () {},
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  )),
            ],
          ),
        ),
      ),
    ),
  );
}
