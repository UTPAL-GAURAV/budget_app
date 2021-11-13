import 'package:budget_app/Controller/budget_controller.dart';
import 'package:budget_app/models/budget.dart';
import 'package:budget_app/View/pages/budgetHistory_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';


late String _amountBU, _nameBU;
int _remainingAmount = 0, _newUsed = 0;
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
          title: Text("New Budget Expense"),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300),
                  child: Column(
                    children: [
                      Text("Total Budget: Rs." + budget.total.toString()),
                      Text("Used        : Rs." + budget.used.toString()),
                      Align(alignment: Alignment.centerLeft, child: Text("Name")),
                      TextFormField(
                        decoration:
                        const InputDecoration(hintText: " New Sports Shoe"),
                        onSaved: (value) => _nameBU = value!,
                      ),
                      Align(alignment: Alignment.centerLeft, child: Text("Amount")),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: " 0"),
                        onSaved: (value) => _amountBU = value!,
                      ),
                    ],
                  ),
                );
              }),
          actions: [
            TextButton(
                child: Text("Edit"),
                onPressed: () {
                  _BUFormKey.currentState!.save();
                  Navigator.of(context, rootNavigator: true).pop();
                  openBudgetEditPopup(context, index);
                }),
            TextButton(
                child: Text("Track"),
                onPressed: () {
                  _BUFormKey.currentState!.save();
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BudgetHistoryPage(index: index,)));
                }),
            TextButton(
                child: Text("Save"),
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
