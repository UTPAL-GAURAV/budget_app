import 'package:budget_app/models/currency.dart';

Currency inr = Currency("India", "INR", '\u{20B9}');
Currency euro = Currency("Euro", "EUR", '\u{20AC}');
Currency dollor = Currency("Dollar", "USD, AUD, CAD, ..", '\u{24}');
Currency bitcoin = Currency("Bitcoin", "BTC", '\u{20BF}');



List<Currency> allCurrenciesList = [inr, euro, dollor, bitcoin];