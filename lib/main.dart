import 'dart:io';
import 'package:budget_app/Model/settings.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'Controller/testing_controller.dart';
import 'Controller/timely_controller.dart';
import 'Model/balance.dart';
import 'Model/budget.dart';
import 'Model/history.dart';
import 'Model/income_expense.dart';
import 'Model/loanlend.dart';
import 'Model/settings.dart';
import 'View/pages/home_page.dart';
import 'Utils/constants.dart' as constants;



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(BalanceAdapter());
  Hive.registerAdapter(BudgetAdapter());
  Hive.registerAdapter(HistoryAdapter());
  Hive.registerAdapter(IncomeExpenseAdapter());
  Hive.registerAdapter(LoanLendAdapter());
  Hive.registerAdapter(SettingsAdapter());

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],               // Disable Landscape mode
  );
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
              updateDbTimely();
              return const HomePage();
            }
          }
          else {
            return const Scaffold();
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
  final incomeExpenseBox = await Hive.openBox('income_expense');
  final loanlendBox = await Hive.openBox('loanlend');
  final settingsBox = await Hive.openBox('settings');

  // deleteAllData();

  boxList.add(balanceBox);
  boxList.add(budgetBox);
  boxList.add(historyBox);
  boxList.add(incomeExpenseBox);
  boxList.add(loanlendBox);
  boxList.add(settingsBox);

  return boxList;
}
