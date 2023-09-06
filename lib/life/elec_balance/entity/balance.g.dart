// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ElectricityBalanceAdapter extends TypeAdapter<ElectricityBalance> {
  @override
  final int typeId = 20;

  @override
  ElectricityBalance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ElectricityBalance(
      fields[2] as String,
      fields[0] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ElectricityBalance obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.balance)
      ..writeByte(2)
      ..write(obj.roomNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ElectricityBalanceAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ElectricityBalance _$ElectricityBalanceFromJson(Map<String, dynamic> json) => ElectricityBalance(
      json['RoomName'] as String,
      _parseBalance(json['Balance'] as String),
    );

Map<String, dynamic> _$ElectricityBalanceToJson(ElectricityBalance instance) => <String, dynamic>{
      'Balance': instance.balance,
      'RoomName': instance.roomNumber,
    };
