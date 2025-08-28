// ignore_for_file: non_constant_identifier_names

import 'package:ediocese_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/constants/regex.dart';

Widget InputField(
    {required String initialValue,
    String? labelText,
    String? label,
    required TextInputType inputType,
    dynamic onChanged,
    bool obscureText = false,
    String? valueToCheck,
    bool showErrorMessage = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool autofocus = false,
    int? maxLines = 1,
    bool enabled = true,
    Color? backgroundColor = Colors.white,
    Color? labelColor = Colors.black,
    Color? borderColor,
    int? maxLength,
    double inputRadius = 5.0}) {
  return Column(
    children: <Widget>[
      label != null
          ? Container(
              margin: const EdgeInsets.only(bottom: 5),
              alignment: Alignment.topLeft,
              child: Text(
                label,
                style: TextStyle(fontSize: 17.0, color: labelColor),
              ),
            )
          : Container(),
      TextFormField(
        keyboardType: inputType,
        enabled: enabled,
        maxLines: maxLines,
        autofocus: autofocus,
        obscureText: obscureText,
        maxLength: maxLength,
        initialValue: initialValue,
        onChanged: onChanged,
        validator: (value) {
          if (value!.isEmpty && showErrorMessage == true) {
            return 'Requis';
          } else if (inputType == TextInputType.emailAddress &&
              !emailRegEx.hasMatch(value) &&
              showErrorMessage == true) {
            return 'Adresse e-mail invalide';
          }
          return null;
        },
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: labelText,
          filled: true,
          fillColor: backgroundColor,
          focusedBorder: UnderlineInputBorder(
              borderSide: borderColor != null
                  ? BorderSide(color: borderColor, width: 3.0)
                  : BorderSide.none),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          errorBorder:
              const OutlineInputBorder(borderSide: BorderSide(color: colorRed)),
          labelStyle: const TextStyle(
            fontSize: 16.0,
          ),
          border: UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(inputRadius))),
        ),
      ),
    ],
  );
}
