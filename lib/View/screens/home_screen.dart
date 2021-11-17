import 'package:budget_app/Controller/sideMenu_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../Model/loanlend.dart';
import '../pages/history_page.dart';
import '../../Controller/home_controller.dart';
import '../../Utils/styles.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final _loanlendBox = Hive.box('loanlend');
    final _balanceBox = Hive.box('balance');

    return Column(
      children: [
        Expanded(
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      openIncomeExpensePopup(context);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Income/Expense"),
                  )),
            ),
            WatchBoxBuilder(
                box: _balanceBox,
                builder: (context, incExp) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:20.0, top:22.0),
                        child: FutureBuilder<dynamic>(
                        future: getUserCurrencySymbol(),
                        builder:
                        (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasError || snapshot.data == null) {
                        return Text("Bank Balance: ${getBankBalance()}", style: TextStyle(fontSize: 20));
                        } else {
                        return Text("Bank Balance: " + snapshot.data.toString() + " ${getBankBalance()}", style: TextStyle(fontSize: 20));
                        }
                        })
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:20.0, top:10.0),
                        child: Text("Your Worth: ${getWorth()}", style: TextStyle(fontSize: 16, color: colorDarkGray),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:20.0, top:22.0),
                        child: TextButton(
                            child: const Text("All History", style: TextStyle(fontSize: 15)),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const HistoryPage()));
                            }),
                      ),
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
              Text("Lend/Borrow", style: GoogleFonts.quicksand(textStyle: fontSize15)),
              WatchBoxBuilder(
                  box: _loanlendBox,
                  builder: (context, loanlendBox) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height*0.43),
                      child: ListView.builder(
                        itemCount: getLoanLendItemCount(),
                        itemBuilder: (context, index) {
                          final loanLend = _loanlendBox.getAt(index) as LoanLend;
                          if(loanLend.amount == 0) {                                     // Hiding 0 balance tiles
                            return const Visibility(visible: false, child: Text(""));
                          }
                          return Card(
                            child: ListTile(
                              title: Text(getLoanLendText(loanLend.lenderBorrower) + loanLend.name),
                              subtitle: Text("Rs." + loanLend.amount.toString() + "    Due Date: " + loanLend.date.toString().substring(0, 10) ),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton.extended(
                        label: const Text("Lend/Borrow"),
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          openLoanLendPopup(context);
                        })),
              )
            ],
          ),
        ),
      ],
    );
  }
}
