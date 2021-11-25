import 'package:budget_app/Controller/budget_controller.dart';
import 'package:budget_app/Controller/home_controller.dart';
import 'package:budget_app/Model/budget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/adapters.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    final _budgetBox = Hive.box('budget');

    return Column(
      children: [
        Expanded(
            flex: 6,
            child: WatchBoxBuilder(
              box: _budgetBox,
              builder: (context, budgetBox) {
                return ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 700),
                  child: ListView.builder(
                    itemCount: getBudgetCount(),
                    itemBuilder: (context, index) {
                      final budget = _budgetBox.getAt(index) as Budget;
                      return Card(
                        child: ListTile(
                          title: Text(budget.name),
                          subtitle: Column(children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: LinearProgressIndicator(
                                minHeight: 7,
                                value: calculateUsedPercent(budget.used, budget.total),
                                backgroundColor: Colors.grey,
                                color: Colors.greenAccent,
                              ),
                            ),
                            Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                    "Remaining: ${getCurrencySymbol() }" + calculateRemaining(budget.total, budget.used).toString() +
                                        "                  Total: ${getCurrencySymbol()} " + budget.total.toString())),
                          ]),
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios_rounded),
                            onPressed: () {
                              openBudgetUpdatePopup(context, index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            )),
        Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                      heroTag: "NewBudBtn",
                      label: const Text("New Budget"),
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        openNewBudgetPopup(context);
                      })),
            ))
      ],
    );
  }
}
