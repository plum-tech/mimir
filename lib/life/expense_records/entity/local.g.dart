// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 70;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      timestamp: fields[0] as DateTime,
      consumerId: fields[1] as int,
      type: fields[2] as TransactionType,
      balanceBefore: fields[3] as double,
      balanceAfter: fields[4] as double,
      deltaAmount: fields[5] as double,
      deviceName: fields[6] as String,
      note: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.consumerId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.balanceBefore)
      ..writeByte(4)
      ..write(obj.balanceAfter)
      ..writeByte(5)
      ..write(obj.deltaAmount)
      ..writeByte(6)
      ..write(obj.deviceName)
      ..writeByte(7)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = 71;

  @override
  TransactionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionType.water;
      case 1:
        return TransactionType.shower;
      case 2:
        return TransactionType.food;
      case 3:
        return TransactionType.store;
      case 4:
        return TransactionType.topUp;
      case 5:
        return TransactionType.subsidy;
      case 6:
        return TransactionType.coffee;
      case 7:
        return TransactionType.library;
      case 8:
        return TransactionType.other;
      default:
        return TransactionType.water;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    switch (obj) {
      case TransactionType.water:
        writer.writeByte(0);
        break;
      case TransactionType.shower:
        writer.writeByte(1);
        break;
      case TransactionType.food:
        writer.writeByte(2);
        break;
      case TransactionType.store:
        writer.writeByte(3);
        break;
      case TransactionType.topUp:
        writer.writeByte(4);
        break;
      case TransactionType.subsidy:
        writer.writeByte(5);
        break;
      case TransactionType.coffee:
        writer.writeByte(6);
        break;
      case TransactionType.library:
        writer.writeByte(7);
        break;
      case TransactionType.other:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionTypeAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
