import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../../Model/loanlend.dart';
import '../../Controller/home_controller.dart';



late String _amountLLE;
int _newRemainingAmount = 0, _amountValue = 0;
DateTime _dateLLE = DateTime.now();
final _LLEFormKey = GlobalKey<FormState>();

final _loanlendBox = Hive.box('loanlend');

loanLendEditPopup(BuildContext context, int index) {
  final loanLend = _loanlendBox.getAt(index) as LoanLend;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Form(
        key: _LLEFormKey,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(22.0))),
          title: const Text("Loan/Lend (Update)"),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(getLoanLendText(loanLend.lenderBorrower) + loanLend.name),
                          Text("${getCurrencySymbol()} " + loanLend.amount.toString()),
                        ],
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: " 0", labelText: "Returned amount"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {    // Setting value = 0, if user didnot enter
                            _amountLLE = "0";
                            return null;
                          }
                          try {
                            _amountValue = int.parse(value);
                          } catch (e) {
                            return "Enter a valid amount";
                          }
                          if(_amountValue > loanLend.amount) {
                            return "Excess return amount";
                          }
                          if(_amountValue > getBankBalance() && loanLend.lenderBorrower == false) {
                            return "Not enough balance";
                          }
                          if (_amountValue >= 0 && _amountValue < 99999990) {
                            // Nine Crore..
                            return null;
                          }
                          return "Enter a valid amount";
                        },
                        onSaved: (value) => _amountLLE = value!,
                      ),
                      InputDatePickerFormField(
                        fieldLabelText: "Change Due Date (mm/dd/yyyy)",
                        initialDate: loanLend.date,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2080),
                        onDateSaved: (date){ setState(() { _dateLLE = date;}); },
                      ),
                    ],
                  ),
                );
              }),
          actions: [
            TextButton(
                child: Text("Save"),
                onPressed: () {
                  _LLEFormKey.currentState!.save();
                  if(_LLEFormKey.currentState!.validate()) {
                    _newRemainingAmount = loanLend.amount - int.parse(_amountLLE);
                    final updateLLTransaction = LoanLend(loanLend.lenderBorrower, _newRemainingAmount, loanLend.name, _dateLLE, false);
                    returnLoanLend(index, updateLLTransaction, int.parse(_amountLLE));
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                }),
          ],
        ),
      );
    },
  );
}
