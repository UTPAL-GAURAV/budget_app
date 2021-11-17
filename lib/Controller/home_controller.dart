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
  updateInHistory("Loan/Lend", newLLTransaction.amount, newLLTransaction.date, newLLTransaction.name, newLLTransaction.lenderBorrower);
  updateBankBalance(!newLLTransaction.lenderBorrower, newLLTransaction.amount);
  if(newLLTransaction.lenderBorrower == false) {
    updateWorth(false, newLLTransaction.amount);
  }
}


returnLoanLend(int index, LoanLend updateLLTransaction, int _amountLLE) {
  late String newName;

  Hive.openBox('loanlend');
  final incomeExpenseBox = Hive.box('loanlend');
  incomeExpenseBox.putAt(index, updateLLTransaction);

  newName = updateLLTransaction.name + " (returned)";
  updateInHistory("Loan/Lend", _amountLLE, updateLLTransaction.date, newName, updateLLTransaction.lenderBorrower);
  updateBankBalance(updateLLTransaction.lenderBorrower, _amountLLE);
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

