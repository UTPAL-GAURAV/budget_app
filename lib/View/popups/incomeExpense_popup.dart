import 'package:budget_app/View/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../../Controller/home_controller.dart';
import '../../models/income_expense.dart';

bool _isSwitchedIE = false, _isCheckedIE = false, _incomeExpenseTextIE = false;
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
          title: Text("Income/Expense"),
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
                      Visibility(visible: _incomeExpenseTextIE, child: Text("Expense", style: TextStyle(color: Colors.red))),
                      Visibility(visible: !_incomeExpenseTextIE, child: Text("Income", style: TextStyle(color: Colors.green))),
                    ],
                  ),
                  Align(alignment: Alignment.centerLeft, child: Text("Name")),
                  TextFormField(
                    decoration:
                        const InputDecoration(hintText: " Salary, Netflix"),
                    onSaved: (value) => _nameIE = value!,
                  ),
                  Align(alignment: Alignment.centerLeft, child: Text("Amount")),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: " 0"),
                    onSaved: (value) => _amountIE = value!,
                  ),
                  InputDatePickerFormField(
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2021, 1, 1),
                      lastDate: DateTime.now(),
                      onDateSubmitted: (value){_dateIE = value;},
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Visibility(
                      visible: !_isSwitchedIE,
                      child: CheckboxListTile(
                        key: Key('keyCheckBox'),
                        title: Text("Set in monthly budget"),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _isCheckedIE,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _isCheckedIE = newValue!;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
          actions: [
            TextButton(
                child: Text("Save"),
                onPressed: () {
                  _IEFormKey.currentState!.save();
                  print(!_isSwitchedIE);
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
