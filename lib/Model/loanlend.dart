import 'package:hive/hive.dart';
part 'loanlend.g.dart';

@HiveType(typeId: 0)
class LoanLend {
  @HiveField(0)
  late final bool lenderBorrower;
  @HiveField(1)
  late final int amount;
  @HiveField(2)
  late final String name;
  @HiveField(3)
  late final DateTime date;
  @HiveField(4)
  late final bool reminder;

  LoanLend(this.lenderBorrower, this.amount, this.name, this.date,  this.reminder);
}