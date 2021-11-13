import 'package:budget_app/Controller/budget_controller.dart';
import 'package:budget_app/models/budget.dart';
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
                  constraints: BoxConstraints(maxHeight: 700),
                  child: ListView.builder(
                    itemCount: getBudgetCount(), //loanlendBox.length,
                    itemBuilder: (context, index) {
                      final budget = _budgetBox.getAt(index) as Budget;
                      return Card(
                        child: ListTile(
                          title: Text(budget.name),
                          subtitle: Column(children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                                    "Remaining: Rs." + calculateRemaining(budget.total, budget.used).toString() +
                                        "                  Total: Rs." + budget.total.toString())),
                          ]),
                          trailing: IconButton(
                            icon: Icon(Icons.arrow_forward_ios_rounded),
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
            child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton.extended(
                    label: Text("New Budget"),
                    icon: Icon(Icons.add),
                    onPressed: () {
                      openNewBudgetPopup(context);
                    })))
      ],
    );
  }
}
