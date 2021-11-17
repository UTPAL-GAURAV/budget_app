import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Model/income_expense.dart';
import '../../Controller/home_controller.dart';



bool _isSwitchedIE = false, _incomeExpenseTextIE = false;
late String _nameIE, _amountIE;
DateTime _dateIE = DateTime.now();
final _IEFormKey = GlobalKey<FormState>();

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
                      Visibility(visible: _incomeExpenseTextIE, child: const Text("Expense", style: TextStyle(color: Colors.red))),
                      Visibility(visible: !_incomeExpenseTextIE, child: const Text("Income", style: TextStyle(color: Colors.green))),
                    ],
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(hintText: " Salary, Netflix", labelText: "Name"),
                    onSaved: (value) => _nameIE = value!,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: " 0", labelText: "Amount"),
                    onSaved: (value) => _amountIE = value!,
                  ),
                  InputDatePickerFormField(
                      fieldLabelText: "Due Date (mm/dd/yyyy)",
                      initialDate: _dateIE,
                      firstDate: DateTime(2020),
                      lastDate: _dateIE,
                      onDateSaved: (date){ setState(() { _dateIE = date;}); },
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
                  final newIETransaction = IncomeExpense(!_isSwitchedIE, _nameIE, int.parse(_amountIE), _dateIE);
                  addNewIncomeExpense(newIETransaction);
                  Navigator.of(context, rootNavigator: true).pop();
                }),
          ],
        ),
      );
    },
  );
}
