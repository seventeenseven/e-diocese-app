// //library international_phone_input;
// // ignore_for_file: implementation_imports, import_of_legacy_library_into_null_safe
//
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// import 'package:ediocese_app/components/utils/phone-utils.dart';
// import 'package:ediocese_app/constants/colors.dart';
//
// class Country {
//   final String name;
//   final String flagUri;
//   final String code;
//   final String dialCode;
//   final String code3;
//
//   Country(
//       {required this.name,
//       required this.code,
//       required this.flagUri,
//       required this.dialCode,
//       required this.code3});
// }
//
// class InternationalPhoneInput extends StatefulWidget {
//   final void Function(
//           String phoneNumber, bool hasError, String isoCode, String countryCode)
//       onPhoneNumberChange;
//   final String initialPhoneNumber;
//   final String initialSelection;
//   final String? errorText;
//   final String? hintText;
//   final String? labelText;
//   final int? errorMaxLines;
//   final List<String> enabledCountries;
//
//   const InternationalPhoneInput(
//       {required this.onPhoneNumberChange,
//       required this.initialPhoneNumber,
//       required this.initialSelection,
//       this.errorText,
//       this.hintText,
//       this.labelText,
//       this.enabledCountries = const [],
//       this.errorMaxLines});
//
//   @override
//   _InternationalPhoneInputState createState() =>
//       _InternationalPhoneInputState();
// }
//
// class _InternationalPhoneInputState extends State<InternationalPhoneInput> {
//   Country? selectedItem;
//   List<Country?> itemList = [];
//
//   String? errorText;
//   String? hintText;
//   String? labelText;
//
//   int? errorMaxLines;
//
//   bool hasError = false;
//
//   bool loading = true;
//
//   _InternationalPhoneInputState();
//
//   final phoneTextController = TextEditingController();
//
//   @override
//   void initState() {
//     errorText = widget.errorText ?? "Numéro invalide";
//     hintText = widget.hintText ?? '';
//     labelText = widget.labelText;
//     errorMaxLines = widget.errorMaxLines;
//     phoneTextController.text = widget.initialPhoneNumber;
//
//     _fetchCountryData().then((list) {
//       Country? preSelectedItem;
//
//       if (widget.initialSelection != null) {
//         preSelectedItem = list.firstWhere(
//             (e) =>
//                 (e?.code.toUpperCase() ==
//                     widget.initialSelection.toUpperCase()) ||
//                 (e?.dialCode == widget.initialSelection.toString()),
//             orElse: () => list[0]);
//       } else {
//         preSelectedItem = list[0];
//       }
//
//       setState(() {
//         itemList = list;
//         selectedItem = preSelectedItem;
//         phoneTextController.text = preSelectedItem!.dialCode.substring(1);
//         loading = false;
//       });
//     });
//
//     super.initState();
//   }
//
//   @visibleForTesting
//   Country? findCountryFromList(List<Country> list, String phoneNumber) {
//     List<Country> foundList = list
//         .where((e) => (e != null &&
//             e.dialCode.length <= phoneNumber.length &&
//             e.dialCode == phoneNumber.substring(0, e.dialCode.length)))
//         .toList();
//     Country? found;
//
//     if (foundList.length > 1) {
//       found = foundList[1];
//     } else if (foundList.length == 1) {
//       found = foundList[0];
//     } else {
//       found = null;
//     }
//
//     return found;
//   }
//
//   bool isNumberParsable() {
//     String phoneNumber =
//         PhoneUtils.getNormalizedNumber(phoneTextController.text);
//     return selectedItem != null &&
//         phoneNumber != null &&
//         phoneNumber.isNotEmpty &&
//         phoneNumber.length > selectedItem!.dialCode.length;
//   }
//
//   _validatePhoneNumber() async {
//     Country? found = findCountryFromList(itemList as List<Country>,
//         PhoneUtils.getNormalizedNumber(phoneTextController.text));
//
//     if (found == null ||
//         selectedItem == null ||
//         (selectedItem?.dialCode != found.dialCode)) {
//       setState(() {
//         selectedItem = found!;
//       });
//     }
//
//     String phoneNumber =
//         PhoneUtils.getNormalizedNumber(phoneTextController.text);
//
//     if (isNumberParsable()) {
//       PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(
//           phoneNumber.substring(selectedItem!.dialCode.length),
//           selectedItem!.code);
//
//       String parsableNumber = number.parseNumber();
//
//       '''PhoneService.parsePhoneNumber(
//               phoneNumber.substring(selectedItem!.dialCode.length),
//               selectedItem?.code)
//           .then((isValid) {
//         if (selectedItem?.code == 'CI') {
//           if (phoneNumber.substring(selectedItem!.dialCode.length).length !=
//               10) {
//             setState(() {
//               hasError = !isValid;
//             });
//           } else {
//             setState(() {
//               hasError = isValid;
//             });
//           }
//         } else {
//           setState(() {
//             hasError = !isValid;
//           });
//         }
//
//         if (widget.onPhoneNumberChange != null) {
//           widget.onPhoneNumberChange(phoneNumber.substring(1), hasError,
//               selectedItem!.dialCode.substring(1), selectedItem!.code);
//         }
//       });
//     ''';
//     }
//   }
//
//   Future<List<Country?>> _fetchCountryData() async {
//     var list = await DefaultAssetBundle.of(context)
//         .loadString('lib/assets/countries.json');
//     List<dynamic> jsonList = json.decode(list);
//
//     List<Country?> countries =
//         List<Country?>.generate(jsonList.length, (index) {
//       Map<String, String> elem = Map<String, String>.from(jsonList[index]);
//       if (widget.enabledCountries.isEmpty) {
//         return Country(
//             name: elem['en_short_name'].toString(),
//             code: elem['alpha_2_code'].toString(),
//             dialCode: elem['dial_code'].toString(),
//             flagUri: 'assets/flags/${elem['alpha_2_code']?.toLowerCase()}.png',
//             code3: elem['alpha_3_code'].toString());
//       } else if (widget.enabledCountries.contains(elem['alpha_2_code']) ||
//           widget.enabledCountries.contains(elem['dial_code'])) {
//         return Country(
//             name: elem['en_short_name'].toString(),
//             code: elem['alpha_2_code'].toString(),
//             dialCode: elem['dial_code'].toString(),
//             flagUri: 'assets/flags/${elem['alpha_2_code']?.toLowerCase()}.png',
//             code3: elem['alpha_3_code'].toString());
//       } else {
//         return null;
//       }
//     });
//
//     countries.removeWhere((value) => value == null);
//
//     return countries;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: !loading
//             ? Container(
//                 decoration: BoxDecoration(
//                     border: Border.all(color: colorBlueSecondary),
//                     borderRadius: BorderRadius.circular(5)),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     SizedBox(
//                         height: 50,
//                         child: DropdownButtonHideUnderline(
//                           child: Padding(
//                               padding: const EdgeInsets.only(
//                                   right: 10, left: 10, top: 2),
//                               child: Stack(children: [
//                                 selectedItem == null
//                                     ? Positioned(
//                                         top: 12,
//                                         child: Row(
//                                           children: <Widget>[
//                                             Container(
//                                                 width: 39,
//                                                 padding: const EdgeInsets.only(
//                                                     left: 15),
//                                                 child: const Text(
//                                                   '-',
//                                                   style:
//                                                       TextStyle(fontSize: 16.0),
//                                                 )),
//                                             Container(
//                                               width: 34,
//                                               height: 24,
//                                               color: const Color(0xcccccccc),
//                                             ),
//                                           ],
//                                         ))
//                                     : Container(),
//                                 DropdownButton<Country>(
//                                   value: selectedItem,
//                                   icon: Container(),
//                                   onChanged: (Country? newValue) {
//                                     if (newValue != null) {
//                                       phoneTextController.text =
//                                           newValue.dialCode.substring(1);
//                                       setState(() {
//                                         selectedItem = newValue;
//                                       });
//                                     }
//                                   },
//                                   items: itemList
//                                       .map<DropdownMenuItem<Country>>(
//                                           (Country? value) {
//                                     return DropdownMenuItem<Country>(
//                                       value: value,
//                                       child: Container(
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: <Widget>[
//                                             value != null
//                                                 ? Row(
//                                                     children: <Widget>[
//                                                       SizedBox(
//                                                           width: 39,
//                                                           child: Text(
//                                                             value.code3,
//                                                             style:
//                                                                 const TextStyle(
//                                                                     fontSize:
//                                                                         16.0),
//                                                           )),
//                                                       Container(
//                                                           decoration: BoxDecoration(
//                                                               border: Border.all(
//                                                                   color: const Color(
//                                                                       0xeeeeeeee)),
//                                                               color:
//                                                                   Colors.white),
//                                                           child: Image.asset(
//                                                             value.flagUri,
//                                                             width: 34.0,
//                                                             height: 24,
//                                                             package:
//                                                                 'international_phone_input',
//                                                           )),
//                                                     ],
//                                                   )
//                                                 : Container(),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ])),
//                         )),
//                     Flexible(
//                         child: Container(
//                             height: 50,
//                             padding: const EdgeInsets.only(top: 6, right: 2),
//                             decoration: const BoxDecoration(
//                                 border: Border(
//                                     left: BorderSide(
//                                         width: 1, color: colorBlueSecondary))),
//                             child: TextField(
//                               keyboardType: TextInputType.phone,
//                               onChanged: (text) {
//                                 _validatePhoneNumber();
//                               },
//                               style: const TextStyle(fontSize: 18),
//                               controller: phoneTextController,
//                               decoration: InputDecoration(
//                                 enabledBorder: const UnderlineInputBorder(
//                                   borderSide: BorderSide.none,
//                                 ),
//                                 contentPadding:
//                                     const EdgeInsets.only(bottom: 10, left: 7),
//                                 labelText: labelText,
//                                 prefixText: '+',
//                                 prefixStyle: const TextStyle(
//                                     color: Colors.black, fontSize: 17),
//                               ),
//                             )))
//                   ],
//                 ))
//             : const Text(
//                 "Chargement...",
//                 style: TextStyle(fontSize: 16.0),
//               ));
//   }
// }
