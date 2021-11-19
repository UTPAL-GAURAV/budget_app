import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/sideMenu_controller.dart';
import '../../Utils/constants.dart' as constant;
import '../../Utils/currencies.dart' as currency;
import '../../Utils/styles.dart';

final _EUNFormKey = GlobalKey<FormState>();

menuItems(BuildContext context) {
  bool _currencyVisible = false, _userNameVisible = true;
  String _newUserName = "User";

  return StatefulBuilder(
    builder: (BuildContext context, void Function(void Function()) setState) {
      return ListView(
        children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 16.0),
            child: Text("Settings",
                style: GoogleFonts.cairo(textStyle: fontSize20)),
          )),
          Container(
              decoration: BoxDecoration(color: colorBgLight1),
              padding: spaceLeft10,
              child: Text(
                "General",
                style: GoogleFonts.libreBaskerville(textStyle: fontSize15),
              )),
          Visibility(
            visible: _userNameVisible,
            child: ListTile(
              title: FutureBuilder<dynamic>(
                future: getUserName(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasError || snapshot.data == null) {
                    return Text("User");
                  } else {
                    return Text(snapshot.data.toString());
                  }
                },
              ),
              subtitle: Text("Greet Name"),
              onTap: () {
                setState(() {
                  _userNameVisible = !_userNameVisible;
                });
              },
            ),
          ),
          Visibility(
            visible: !_userNameVisible,
            child: Form(
              key: _EUNFormKey,
              child: Row(children: [
                Expanded(
                  child: TextFormField(
                    maxLength: 20,
                    decoration: InputDecoration(
                      labelText: "New Name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter some text";
                      }
                      return null;
                    },
                    onSaved: (value) => _newUserName = value!,
                  ),
                ),
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    setState(() {
                      _userNameVisible = !_userNameVisible;
                    });
                  },
                ),
                TextButton(
                  child: Text("Save"),
                  onPressed: () {
                    _EUNFormKey.currentState!.save();
                    if(_EUNFormKey.currentState!.validate()) {
                      saveUserName(_newUserName);
                      setState(() {
                        _userNameVisible = !_userNameVisible;
                      });
                    }
                  },
                )
              ]),
            ),
          ),
          // ListTile(title: Text("Dark Mode"), onTap: () {}),
          Visibility(
            visible: _userNameVisible,
            child: ListTile(
              title: FutureBuilder<dynamic>(
                  future: getUserCurrencySymbol(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasError || snapshot.data == null) {
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
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: Visibility(
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
                        setState(() {
                          _currencyVisible = false;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
              decoration: BoxDecoration(color: colorBgLight1),
              margin: spaceTop20,
              padding: spaceLeft10,
              child: Text("Other Information")),
          ListTile(title: Text("Help")),
          ListTile(title: Text("Contact Us")),
          Divider(),
          Center(child: Text(constant.version)),
        ],
      );
    },
  );
}
