
import 'package:budget_app/Controller/sideMenu_controller.dart';
import 'package:flutter/material.dart';

editUserName() {
  final userNameSnackbar = SnackBar(content: Row(
    children: [
      TextFormField(
        decoration: InputDecoration(
          labelText: "Username",
        ),
      ),
      ElevatedButton(onPressed: () { saveNewUserName("xx"); },
      child: null,

      )
    ],
  ));
}