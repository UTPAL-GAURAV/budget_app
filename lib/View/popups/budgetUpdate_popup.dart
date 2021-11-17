import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../../Model/budget.dart';
import '../../View/pages/budgetHistory_page.dart';
import '../../Controller/budget_controller.dart';



late String _amountBU, _nameBU;
int _newUsed = 0;
final _BUFormKey = GlobalKey<FormState>();

final _budgetBox = Hive.box('budget');

budgetUpdatePopup(BuildContext context, int index) {
  final budget = _budgetBox.getAt(index) as Budget;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Form(
        key: _BUFormKey,
        child: AlertDialog(
          title: const Text("New Budget Expense"),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300),
                  child: Column(
                    children: [
                      Text("Total Budget: Rs." + budget.total.toString()),
                      Text("Used        : Rs." + budget.used.toString()),
                      TextFormField(
                        decoration:
                        const InputDecoration(hintText: " New Sports Shoe", labelText: "Name"),
                        onSaved: (value) => _nameBU = value!,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: " 0", labelText: "Amount"),
                        onSaved: (value) => _amountBU = value!,
                      ),
                    ],
                  ),
                );
              }),
          actions: [
            TextButton(
                child: const Text("Edit"),
                onPressed: () {
                  _BUFormKey.currentState!.save();
                  Navigator.of(context, rootNavigator: true).pop();
                  openBudgetEditPopup(context, index);
                }),
            TextButton(
                child: const Text("Track"),
                onPressed: () {
                  _BUFormKey.currentState!.save();
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BudgetHistoryPage(index: index,)));
                }),
            TextButton(
                child: const Text("Save"),
                onPressed: () {
                  _BUFormKey.currentState!.save();
                  _newUsed = budget.used + int.parse(_amountBU);
                  _nameBU = budget.name + "  (" + _nameBU + ")";
                  final updateBUTransaction = Budget(budget.name, budget.total, _newUsed, budget.monthlyBudget, budget.investmentExpense);
                  updateBudget(index, updateBUTransaction, int.parse(_amountBU), _nameBU);
                  Navigator.of(context, rootNavigator: true).pop();
                }),
          ],
        ),
      );
    },
  );
}
