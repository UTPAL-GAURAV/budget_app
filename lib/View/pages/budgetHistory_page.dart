import 'package:budget_app/models/history.dart';
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

  _BudgetHistoryPageState({Key? key, required this.index}) : super();
  @override
  Widget build(BuildContext context) {

    List<History> allBudgetHistoryItems = findOnlyBudgetHistoryItems(index);
    int dummyIndex = 1;

    return Scaffold(
      appBar: AppBar(title: Text(constant.appName+"  (History)"),),
      body: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 700),
        child: ListView.builder(
          itemCount: allBudgetHistoryItems.length,
          itemBuilder: (context, dummyIndex) {

            if(allBudgetHistoryItems.isNotEmpty) {
              for(History h in allBudgetHistoryItems) {
                allBudgetHistoryItems.removeAt(0);
                return Card(
                  child: ListTile(
                    title: Text(h.name),
                    subtitle: Text("    Rs."+ h.amount.toString() + "           " + h.date.toString().substring(0, 10)),
                  ),
                );
              }
            }
            else {
              return Card(
                child: Text("Nothing found"),
              );
            }
            return Spacer();
          },
        ),
      ),
    );
  }
}
