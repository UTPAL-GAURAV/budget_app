

import 'package:hive/hive.dart';
part 'balance.g.dart';

@HiveType(typeId: 1)
class Balance {
  @HiveField(0, defaultValue: 0)
  late final int bankBalance;
  @HiveField(1, defaultValue: 0)
  late final int yourWorth;

  Balance(this.bankBalance, this.yourWorth);
}