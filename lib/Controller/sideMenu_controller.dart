import 'package:budget_app/Controller/sharedPrefrences.dart';
import 'package:budget_app/View/snackbars/editUserName_snackbar.dart';
import 'package:budget_app/models/currency.dart';
import 'package:budget_app/utils/currencies.dart';
import 'package:flutter/cupertino.dart';

saveUserCurrency(String country, BuildContext context) async {
  MySharedPreferences.instance.setUserStringData('userCurrencyCountry', country);
}


Future<dynamic> getUserCurrencySymbol() async {
  var _userCurrencySymbol;
  var _userCurrency =
      await MySharedPreferences.instance.getUserStringData('userCurrencyCountry');
  for(Currency c in allCurrenciesList) {
    if(c.country == _userCurrency) {
      _userCurrencySymbol = c.symbol;
      break;
    }
  }

  return _userCurrencySymbol;
}


saveUserName(String userName) {
  MySharedPreferences.instance.setUserStringData('userName', userName);
}

Future<dynamic> getUserName() async{
  var _userName = await MySharedPreferences.instance.getUserStringData('userName');
  return _userName;
}


showSnackbarEditUserName() {
  editUserName();
}


saveNewUserName(String newUserName) {

}
