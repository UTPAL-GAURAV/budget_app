import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../../Model/budget.dart';
import '../../Controller/budget_controller.dart';
import '../../Controller/history_controller.dart';


late String _nameBE, _monthlyBudgetBE, _totalBE;
final _BEFormKey = GlobalKey<FormState>();
int _amountValue = 0;

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
                        maxLength: 12,
                        initialValue: budget.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter some text";
                          }
                          return null;
                        },
                        onSaved: (value) => _nameBE = value!,
                      ),
                      Align(alignment: Alignment.centerLeft, child: const Text("Monthly Budget")),
                      TextFormField(
                        initialValue: budget.monthlyBudget.toString(),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {    // Setting value = 0, if user didnot enter
                            return "Enter a valid amount";
                          }
                          try {
                            _amountValue = int.parse(value);
                          } catch (e) {
                            return "Enter a valid amount";
                          }
                          if (_amountValue >= 0 && _amountValue < 99999990) {
                            // Nine Crore..
                            return null;
                          }
                          return "Enter a valid amount";
                        },
                        onSaved: (value) => _monthlyBudgetBE = value!,
                      ),
                      Align(alignment: Alignment.centerLeft, child: const Text("Total")),
                      TextFormField(
                        initialValue: budget.total.toString(),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {    // Setting value = 0, if user didnot enter
                            return "Enter a valid amount";
                          }
                          try {
                            _amountValue = int.parse(value);
                          } catch (e) {
                            return "Enter a valid amount";
                          }
                          if (_amountValue >= 0 && _amountValue < 99999990) {
                            // Nine Crore..
                            return null;
                          }
                          return "Enter a valid amount";
                        },
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
