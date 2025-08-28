import 'dart:convert';

import 'package:flutter/cupertino.dart';

class PhoneUtils {
  static const String _numberPrefix = '+';

  static String getNormalizedNumber(String phoneNumber) {
    return phoneNumber.startsWith('+')
        ? phoneNumber
        : _numberPrefix + phoneNumber;
  }

  static Future<List<Country?>> fetchCountryData(BuildContext context,
      String jsonFile, List<String> enabledCountries) async {
    var list = await DefaultAssetBundle.of(context)
        .loadString('lib/assets/countries.json');
    List<dynamic> jsonList = json.decode(list);

    List<Country?> countries =
        List<Country?>.generate(jsonList.length, (index) {
      Map<String, String> elem = Map<String, String>.from(jsonList[index]);
      if (enabledCountries.isEmpty ||
          enabledCountries.contains(elem['alpha_2_code']) ||
          enabledCountries.contains(elem['dial_code'])) {
        return Country(
            name: elem['en_short_name'].toString(),
            code: elem['alpha_2_code'].toString(),
            dialCode: elem['dial_code'].toString(),
            flagUri: 'assets/flags/${elem['alpha_2_code']?.toLowerCase()}.png',
            code3: elem['alpha_3_code'].toString());
      } else {
        return null;
      }
    });

    countries.removeWhere((value) => value == null);

    return countries;
  }

  static Country? findCountryFromList(List<Country> list, String phoneNumber) {
    List<Country> foundList = list
        .where((e) => (e.dialCode.length <= phoneNumber.length &&
            e.dialCode == phoneNumber.substring(0, e.dialCode.length)))
        .toList();
    Country? found;

    if (foundList.length > 1) {
      found = foundList[1];
    } else if (foundList.length == 1) {
      found = foundList[0];
    } else {
      found = null;
    }

    return found;
  }
}

class Country {
  final String name;
  final String flagUri;
  final String code;
  final String dialCode;
  final String code3;

  Country(
      {required this.name,
      required this.code,
      required this.flagUri,
      required this.dialCode,
      required this.code3});
}
