import 'package:hive/hive.dart';
part 'income_expense.g.dart';

@HiveType(typeId: 2)
class IncomeExpense {
  @HiveField(0)
  late final bool incomeExpense;
  @HiveField(1)
  late final String name;
  @HiveField(2)
  late final int amount;
  @HiveField(3)
  late final DateTime date;

  IncomeExpense(this.incomeExpense, this.name, this.amount, this.date);
}