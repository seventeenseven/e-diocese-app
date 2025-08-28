// ignore_for_file: non_constant_identifier_names

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

AppBar TabAppBar({
  required String titleProp,
  bool showBackButton = false,
  List<Widget>? actionsProp,
  Color? backgroundColor,
  required BuildContext context,
  Color? backButtonColor,
  Color? titleColor,
  double titleFontSize = 16.0,
  bool centerTitle = false,
  IconData? backButtonIcon,
  double paddingLeft = 14.0,
  Function? onPressedBackButton,
}) {
  return AppBar(
    title: Padding(
      padding: EdgeInsets.only(left: showBackButton ? 0 : paddingLeft),
      child: Text(titleProp,
          style: TextStyle(
              fontFamily: 'Helvetica Neue',
              fontSize: titleFontSize,
              height: 23 / 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.15,
              color: titleColor ?? const Color.fromRGBO(0, 0, 0, 0.87))),
    ),
    backgroundColor: backgroundColor ?? Colors.white,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    //brightness: Brightness.light, //is deprecated
    elevation: 0.0,
    key: const Key('app-bar'),
    actions: actionsProp,
    leading: showBackButton
        ? TextButton(
            onPressed: () {
              onPressedBackButton != null
                  ? onPressedBackButton()
                  : Navigator.pop(context);
            },
            child: Icon(
              backButtonIcon ?? Icons.arrow_back,
              size: 35.0,
              color: backButtonColor ?? Colors.black,
            ))
        : null,
    centerTitle: centerTitle,
  );
}
