import 'package:budget_app/Model/currency.dart';
import 'package:budget_app/Utils/currencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../Model/income_expense.dart';
import '../Model/loanlend.dart';
import '../View/popups/incomeExpense_popup.dart';
import '../View/popups/loanLend_popup.dart';
import '../View/popups/loanLendEdit_popup.dart';
import 'history_controller.dart';
import '../Utils/constants.dart' as constant;


openIncomeExpensePopup(BuildContext context) {
  incomeExpensePopup(context);
}

openLoanLendPopup(BuildContext context) {
  loanLendPopup(context);
}

openLoanLendEditPopup(BuildContext context, int index) {
  loanLendEditPopup(context, index);
}


addNewIncomeExpense(IncomeExpense newIETransaction) {
  Hive.openBox('income_expense');
  final incomeExpenseBox = Hive.box('income_expense');
  incomeExpenseBox.add(newIETransaction);
  updateInHistory("Income/Expense", newIETransaction.amount, newIETransaction.date, newIETransaction.name, newIETransaction.incomeExpense);
  updateBankBalance(newIETransaction.incomeExpense, newIETransaction.amount);
  updateWorth(newIETransaction.incomeExpense, newIETransaction.amount);
}


addNewLoanLend(LoanLend newLLTransaction) {
  Hive.openBox('loanlend');
  final incomeExpenseBox = Hive.box('loanlend');
  incomeExpenseBox.add(newLLTransaction);
  updateInHistory("Loan/Lend", newLLTransaction.amount, DateTime.now(), newLLTransaction.name, newLLTransaction.lenderBorrower);
  updateBankBalance(!newLLTransaction.lenderBorrower, newLLTransaction.amount);
  // if(newLLTransaction.lenderBorrower == false) {
  //   updateWorth(false, newLLTransaction.amount);
  // }
}


returnLoanLend(int index, LoanLend updateLLTransaction, int _amountLLE) {
  late String newName;

  Hive.openBox('loanlend');
  final incomeExpenseBox = Hive.box('loanlend');
  incomeExpenseBox.putAt(index, updateLLTransaction);

  newName = updateLLTransaction.name + " (returned)";
  if(_amountLLE != 0) {
    updateInHistory("Loan/Lend", _amountLLE, updateLLTransaction.date, newName, updateLLTransaction.lenderBorrower);
    updateBankBalance(updateLLTransaction.lenderBorrower, _amountLLE);
  }

  // if(updateLLTransaction.lenderBorrower == false) {
  //   updateWorth(false, _amountLLE);
  // }
}


updateBankBalance(bool AddOrSub, int amount) {
  Hive.openBox('balance');
  final balanceBox = Hive.box('balance');
  int _currentBalance = balanceBox.getAt(0);
  if(AddOrSub == true) {
    _currentBalance += amount;
  } else {
    _currentBalance -= amount;
  }

  balanceBox.putAt(0, _currentBalance);
}


updateWorth(bool AddOrSub, int amount) {
    Hive.openBox('balance');
    final balanceBox = Hive.box('balance');
    int _currentWorth = balanceBox.getAt(1);
    if(AddOrSub == true) {
      _currentWorth += amount;
    } else {
      _currentWorth -= amount;
    }

    balanceBox.putAt(1, _currentWorth);
}


String getCurrencySymbol() {
  String _currencySymbol = '\u{20BF}', _currencyCountry = "Bitcoin";

  Hive.openBox('settings');
  final settingsBox = Hive.box('settings');
  try {
    _currencyCountry = settingsBox.getAt(0);
  } catch(e) {
    _currencyCountry = "Bitcoin";
  }

  for(Currency c in allCurrenciesList) {
    if(c.country == _currencyCountry) {
      _currencySymbol = c.symbol;
      break;
    }
  }

  return _currencySymbol;
}


int getBankBalance() {
  int _currentBalance=0;

  Hive.openBox('balance');
  final balanceBox = Hive.box('balance');
  try {
    _currentBalance = balanceBox.getAt(0);
  } catch(e) {
    balanceBox.add(0);
  }

  return _currentBalance;
}


int getWorth() {
  int _currentBalance = 0;

  Hive.openBox('balance');
  final balanceBox = Hive.box('balance');
  try {
    _currentBalance = balanceBox.getAt(1);
  }catch(e) {
    balanceBox.add(0);
  }

  return _currentBalance;
}


String getLoanLendText(bool lenderBorrower) {
  late String loanLendString;

  if(lenderBorrower==true) {
    loanLendString = constant.lendString;
  } else {
    loanLendString = constant.loanString;
  }

  return loanLendString;
}


int getLoanLendItemCount() {
  int _itemCount = 0, i=0;

  Hive.openBox('loanlend');
  final loanLendBox = Hive.box('loanlend');

  for(i=0; i<loanLendBox.length; i++) {
    _itemCount += 1;
  }

  return _itemCount;
}


String getLoanLendDateInString(String date) {
  String _dateToReturn = "??";
  
  var intMonth = date.substring(5,7);
  String _strMonth = intMonth=="01"? "Jan" : intMonth=="02"? "Feb" : intMonth=="03"? "Mar" : intMonth=="04"? "Apr" : intMonth=="05"? "May" : intMonth=="06"? "Jun" : intMonth=="07"? "Jul" : intMonth=="08"? "Aug" : intMonth=="09"? "Sep" : intMonth=="10"? "Oct" :  intMonth=="11"? "Nov" : "Dec" ;
  _dateToReturn = date.substring(8,10) + " " + _strMonth;

  return _dateToReturn;
}

