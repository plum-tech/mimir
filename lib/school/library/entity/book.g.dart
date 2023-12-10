// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 105;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Book(
      bookId: fields[0] as String,
      isbn: fields[1] as String,
      title: fields[2] as String,
      author: fields[3] as String,
      publisher: fields[4] as String,
      publishDate: fields[5] as String,
      callNumber: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.bookId)
      ..writeByte(1)
      ..write(obj.isbn)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.author)
      ..writeByte(4)
      ..write(obj.publisher)
      ..writeByte(5)
      ..write(obj.publishDate)
      ..writeByte(6)
      ..write(obj.callNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BookAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class BookDetailsAdapter extends TypeAdapter<BookDetails> {
  @override
  final int typeId = 107;

  @override
  BookDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookDetails(
      details: (fields[0] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, BookDetails obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.details);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookDetailsAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
