// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:ediocese_app/constants/colors.dart';

Widget CustomDialog({
  required BuildContext contextProp,
  String? titleProp,
  required String messageProp,
  String? positiveButtonTextProp,
  bool? showNegativeButtonProp,
  String? negativeButtonTextProp,
  Function? positiveButtonOnPressProp,
  Function? negativeButtonOnPressProp,
  Widget? iconProp,
}) {
  return AlertDialog(
    title: Text(titleProp ?? 'E-Diocese'),
    content: Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        iconProp != null
            ? Container(
                padding: const EdgeInsets.only(bottom: 15), child: iconProp)
            : Container(),
        Text(messageProp),
      ],
    )),
    actions: <Widget>[
      showNegativeButtonProp != null && showNegativeButtonProp
          ? TextButton(
              child: Text(negativeButtonTextProp ?? 'Annuler'),
              onPressed: () {
                negativeButtonOnPressProp != null
                    ? negativeButtonOnPressProp()
                    : Navigator.of(contextProp).pop();
              },
            )
          : Container(),
      TextButton(
        child: Text(
          positiveButtonTextProp ?? 'Ok',
          style: const TextStyle(color: colorOrange),
        ),
        onPressed: () {
          positiveButtonOnPressProp != null
              ? positiveButtonOnPressProp()
              : Navigator.of(contextProp).pop();
        },
      ),
    ],
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0))),
  );
}
