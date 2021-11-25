import 'package:hive/hive.dart';

import '../Model/history.dart';
import 'budget_controller.dart';

updateInHistory(String type, int amount, DateTime date, String name, bool inOut) {
  Hive.openBox('history');
  final historyBox = Hive.box('history');
  final newHistoryTransaction = History(type, amount, date, name, inOut);
  historyBox.add(newHistoryTransaction);
}


changeNameInHistory(String oldName, String newName) {
  int i = 0;
  History value;
  late String _trimmedName, _nameInsideBrackets, _newNameWithBrackets;
  late List<String> _foundName;

  if(oldName != newName) {
    Hive.openBox('history');
    final historyBox = Hive.box('history');

    for(i=0; i<historyBox.length; i++) {
      final history = historyBox.getAt(i) as History;
      _foundName = history.name.split(" (");
      _trimmedName = _foundName[0].trim();

      try {
        _nameInsideBrackets = getStringInsideBrackets(_foundName);
      } catch(e) {
        continue;
      }

      _newNameWithBrackets = newName + " (" + _nameInsideBrackets + ")";
      if(_trimmedName == oldName) {
        value = History(history.type, history.amount, history.date, _newNameWithBrackets, history.inout);
        historyBox.putAt(i, value);
      }
    }
  }
}


int getHistoryItemCount() {
  int _itemCount = 0, i=0;

  Hive.openBox('history');
  final historyBox = Hive.box('history');

  for(i=0; i<historyBox.length; i++) {
    _itemCount += 1;
  }

  return _itemCount;
}
