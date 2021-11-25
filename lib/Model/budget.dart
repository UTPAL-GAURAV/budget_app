import 'package:hive/hive.dart';
part 'budget.g.dart';

@HiveType(typeId: 3)
class Budget {
  @HiveField(0)
  late final String name;
  @HiveField(1)
  late final int total;
  @HiveField(2)
  late final int used;
  @HiveField(3)
  late final int monthlyBudget;
  @HiveField(4)
  late final bool investmentExpense;
  @HiveField(5)
  late final String renewBudgetTime;

  Budget(this.name, this.total, this.used, this.monthlyBudget, this.investmentExpense, this.renewBudgetTime);
}