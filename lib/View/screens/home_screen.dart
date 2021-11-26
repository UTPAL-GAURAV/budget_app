import 'package:budget_app/Controller/sideMenu_controller.dart';
import 'package:budget_app/Model/settings.dart';
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
    final _settingsBox = Hive.box('settings');

    return Column(
      children: [
        Expanded(
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                    heroTag: "IncExpBtn",
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
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 10.0, right: 20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.18,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.lightBlueAccent,
                              Colors.blueAccent
                            ]),
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.lightBlueAccent.withOpacity(0.5),
                                blurRadius: 7,
                                offset: Offset(4, 8), // shadow position
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Image.asset('assets/images/piggy.png'),
                              WatchBoxBuilder(
                                  box: _settingsBox,
                                  builder: (context, settingsBox) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.045,
                                        ),
                                        Text(
                                          "Current balance",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          "${getCurrencySymbol()} ${getBankBalance()}",
                                          style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                        ),
                                        Text(
                                          "Your Worth: ${getWorth()}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 22.0),
                        child: TextButton(
                            child: const Text("All History",
                                style: TextStyle(fontSize: 15)),
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
              Text("Lend/Borrow",
                  style: GoogleFonts.quicksand(textStyle: fontSize15)),
              WatchBoxBuilder(
                  box: _settingsBox,
                  builder: (context, loanlendBox) {
                    return WatchBoxBuilder(
                        box: _loanlendBox,
                        builder: (context, loanlendBox) {
                          return ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height * 0.44),
                            child: ListView.builder(
                              itemCount: getLoanLendItemCount(),
                              itemBuilder: (context, index) {
                                final loanLend =
                                _loanlendBox.getAt(index) as LoanLend;
                                // Hiding 0 balance tiles
                                if (loanLend.amount == 0) {
                                  return const Visibility(
                                      visible: false, child: Text(""));
                                }
                                return Container(
                                  height: 70,
                                  child: Card(
                                    child: ListTile(
                                      tileColor: colorVistaWhite,
                                      leading: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                              height: 35,
                                              width: 35,
                                              child: Image.asset(
                                                loanLend.lenderBorrower? 'assets/images/calandarGreen.png' : 'assets/images/calandarRed.png',
                                                fit: BoxFit.fill,
                                              )),
                                          Text(
                                            getLoanLendDateInString(
                                                loanLend.date.toString()),
                                          ),
                                        ],
                                      ),
                                      title: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(loanLend.name),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "${getCurrencySymbol()} " +
                                                  loanLend.amount.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: loanLend.lenderBorrower
                                                    ? colorCloverGreen
                                                    : colorChillyPepper,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          openLoanLendEditPopup(context, index);
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        });
                  }

              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton.extended(
                        heroTag: "LendBorrBtn",
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
