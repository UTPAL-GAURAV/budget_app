import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../../Model/budget.dart';
import '../../Controller/budget_controller.dart';
import '../../Controller/history_controller.dart';


late String _nameBE, _monthlyBudgetBE, _totalBE;
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
          title: const Text("Edit"),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300),
                  child: Column(
                    children: [
                      Align(alignment: Alignment.centerLeft, child: const Text("Budget Name")),
                      TextFormField(
                        initialValue: budget.name,
                        onSaved: (value) => _nameBE = value!,
                      ),
                      Align(alignment: Alignment.centerLeft, child: const Text("Monthly Budget")),
                      TextFormField(
                        initialValue: budget.monthlyBudget.toString(),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _monthlyBudgetBE = value!,
                      ),
                      Align(alignment: Alignment.centerLeft, child: const Text("Total")),
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
                child: const Text("Delete", style: TextStyle(color: Colors.red)),
                onPressed: () {
                  _BEFormKey.currentState!.save();
                  Navigator.of(context, rootNavigator: true).pop();
                  openBudgetDeletePopup(context, index);
                }),
            TextButton(
                child: const Text("Save"),
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
