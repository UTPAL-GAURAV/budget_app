//
// import 'package:budget_app/models/budget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../controllers/budget_controller.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// bool _isSwitchedNB = false, _lendBorrowTextNB = false;
// late String _nameNB, _amountNB;
// final _NBFormKey = GlobalKey<FormState>();
//
// selectCurrenciesPopup() {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return Form(
//         key: _NBFormKey,
//         child: AlertDialog(
//           title: Text("Select Currency"),
//           content: StatefulBuilder(
//               builder: (BuildContext context, StateSetter setState) {
//                 return ConstrainedBox(
//                   constraints: BoxConstraints(maxHeight: 500),
//                   child: Column(
//                     children: [
//
//                     ],
//                   ),
//                 );
//               }),
//           actions: [
//             TextButton(
//                 child: Text("Cancel"),
//                 onPressed: () {
//                   Navigator.of(context, rootNavigator: true).pop();
//                 }),
//           ],
//         ),
//       );
//     },
//   );
// }
