import 'package:budget_app/Controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../../Model/budget.dart';
import '../../View/pages/budgetHistory_page.dart';
import '../../Controller/budget_controller.dart';



late String _amountBU, _nameBU;
int _newUsed = 0, _amountValue = 0;
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
                      Text("Total Budget: ${getCurrencySymbol()} " + budget.total.toString()),
                      Text("Used        : ${getCurrencySymbol()} " + budget.used.toString()),
                      TextFormField(
                        maxLength: 18,
                        decoration:
                        const InputDecoration(hintText: " New Sports Shoe", labelText: "Name"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter some text";
                          }
                          if(checkForBrackets(value)) {
                            return "Do not type brackets ()";
                          }
                          return null;
                        },
                        onSaved: (value) => _nameBU = value!,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: " 0", labelText: "Amount"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter a valid amount";
                          }
                          try {
                            _amountValue = int.parse(value);
                          } catch (e) {
                            return "Enter a valid amount";
                          }
                          if(_amountValue > getBankBalance()) {
                            return "Not enough balance";
                          }
                          if (_amountValue >= 0 && _amountValue < 99999990) {
                            // Nine Crore..
                            return null;
                          }
                          return "Enter a valid amount";
                        },
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
                  if(_BUFormKey.currentState!.validate()) {
                    _newUsed = budget.used + int.parse(_amountBU);
                    _nameBU = budget.name + "  (" + _nameBU + ")";
                    final updateBUTransaction = Budget(budget.name, budget.total, _newUsed, budget.monthlyBudget, budget.investmentExpense, budget.renewBudgetTime);
                    updateBudget(index, updateBUTransaction, int.parse(_amountBU), _nameBU);
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                }),
          ],
        ),
      );
    },
  );
}
