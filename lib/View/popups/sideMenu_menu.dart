import 'package:budget_app/Controller/sideMenu_controller.dart';
import 'package:budget_app/models/currency.dart';
import 'package:flutter/services.dart';

import '../../utils/constants.dart' as constant;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/currencies.dart' as currency;

menuItems(BuildContext context) {
  bool _currencyVisible = false, _userNameVisible = true;
  // late String _userName;
  // late String _userCurrency = "Bitcoin";
  // getUserCurrencySymbol().then((value) {
  //   var _userCurrencySymbol = value.toString();
  //   // print("qqqq " + _userCurrencySymbol);
  // });

  return StatefulBuilder(
    builder: (BuildContext context, void Function(void Function()) setState) {
      return ListView(
        children: [
          Center(child: Text("Settings")),
          Text("General"),
          Visibility(
            visible: _userNameVisible,
            child: ListTile(
              title: FutureBuilder<dynamic>(
                future: getUserName(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasError) {
                    // fixme just to check an error
                    print("Error: ${snapshot.error}");
                    return Text("Error");
                  }
                  print("getUserName555: " + snapshot.data.toString());
                  if (snapshot.data == null) {
                    return Text("User");
                  } else {
                    return Text(snapshot.data.toString());
                  }
                },
              ),
              subtitle: Text("Greet Name"),
              onTap: () {
                // setState(() {
                //   _userNameVisible = !_userNameVisible;
                // });
                showSnackbarEditUserName();
              },
            ),
          ),
          // Visibility(
          //   visible: !_userNameVisible,
          //   child: TextFormField(
          //     decoration: InputDecoration(
          //       labelText: "Username",
          //     ),
          //     onSaved: (value) {
          //       saveUserName(value!);
          //       setState(() {
          //         _userNameVisible = !_userNameVisible;
          //         print("RRRRRR " + _userNameVisible.toString());
          //       });
          //     },
          //   ),
          // ),
          ListTile(title: Text("Dark Mode"), onTap: () {}),
          Visibility(
            visible: _userNameVisible,
            child: ListTile(
              title: FutureBuilder<dynamic>(
                  future: getUserCurrencySymbol(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasError) {
                      // fixme just to check an error
                      print("Error: ${snapshot.error}");
                      return Text("Error");
                    }
                    print("saveUserCurrency666: " + snapshot.data.toString());
                    if (snapshot.data == null) {
                      return Text("Currency \u{20BF}");
                    } else {
                      return Text("Currency " + snapshot.data.toString());
                    }
                  }),
              trailing: IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    _currencyVisible = !_currencyVisible;
                  });
                },
              ),
            ),
          ),
          Visibility(
            visible: _currencyVisible,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: currency.allCurrenciesList.length,
              itemBuilder: (context, index) {
                final c = currency.allCurrenciesList[index];
                  return Card(
                    child: ListTile(
                      title: Text(c.country),
                      subtitle: Text(c.shortCurrency),
                      trailing: Text(c.symbol),
                      onTap: () {
                        saveUserCurrency(c.country, context);
                      },
                    ),
                  );
                return Text(
                    "Not Null"); //Visibility(visible: false, child: Text("Not Null"));
              },
            ),
          ),
          Text("Other Information"),
          ListTile(title: Text("Help")),
          ListTile(title: Text("Contact Us")),
          Divider(),
          Text(constant.version),
        ],
      );
    },
  );
}
