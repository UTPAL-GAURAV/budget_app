import 'package:hive/hive.dart';
part 'settings.g.dart';

@HiveType(typeId: 5)
class Settings {
  @HiveField(0, defaultValue: "User")
  late final String userName;
  @HiveField(1, defaultValue: "Bitcoin")
  late final String currency;
  @HiveField(2, defaultValue: true)
  late final bool darkLightMode;
  @HiveField(3)
  late final DateTime lastDailyTimeUpdate;
  @HiveField(4)
  late final DateTime lastWeeklyTimeUpdate;
  @HiveField(5)
  late final DateTime lastMonthlyTimeUpdate;
  @HiveField(6)
  late final DateTime lastYearlyTimeUpdate;

  Settings(this.userName, this.currency, this.darkLightMode, this.lastDailyTimeUpdate, this.lastWeeklyTimeUpdate, this.lastMonthlyTimeUpdate, this.lastYearlyTimeUpdate);
}