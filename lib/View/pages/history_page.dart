import 'package:budget_app/models/history.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../utils/constants.dart' as constant;
import '../../Controller/history_controller.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

final _historyBox = Hive.box('history');

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(constant.appName+"  (History)"),),
      body: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 700),
        child: Align( alignment: Alignment.topCenter,
          child: ListView.builder(
            reverse: true,
            shrinkWrap: true,
            itemCount: getHistoryItemCount(), //loanlendBox.length,
            itemBuilder: (context, index) {
              final history = _historyBox.getAt(index) as History;
              return Card(
                child: ListTile(
                  title: Text(history.name),
                  subtitle: Text(history.type+"   "+ history.date.toString().substring(0, 10) +"    Rs."+ history.amount.toString()),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
