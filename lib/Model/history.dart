import 'package:hive/hive.dart';
part 'history.g.dart';

@HiveType(typeId: 4)
class History {
  @HiveField(0)
  late final String type;
  @HiveField(1)
  late final int amount;
  @HiveField(2)
  late final DateTime date;
  @HiveField(3)
  late final String name;
  @HiveField(4)
  late final bool inout;

  History(this.type, this.amount, this.date, this.name, this.inout);
}