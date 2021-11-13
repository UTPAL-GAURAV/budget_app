import 'package:budget_app/Controller/budget_controller.dart';
import 'package:budget_app/Controller/history_controller.dart';
import 'package:budget_app/models/budget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';


late String _amountBE, _nameBE, _monthlyBudgetBE, _totalBE;
final _BEFormKey = GlobalKey<FormState>();

final _budgetBox = Hive.box('budget');

budgetEditPopup(BuildContext context, int index) {
  final budget = _budgetBox.getAt(index) as Budget;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Form(
        key: _BEFormKey,
        child: AlertDialog(
          title: Text("Edit"),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300),
                  child: Column(
                    children: [
                      Align(alignment: Alignment.centerLeft, child: Text("Budget Name")),
                      TextFormField(
                        initialValue: budget.name,
                        onSaved: (value) => _nameBE = value!,
                      ),
                      Align(alignment: Alignment.centerLeft, child: Text("Monthly Budget")),
                      TextFormField(
                        initialValue: budget.monthlyBudget.toString(),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _monthlyBudgetBE = value!,
                      ),
                      Align(alignment: Alignment.centerLeft, child: Text("Total")),
                      TextFormField(
                        initialValue: budget.total.toString(),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _totalBE = value!,
                      ),
                    ],
                  ),
                );
              }),
          actions: [
            TextButton(
                child: Text("Delete", style: TextStyle(color: Colors.red)),
                onPressed: () {
                  _BEFormKey.currentState!.save();
                  Navigator.of(context, rootNavigator: true).pop();
                  openBudgetDeletePopup(context, index);
                }),
            TextButton(
                child: Text("Save"),
                onPressed: () {
                  _BEFormKey.currentState!.save();
                  final updateBUTransaction = Budget(_nameBE, int.parse(_totalBE), budget.used, int.parse(_monthlyBudgetBE), budget.investmentExpense);
                  updateBudget(index, updateBUTransaction, 0, "");
                  changeNameInHistory(budget.name, _nameBE);
                  Navigator.of(context, rootNavigator: true).pop();
                }),
          ],
        ),
      );
    },
  );
}
