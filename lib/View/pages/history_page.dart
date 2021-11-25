import 'package:budget_app/Controller/home_controller.dart';
import 'package:budget_app/Model/history.dart';
import 'package:budget_app/Utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import '../../utils/constants.dart' as constant;
import '../../Controller/history_controller.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final _historyBox = Hive.box('history');
    int _totalHistoryCount = getHistoryItemCount();

    return Scaffold(
      appBar: AppBar(
        title: const Text(constant.appName + "  (History)"),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 700),
        child: Align(
          alignment: Alignment.topCenter,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _totalHistoryCount,
            itemBuilder: (context, index) {
              final history =
                  _historyBox.getAt(_totalHistoryCount - 1 - index) as History;
              return Card(
                child: ListTile(
                  // shape: RoundedRectangleBorder(side: new BorderSide(color: history.inout? colorCloverGreen : colorChillyPepper, width: 1.0),
                  //     borderRadius: BorderRadius.circular(4.0)),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                          height: 35,
                          width: 35,
                          child: Image.asset(
                            history.inout
                                ? 'assets/images/calandarGreen.png'
                                : 'assets/images/calandarRed.png',
                            fit: BoxFit.fill,
                          )),
                      Text(
                        getLoanLendDateInString(history.date.toString()),
                      ),
                    ],
                  ),
                  title: Text(history.name),
                  subtitle: Text(history.type),
                  trailing: Text(
                    "${getCurrencySymbol()} " + history.amount.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color:
                          history.inout ? colorCloverGreen : colorChillyPepper,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
