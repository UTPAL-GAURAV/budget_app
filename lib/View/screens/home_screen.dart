import 'package:budget_app/View/popups/incomeExpense_popup.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/loanlend.dart';
import '../../Controller/home_controller.dart';
import '../../models/income_expense.dart';
import '../pages/history_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final _loanlendBox = Hive.box('loanlend');
    final incomeExpenseBox = Hive.box('income_expense');
    final _balanceBox = Hive.box('balance');

    return Column(
      children: [
        Expanded(
          child: Stack(children: [
            Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    openIncomeExpensePopup(context);
                  },
                  icon: Icon(Icons.add),
                  label: Text("Income/Expense"),
                )),
            WatchBoxBuilder(
                box: _balanceBox,
                builder: (context, incExp) {
                  return Column(
                    children: [
                      Text("Bank Balance: ${getBankBalance()}"),
                      Text("Your Worth: ${getWorth()}"),
                      TextButton(
                          child: Text("All History"),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HistoryPage()));
                          }),
                    ],
                  );
                }),
          ]),
        ),
        Divider(),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Text("Lend/Borrow"),
              WatchBoxBuilder(
                  box: _loanlendBox,
                  builder: (context, loanlendBox) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 300),
                      child: ListView.builder(
                        itemCount: getLoanLendItemCount(), //loanlendBox.length,
                        itemBuilder: (context, index) {
                          final loanLend = _loanlendBox.getAt(index) as LoanLend;
                          return Card(
                            child: ListTile(
                              title: Text(getLoanLendText(loanLend.lenderBorrower) + loanLend.name),
                              subtitle: Text("Rs." + loanLend.amount.toString() + "    Due Date: " + loanLend.date.toString().substring(0, 10) ),
                              trailing: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  openLoanLendEditPopup(context, index);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
              Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                      label: Text("Lend/Borrow"),
                      icon: Icon(Icons.add),
                      onPressed: () {
                        openLoanLendPopup(context);
                      }))
            ],
          ),
        ),
      ],
    );
  }
}
