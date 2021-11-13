import 'dart:ffi';

import 'package:budget_app/models/budget.dart';
import 'package:budget_app/models/history.dart';
import 'package:budget_app/View/pages/budgetHistory_page.dart';
import 'package:budget_app/View/popups/budgetDelete_popup.dart';
import 'package:budget_app/View/popups/budgetEdit_popup.dart';
import 'package:budget_app/View/popups/budgetNew_popup.dart';
import 'package:budget_app/View/popups/budgetUpdate_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'history_controller.dart';
import 'home_controller.dart';


openNewBudgetPopup(BuildContext context) {
  newBudgetPopup(context);
}

openBudgetUpdatePopup(BuildContext context, int index) {
  budgetUpdatePopup(context, index);
}

openBudgetEditPopup(BuildContext context, int index) {
  budgetEditPopup(context, index);
}

openBudgetDeletePopup(BuildContext context, int index) {
  budgetDeletePopup(context, index);
}


addNewBudget(Budget newNBTransaction) {
  Hive.openBox('budget');
  final incomeExpenseBox = Hive.box('budget');
  incomeExpenseBox.add(newNBTransaction);
}


updateBudget(int index, Budget updateBUTransaction, int _amountBU, String _nameBU) {
  Hive.openBox('budget');
  final budgetBox = Hive.box('budget');
  budgetBox.putAt(index, updateBUTransaction);
  if(_nameBU!="") {
    updateInHistory("Budget", _amountBU, DateTime.now(), _nameBU, updateBUTransaction.investmentExpense);
    updateBankBalance(false, _amountBU);
    if(updateBUTransaction.investmentExpense == false)
      updateWorth(false, _amountBU);
  }
}


deleteBudget(BuildContext context, int index) {
  Hive.openBox('budget');
  final incomeExpenseBox = Hive.box('budget');
  incomeExpenseBox.deleteAt(index);
}


int getBudgetCount() {
  int _itemCount = 0, i = 0;

  Hive.openBox('budget');
  final loanLendBox = Hive.box('budget');

  for(i=0; i<loanLendBox.length; i++)
    _itemCount += 1;

  return _itemCount;
}


int getBudgetHistoryItemCount(int index) {
  int _itemCount = 0, i = 0;
  String _budgetName = "";
  late String _trimmedName;

  Hive.openBox('history');
  final historyBox = Hive.box('history');
  Hive.openBox('budget');
  final budgetBox = Hive.box('budget');

  final budget = budgetBox.getAt(index) as Budget;
  _budgetName = budget.name;

  for(i=0; i<historyBox.length; i++) {
    final history = historyBox.getAt(i) as History;
    var _foundName = history.name.split(" (");
    _trimmedName = _foundName[0].trim();
    if(_budgetName == _trimmedName)
      _itemCount += 1;
  }
  return _itemCount;
}


List<History> findOnlyBudgetHistoryItems(int index) {
  late String _nameToReturn, _trimmedName;
  int i = 0;
  String _budgetName = "";
  List<History> allBudgetHistoryNames = [];
  History objHistory;

  Hive.openBox('history');
  final historyBox = Hive.box('history');
  Hive.openBox('budget');
  final budgetBox = Hive.box('budget');

  final budget = budgetBox.getAt(index) as Budget;
  _budgetName = budget.name;

  for(i=0; i<historyBox.length; i++) {
    final history = historyBox.getAt(i) as History;
    var _foundName = history.name.split(" (");
    _trimmedName = _foundName[0].trim();

    if(_budgetName == _trimmedName) {
      _nameToReturn = getStringInsideBrackets(_foundName);
      objHistory = History(history.type, history.amount, history.date, _nameToReturn, history.inout);
      allBudgetHistoryNames.add(objHistory);
    }
  }

  return allBudgetHistoryNames;
}


String getStringInsideBrackets(List<String> stringWithBrackets) {
  late String insideStringNoBrackets;

  var _trimmedString = stringWithBrackets[1].trim();
  var _backBracketRemoved = _trimmedString.split(")");
  insideStringNoBrackets = _backBracketRemoved[0].trim();

  return insideStringNoBrackets;
}


int calculateRemaining(int total, int used) => (total-used);


double calculateUsedPercent(int used, int total) => ((used/total).toDouble());