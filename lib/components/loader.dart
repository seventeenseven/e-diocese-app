// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:ediocese_app/constants/colors.dart';

Widget Loader({
  double size = 20.0,
  Color color = colorBlue,
  double strokeWidth = 3,
}) {
  return SizedBox(
    height: size,
    width: size,
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(color),
      strokeWidth: strokeWidth,
    ),
  );
}
