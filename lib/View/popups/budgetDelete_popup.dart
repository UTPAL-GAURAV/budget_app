import 'package:budget_app/Controller/budget_controller.dart';
import 'package:budget_app/models/budget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';


late String _amountBU, _nameBU;
int _remainingAmount = 0, _newUsed = 0;
final _BDFormKey = GlobalKey<FormState>();

final _budgetBox = Hive.box('budget');

budgetDeletePopup(BuildContext context, int index) {
  final budget = _budgetBox.getAt(index) as Budget;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Form(
        key: _BDFormKey,
        child: AlertDialog(
          title: Text("Delete Budget"),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 70),
                  child: Column(
                    children: [
                      Text("Deleting budget will not \n delete it's history."),
                    ],
                  ),
                );
              }),
          actions: [
            TextButton(
                child: Text("Delete", style: TextStyle(color: Colors.red),),
                onPressed: () {
                  _BDFormKey.currentState!.save();
                  Navigator.of(context, rootNavigator: true).pop();
                  deleteBudget(context, index);
                }),
            TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  _BDFormKey.currentState!.save();
                  Navigator.of(context, rootNavigator: true).pop();
                }),
          ],
        ),
      );
    },
  );
}
