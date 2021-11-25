
import 'package:budget_app/Model/budget.dart';
import 'package:hive/hive.dart';

import 'budget_controller.dart';

void updateDbTimely() {

  // DateTime.parse('1974-03-20 00:00:00.000')

  int i, dailyHoursDiff = 0, weeklyHoursDiff = 0, monthlyHoursDiff = 0, yearlyHoursDiff = 0;
  String _renewBudgetTime, dateTimeToPut, _lastDailyTimeUpdate, _lastWeeklyTimeUpdate, _lastMonthlyTimeUpdate, _lastYearlyTimeUpdate;
  bool _timeToUpdateDaily=false, _timeToUpdateWeekly=false, _timeToUpdateMonthly=false, _timeToUpdateYearly=false;
  int _gapDaily = 0, _gapWeekly = 0, _gapMonthly = 0, _gapYearly = 0;


  // Hive Box
  Hive.openBox('settings');
  final settingsBox = Hive.box('settings');


  String getDateTimeToPut() {
    dateTimeToPut = DateTime.now().toString().substring(0,11);
    dateTimeToPut = dateTimeToPut + "00:00:00.000";
    return dateTimeToPut;
  }

  int getMonthHours() {
    var Month31 = [01,03,05,07,08,10,12];
    var Month30 = [04,06,09,11];
    int _monthHours = 0;
    int _currentMonth = int.parse(DateTime.now().toString().substring(5,7));

    // Check for month of 31 days
    if(Month31.contains(_currentMonth)) {
      _monthHours = 24 * 31;
    }
    // Check for month of 30 days
    else if(Month30.contains(_currentMonth)) {
      _monthHours = 24 * 30;
    }
    // Check for month of Feb
    else{
      int _currentYear = int.parse(DateTime.now().toString().substring(0,4));
      if(_currentYear % 4 == 0 && _currentYear % 100 != 0) {
        _monthHours = 24 * 29;  // Leap year month
      }
      else {
        _monthHours = 24 * 28;
      }
    }

    return _monthHours;
  }

  //Update LastUpdateDaily date in db
  updateLUDaily() {
    settingsBox.put("3", getDateTimeToPut());
  }

  //Update LastUpdateWeekly date in db
  updateLUWeekly() {
    settingsBox.put("4", getDateTimeToPut());
  }

  //Update LastUpdateMonthly date in db
  updateLUMonthly() {
    settingsBox.put("5", getDateTimeToPut());
  }

  //Update LastUpdateYearly date in db
  updateLUYearly() {
    settingsBox.put("6", getDateTimeToPut());
  }

  // Try getting date for Daily Time Update
  try{
    _lastDailyTimeUpdate = settingsBox.get("3");
    var diff = DateTime.now().difference(DateTime.parse(_lastDailyTimeUpdate));
    dailyHoursDiff = int.parse(diff.toString().substring(0,2));
    // Days check
    if(dailyHoursDiff / 24 >= 1) {
      _gapDaily = dailyHoursDiff ~/ 24;
      _timeToUpdateDaily = true;
      updateLUDaily();
    }
  } catch(e) {
    updateLUDaily();
  }

  // Try getting date for Weekly Time Update
  try {
    _lastWeeklyTimeUpdate = settingsBox.get("4");
    var diff = DateTime.now().difference(DateTime.parse(_lastWeeklyTimeUpdate));
    weeklyHoursDiff = int.parse(diff.toString().substring(0, 2));

    // Weeks check
    if(weeklyHoursDiff / 168 >= 1) {
      _gapWeekly = weeklyHoursDiff ~/ 168;
      _timeToUpdateWeekly = true;
      updateLUWeekly();
    }
  } catch(e) {
    updateLUWeekly();
  }

  // Try getting date for Monthly Time Update
  try {
    _lastMonthlyTimeUpdate = settingsBox.get("5");
    var diff = DateTime.now().difference(DateTime.parse(_lastMonthlyTimeUpdate));
    monthlyHoursDiff = int.parse(diff.toString().substring(0, 2));

    // Months check
    int monthHours = getMonthHours();
    if(monthlyHoursDiff / monthHours >= 1) {
      _gapMonthly = monthlyHoursDiff ~/ monthHours;
      _timeToUpdateMonthly = true;
      updateLUMonthly();
    }
  } catch(e) {
    updateLUMonthly();
  }

  // Try getting date for Yearly Time Update
  try {
    _lastYearlyTimeUpdate = settingsBox.get("6");
    var diff = DateTime.now().difference(DateTime.parse(_lastYearlyTimeUpdate));
    yearlyHoursDiff = int.parse(diff.toString().substring(0, 2));

    // Years check
    if(yearlyHoursDiff / 8760 >= 1) {
      _gapYearly = yearlyHoursDiff ~/ 8760;
      _timeToUpdateYearly = true;
      updateLUYearly();
    }
  } catch(e) {
    updateLUYearly();
  }

  // Update Budget
  Hive.openBox('budget');
  final budgetBox = Hive.box('budget');
  for(i=0; i<budgetBox.length; i++) {
    final budget = budgetBox.getAt(i) as Budget;
    _renewBudgetTime = budget.renewBudgetTime;
    // Daily basis
    if(_renewBudgetTime == "Daily" && _timeToUpdateDaily == true ) {
      int _newTotalBudget = budget.total + (_gapDaily * budget.monthlyBudget);
      final updateBUTransaction = Budget(budget.name, _newTotalBudget, budget.used, budget.monthlyBudget, budget.investmentExpense, budget.renewBudgetTime);
      updateBudget(i, updateBUTransaction, (_gapDaily * budget.monthlyBudget), "Daily Renew");
    }
    if(_renewBudgetTime == "Weekly" && _timeToUpdateWeekly == true ) {
      int _newTotalBudget = budget.total + (_gapWeekly * budget.monthlyBudget);
      final updateBUTransaction = Budget(budget.name, _newTotalBudget, budget.used, budget.monthlyBudget, budget.investmentExpense, budget.renewBudgetTime);
      updateBudget(i, updateBUTransaction, (_gapWeekly * budget.monthlyBudget), "Weekly Renew");
    }
    if(_renewBudgetTime == "Monthly" && _timeToUpdateMonthly == true ) {
      int _newTotalBudget = budget.total + (_gapMonthly * budget.monthlyBudget);
      final updateBUTransaction = Budget(budget.name, _newTotalBudget, budget.used, budget.monthlyBudget, budget.investmentExpense, budget.renewBudgetTime);
      updateBudget(i, updateBUTransaction, (_gapMonthly * budget.monthlyBudget), "Monthly Renew");
    }
    if(_renewBudgetTime == "Yearly" && _timeToUpdateYearly == true ) {
      int _newTotalBudget = budget.total + (_gapYearly * budget.monthlyBudget);
      final updateBUTransaction = Budget(budget.name, _newTotalBudget, budget.used, budget.monthlyBudget, budget.investmentExpense, budget.renewBudgetTime);
      updateBudget(i, updateBUTransaction, (_gapYearly * budget.monthlyBudget), "Yearly Renew");
    }
  }

}