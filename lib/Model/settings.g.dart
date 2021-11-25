// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 5;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      fields[0] == null ? 'User' : fields[0] as String,
      fields[1] == null ? 'Bitcoin' : fields[1] as String,
      fields[2] == null ? true : fields[2] as bool,
      fields[3] as DateTime,
      fields[4] as DateTime,
      fields[5] as DateTime,
      fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.userName)
      ..writeByte(1)
      ..write(obj.currency)
      ..writeByte(2)
      ..write(obj.darkLightMode)
      ..writeByte(3)
      ..write(obj.lastDailyTimeUpdate)
      ..writeByte(4)
      ..write(obj.lastWeeklyTimeUpdate)
      ..writeByte(5)
      ..write(obj.lastMonthlyTimeUpdate)
      ..writeByte(6)
      ..write(obj.lastYearlyTimeUpdate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
