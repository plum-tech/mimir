// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrow.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BorrowedBookItemAdapter extends TypeAdapter<BorrowedBookItem> {
  @override
  final int typeId = 82;

  @override
  BorrowedBookItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BorrowedBookItem(
      bookId: fields[0] as String,
      barcode: fields[3] as String,
      isbn: fields[4] as String,
      author: fields[8] as String,
      title: fields[6] as String,
      callNumber: fields[5] as String,
      location: fields[7] as String,
      type: fields[9] as String,
      borrowDate: fields[1] as DateTime,
      expireDate: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BorrowedBookItem obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.bookId)
      ..writeByte(1)
      ..write(obj.borrowDate)
      ..writeByte(2)
      ..write(obj.expireDate)
      ..writeByte(3)
      ..write(obj.barcode)
      ..writeByte(4)
      ..write(obj.isbn)
      ..writeByte(5)
      ..write(obj.callNumber)
      ..writeByte(6)
      ..write(obj.title)
      ..writeByte(7)
      ..write(obj.location)
      ..writeByte(8)
      ..write(obj.author)
      ..writeByte(9)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BorrowedBookItemAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class BookBorrowHistoryItemAdapter extends TypeAdapter<BookBorrowHistoryItem> {
  @override
  final int typeId = 83;

  @override
  BookBorrowHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookBorrowHistoryItem(
      bookId: fields[0] as String,
      operateType: fields[2] as String,
      barcode: fields[3] as String,
      title: fields[4] as String,
      isbn: fields[5] as String,
      callNumber: fields[6] as String,
      location: fields[8] as String,
      type: fields[9] as String,
      author: fields[7] as String,
      processDate: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BookBorrowHistoryItem obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.bookId)
      ..writeByte(1)
      ..write(obj.processDate)
      ..writeByte(2)
      ..write(obj.operateType)
      ..writeByte(3)
      ..write(obj.barcode)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.isbn)
      ..writeByte(6)
      ..write(obj.callNumber)
      ..writeByte(7)
      ..write(obj.author)
      ..writeByte(8)
      ..write(obj.location)
      ..writeByte(9)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookBorrowHistoryItemAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
