import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Model/loanlend.dart';
import '../../Controller/home_controller.dart';



bool _isSwitchedLL = false, _lendBorrowTextLL = false;
late String _nameLL, _amountLL;
DateTime _dateLL = DateTime.now();
final _LLFormKey = GlobalKey<FormState>();
int _amountValue = 0;

loanLendPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Form(
        key: _LLFormKey,
        child: AlertDialog(
          title: const Text("Loan/Lend"),
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
                          Visibility(visible: _lendBorrowTextLL, child: const Text("Borrower", style: TextStyle(color: Colors.red))),
                          Visibility(visible: !_lendBorrowTextLL, child: const Text("Lender", style: TextStyle(color: Colors.green))),
                        ],
                      ),
                      TextFormField(
                        decoration:
                        const InputDecoration(hintText: " John", labelText: "Name"),
                        maxLength: 15,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter some text";
                          }
                          return null;
                        },
                        onSaved: (value) => _nameLL = value!,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: " 0", labelText: "Amount"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {    // Setting value = 0, if user didnot enter
                            return "Enter a valid amount";
                          }
                          try {
                            _amountValue = int.parse(value);
                          } catch (e) {
                            return "Enter a valid amount";
                          }
                          if(_amountValue > getBankBalance() && _isSwitchedLL == false) {
                            return "Not enough balance";
                          }
                          if (_amountValue > 0 && _amountValue < 99999990) {
                            // Nine Crore..
                            return null;
                          }
                          return "Enter a valid amount";
                        },
                        onSaved: (value) => _amountLL = value!,
                      ),
                      InputDatePickerFormField(
                        fieldLabelText: "Due Date (mm/dd/yyyy)",
                        initialDate: _dateLL,
                        firstDate: _dateLL,
                        lastDate: DateTime(2080),
                        onDateSaved: (date){ setState(() { _dateLL = date;}); },
                      ),
                    ],
                  ),
                );
              }),
          actions: [
            TextButton(
                child: const Text("Save"),
                onPressed: () {
                  _LLFormKey.currentState!.save();
                  if(_LLFormKey.currentState!.validate()) {
                    final newLLTransaction = LoanLend(!_isSwitchedLL, int.parse(_amountLL), _nameLL, _dateLL, false);
                    addNewLoanLend(newLLTransaction);
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                }),
          ],
        ),
      );
    },
  );
}
