import 'package:budget_app/models/loanlend.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../../Controller/home_controller.dart';


late String _amountLLE;
int _remainingAmount = 0, _newRemainingAmount = 0;
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
          title: Text("Loan/Lend (Update)"),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(getLoanLendText(loanLend.lenderBorrower) + loanLend.name),
                          Text("Rs." + loanLend.amount.toString()),
                        ],
                      ),
                      Align(alignment: Alignment.centerLeft, child: Text("Returned amount")),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: " 0"),
                        onSaved: (value) => _amountLLE = value!,
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
                  _newRemainingAmount = loanLend.amount - int.parse(_amountLLE);
                  final updateLLTransaction = LoanLend(loanLend.lenderBorrower, _newRemainingAmount, loanLend.name, loanLend.date, false);
                  returnLoanLend(index, updateLLTransaction, int.parse(_amountLLE));
                  Navigator.of(context, rootNavigator: true).pop();
                }),
          ],
        ),
      );
    },
  );
}
