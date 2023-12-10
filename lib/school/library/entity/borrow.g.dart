// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrow.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BorrowedBookItemAdapter extends TypeAdapter<BorrowedBookItem> {
  @override
  final int typeId = 108;

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

class BookBorrowingHistoryItemAdapter extends TypeAdapter<BookBorrowingHistoryItem> {
  @override
  final int typeId = 109;

  @override
  BookBorrowingHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookBorrowingHistoryItem(
      bookId: fields[0] as String,
      operation: fields[2] as BookBorrowingHistoryOperation,
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
  void write(BinaryWriter writer, BookBorrowingHistoryItem obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.bookId)
      ..writeByte(1)
      ..write(obj.processDate)
      ..writeByte(2)
      ..write(obj.operation)
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
      other is BookBorrowingHistoryItemAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class BookBorrowingHistoryOperationAdapter extends TypeAdapter<BookBorrowingHistoryOperation> {
  @override
  final int typeId = 110;

  @override
  BookBorrowingHistoryOperation read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BookBorrowingHistoryOperation.borrowing;
      case 1:
        return BookBorrowingHistoryOperation.returning;
      default:
        return BookBorrowingHistoryOperation.borrowing;
    }
  }

  @override
  void write(BinaryWriter writer, BookBorrowingHistoryOperation obj) {
    switch (obj) {
      case BookBorrowingHistoryOperation.borrowing:
        writer.writeByte(0);
        break;
      case BookBorrowingHistoryOperation.returning:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookBorrowingHistoryOperationAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
