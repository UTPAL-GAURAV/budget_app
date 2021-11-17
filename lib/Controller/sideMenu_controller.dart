import 'package:flutter/cupertino.dart';

import '../Model/currency.dart';
import 'sharedPrefrences.dart';
import '../Utils/currencies.dart';


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


