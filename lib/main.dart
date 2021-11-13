import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';

import 'package:flutter/material.dart';
import 'Utils/constants.dart' as constants;
import 'View/pages/home_page.dart';
import 'Controller/testing_controller.dart';
// import 'pages/home_page.dart';

import 'models/balance.dart';
import 'models/budget.dart';
import 'models/history.dart';
import 'models/income_expense.dart';
import 'models/loanlend.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(BalanceAdapter());
  Hive.registerAdapter(BudgetAdapter());
  Hive.registerAdapter(HistoryAdapter());
  Hive.registerAdapter(IncomeExpenseAdapter());
  Hive.registerAdapter(LoanLendAdapter());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: constants.appName,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _openAllBoxes(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            if(snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            else {
              return HomePage();
            }
          }
          else {
            return Scaffold();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}


List<Box> boxList = [];
Future<List<Box>> _openAllBoxes() async {
  final balanceBox = await Hive.openBox('balance');
  final budgetBox = await Hive.openBox('budget');
  final historyBox = await Hive.openBox('history');
  final income_expenseBox = await Hive.openBox('income_expense');
  final loanlendBox = await Hive.openBox('loanlend');

  // deleteAllData();

  boxList.add(balanceBox);
  boxList.add(budgetBox);
  boxList.add(historyBox);
  boxList.add(income_expenseBox);
  boxList.add(loanlendBox);

  return boxList;
}
