import 'package:budget_app/models/loanlend.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Controller/home_controller.dart';

bool _isSwitchedLL = false, _lendBorrowTextLL = false;
late String _nameLL, _amountLL;
DateTime _dateLL = DateTime.now();
final _LLFormKey = GlobalKey<FormState>();

loanLendPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Form(
        key: _LLFormKey,
        child: AlertDialog(
          title: Text("Loan/Lend"),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("I am "),
                          Switch(
                              value: _isSwitchedLL,
                              activeColor: Colors.red,
                              activeTrackColor: Colors.redAccent,
                              inactiveThumbColor: Colors.greenAccent,
                              inactiveTrackColor: Colors.green,
                              onChanged: (bool newValue) {
                                setState(() {
                                  _isSwitchedLL = newValue;
                                  _lendBorrowTextLL = !_lendBorrowTextLL;
                                });
                              }),
                          Visibility(visible: _lendBorrowTextLL, child: Text("Borrower", style: TextStyle(color: Colors.red))),
                          Visibility(visible: !_lendBorrowTextLL, child: Text("Lender", style: TextStyle(color: Colors.green))),
                        ],
                      ),
                      Align(alignment: Alignment.centerLeft, child: Text("Name")),
                      TextFormField(
                        decoration:
                        const InputDecoration(hintText: " John"),
                        onSaved: (value) => _nameLL = value!,
                      ),
                      Align(alignment: Alignment.centerLeft, child: Text("Amount")),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: " 0"),
                        onSaved: (value) => _amountLL = value!,
                      ),
                      InputDatePickerFormField(
                        fieldLabelText: "Due Date",
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2060, 12, 30),
                        onDateSubmitted: (value){_dateLL = value;},
                      ),
                    ],
                  ),
                );
              }),
          actions: [
            TextButton(
                child: Text("Save"),
                onPressed: () {
                  _LLFormKey.currentState!.save();
                  final newLLTransaction = LoanLend(!_isSwitchedLL, int.parse(_amountLL), _nameLL, _dateLL, false);
                  addNewLoanLend(newLLTransaction);
                  Navigator.of(context, rootNavigator: true).pop();
                }),
          ],
        ),
      );
    },
  );
}
