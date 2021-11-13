// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loanlend.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoanLendAdapter extends TypeAdapter<LoanLend> {
  @override
  final int typeId = 0;

  @override
  LoanLend read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoanLend(
      fields[0] as bool,
      fields[1] as int,
      fields[2] as String,
      fields[3] as DateTime,
      fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LoanLend obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.lenderBorrower)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.reminder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoanLendAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
