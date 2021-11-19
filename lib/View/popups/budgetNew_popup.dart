import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Model/budget.dart';
import '../../Controller/budget_controller.dart';

bool _isSwitchedNB = false, _lendBorrowTextNB = false;
late String _nameNB, _amountNB;
final _NBFormKey = GlobalKey<FormState>();
int _amountValue = 0;

newBudgetPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Form(
        key: _NBFormKey,
        child: AlertDialog(
          title: const Text("Add New Budget"),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300),
                  child: Column(
                    children: [
                      TextFormField(
                        maxLength: 12,
                        decoration:
                        const InputDecoration(hintText: " Clothes, Food", labelText: "Budget name"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter some text";
                          }
                          return null;
                        },
                        onSaved: (value) => _nameNB = value!,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: " 0", labelText: "Monthly budget"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {    // Setting value = 0, if user didnot enter
                            return "Enter a valid amount";
                          }
                          try {
                            _amountValue = int.parse(value);
                          } catch (e) {
                            return "Enter a valid amount";
                          }
                          if (_amountValue >= 0 && _amountValue < 99999990) {
                            // Nine Crore..
                            return null;
                          }
                          return "Enter a valid amount";
                        },
                        onSaved: (value) => _amountNB = value!,
                      ),
                      Row(
                        children: [
                          const Text("It's an "),
                          Switch(
                              value: _isSwitchedNB,
                              activeColor: Colors.red,
                              activeTrackColor: Colors.redAccent,
                              inactiveThumbColor: Colors.greenAccent,
                              inactiveTrackColor: Colors.green,
                              onChanged: (bool newValue) {
                                setState(() {
                                  _isSwitchedNB = newValue;
                                  _lendBorrowTextNB = !_lendBorrowTextNB;
                                });
                              }),
                          Visibility(visible: _lendBorrowTextNB, child: const Text("Expense \n (Food, Shopping)", style: TextStyle(color: Colors.red))),
                          Visibility(visible: !_lendBorrowTextNB, child: const Text("Investment \n (Equity, Crypto)", style: TextStyle(color: Colors.green))),
                        ],
                      ),
                    ],
                  ),
                );
              }),
          actions: [
            TextButton(
                child: const Text("Save"),
                onPressed: () {
                  _NBFormKey.currentState!.save();
                  final _newNBTransaction = Budget(_nameNB, int.parse(_amountNB), 0, int.parse(_amountNB), !_isSwitchedNB);
                  addNewBudget(_newNBTransaction);
                  Navigator.of(context, rootNavigator: true).pop();
                }),
          ],
        ),
      );
    },
  );
}
