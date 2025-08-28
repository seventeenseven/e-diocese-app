// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:ediocese_app/components/loader.dart';
import 'package:ediocese_app/constants/colors.dart';

Widget CustomButton(
    {required BuildContext contextProp,
    required Function onPressedProp,
    required String textProp,
    bool disabledProp = false,
    bool loader = false,
    Color color = colorBlueLittleDark,
    double borderRadius = 10.0,
    double? width,
    Color textColor = Colors.white,
    double fontSize = 17.0,
    Widget? icon,
    double paddingVertical = 10.0}) {
  return IgnorePointer(
      ignoring: disabledProp,
      child: Opacity(
        opacity: disabledProp ? 0.5 : 1,
        child: TextButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(vertical: paddingVertical)),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                Radius.circular(borderRadius),
              ))),
              backgroundColor: MaterialStateProperty.all(color)),
          onPressed: () {
            onPressedProp();
          },
          child: Container(
              alignment: Alignment.center,
              height: 30.0,
              width: width ?? MediaQuery.of(contextProp).size.width,
              child: loader
                  ? Loader(size: 15, color: Colors.white)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (icon != null)
                          Container(
                            margin: const EdgeInsets.only(right: 15.0),
                            child: icon,
                          ),
                        Text(textProp,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Helvetica Neue",
                              fontSize: fontSize,
                              color: textColor,
                            ))
                      ],
                    )),
        ),
      ));
}
