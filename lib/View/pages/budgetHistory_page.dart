import 'package:budget_app/Controller/home_controller.dart';
import 'package:budget_app/Model/history.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart' as constant;
import '../../Controller/budget_controller.dart';


class BudgetHistoryPage extends StatefulWidget {
  const BudgetHistoryPage({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  _BudgetHistoryPageState createState() => _BudgetHistoryPageState(index: index);
}

class _BudgetHistoryPageState extends State<BudgetHistoryPage> {
  var index;

  _BudgetHistoryPageState({required this.index}) : super();
  @override
  Widget build(BuildContext context) {

    List allBudgetHistoryItems = findOnlyBudgetHistoryItems(index);
    int totalBudgetHistoryItems = allBudgetHistoryItems.length;

    return Scaffold(
      appBar: AppBar(title: const Text(constant.appName+"  (History)"),),
      body: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 700),
        child: ListView.builder(
          itemCount: totalBudgetHistoryItems,
          itemBuilder: (context, dummyIndex) {

            if(allBudgetHistoryItems.isNotEmpty) {
                History h = allBudgetHistoryItems.elementAt(totalBudgetHistoryItems -1 -dummyIndex);
                return Card(
                  child: ListTile(
                    title: Text(h.name),
                    subtitle: Text("    ${getCurrencySymbol()}"+ h.amount.toString() + "           " + h.date.toString().substring(0, 10)),
                  ),
                );
            }
            else {
              return const Card(
                child: const Text("Nothing found"),
              );
            }
          },
        ),
      ),
    );
  }
}
