import 'package:budget_app/Controller/budget_controller.dart';
import 'package:flutter/material.dart';


final _BDFormKey = GlobalKey<FormState>();

budgetDeletePopup(BuildContext context, int index) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Form(
        key: _BDFormKey,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(22.0))),
          title: const Text("Delete Budget"),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 70),
                  child: Column(
                    children: const [
                      Text("Deleting budget will not \n delete it's history."),
                    ],
                  ),
                );
              }),
          actions: [
            TextButton(
                child: const Text("Delete", style: TextStyle(color: Colors.red),),
                onPressed: () {
                  _BDFormKey.currentState!.save();
                  Navigator.of(context, rootNavigator: true).pop();
                  deleteBudget(context, index);
                }),
            TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  _BDFormKey.currentState!.save();
                  Navigator.of(context, rootNavigator: true).pop();
                }),
          ],
        ),
      );
    },
  );
}
