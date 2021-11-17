import '../Model/currency.dart';

Currency bitcoin = Currency("Bitcoin", "BTC, altcoins", '\u{20BF}');
Currency dollor = Currency("Dollar", "AUD, CAD, USD, ..", '\u{24}');
Currency euro = Currency("Euro", "EUR", '\u{20AC}');
Currency franc = Currency("Franc", "CDF, XAF, XOF, ..", '\u{20A3}');
Currency japan = Currency("Japan", "YEN", '\u{00A5}');
Currency pound = Currency("UK", "GBP", '\u{00A3}');
Currency ruble = Currency("Ruble", "BYN, RUB", '\u{20BD}');
Currency rupees = Currency("Rupees", "INR, NPR, PKR, ..", '\u{20A8}.');
Currency sheqel = Currency("Sheqel", "ILS", '\u{20AA}');



List<Currency> allCurrenciesList = [bitcoin, dollor, euro, franc, japan, pound, ruble, rupees, sheqel];