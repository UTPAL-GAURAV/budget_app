import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Model/income_expense.dart';
import '../../Controller/home_controller.dart';

bool _isSwitchedIE = false, _incomeExpenseTextIE = false;
late String _nameIE, _amountIE;
DateTime _dateIE = DateTime.now();
final _IEFormKey = GlobalKey<FormState>();
int _amountValue = 0;

incomeExpensePopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Form(
        key: _IEFormKey,
        child: AlertDialog(
          title: const Text("Income/Expense"),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 300),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("It's an "),
                      Switch.adaptive(
                          value: _isSwitchedIE,
                          activeColor: Colors.red,
                          activeTrackColor: Colors.redAccent,
                          inactiveThumbColor: Colors.greenAccent,
                          inactiveTrackColor: Colors.green,
                          onChanged: (bool newValue) {
                            setState(() {
                              _isSwitchedIE = newValue;
                              _incomeExpenseTextIE = !_incomeExpenseTextIE;
                            });
                          }),
                      Visibility(
                          visible: _incomeExpenseTextIE,
                          child: const Text("Expense",
                              style: TextStyle(color: Colors.red))),
                      Visibility(
                          visible: !_incomeExpenseTextIE,
                          child: const Text("Income",
                              style: TextStyle(color: Colors.green))),
                    ],
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: " Salary, Netflix", labelText: "Name"),
                    maxLength: 20,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter some text";
                      }
                      return null;
                    },
                    onSaved: (value) => _nameIE = value!,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        hintText: " 0", labelText: "Amount"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a valid amount";
                      }
                      try {
                        _amountValue = int.parse(value);
                      } catch (e) {
                        return "Enter a valid amount";
                      }
                      if(_amountValue > getBankBalance() && _isSwitchedIE == true) {
                        return "Not enough balance";
                      }
                      if (_amountValue > 0 && _amountValue < 99999990) {
                        // Nine Crore..
                        return null;
                      }
                      return "Enter a valid amount";
                    },
                    onSaved: (value) => _amountIE = value!,
                  ),
                  InputDatePickerFormField(
                    fieldLabelText: "Date (mm/dd/yyyy)",
                    initialDate: _dateIE,
                    firstDate: DateTime(2020),
                    lastDate: _dateIE,
                    onDateSaved: (date) {
                      setState(() {
                        _dateIE = date;
                      });
                    },
                  ),
                ],
              ),
            );
          }),
          actions: [
            TextButton(
                child: const Text("Save"),
                onPressed: () {
                  _IEFormKey.currentState!.save();
                  if (_IEFormKey.currentState!.validate()) {
                    final newIETransaction = IncomeExpense(
                        !_isSwitchedIE, _nameIE, int.parse(_amountIE), _dateIE);
                    addNewIncomeExpense(newIETransaction);
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                }),
          ],
        ),
      );
    },
  );
}
