// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_expense.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IncomeExpenseAdapter extends TypeAdapter<IncomeExpense> {
  @override
  final int typeId = 2;

  @override
  IncomeExpense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IncomeExpense(
      fields[0] as bool,
      fields[1] as String,
      fields[2] as int,
      fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, IncomeExpense obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.incomeExpense)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncomeExpenseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
