// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cell4Save _$Cell4SaveFromJson(Map<String, dynamic> json) => Cell4Save(
      userInput: (json['userInput'] as num?)?.toInt() ?? SudokuCell.disableInputNumber,
      correctValue: (json['correctValue'] as num?)?.toInt() ?? SudokuCell.emptyInputNumber,
    );

Map<String, dynamic> _$Cell4SaveToJson(Cell4Save instance) => <String, dynamic>{
      'userInput': instance.userInput,
      'correctValue': instance.correctValue,
    };

SaveSudoku _$SaveSudokuFromJson(Map<String, dynamic> json) => SaveSudoku(
      cells: json['cells'] == null
          ? _defaultCells()
          : List2D<Cell4Save>.fromJson(
              json['cells'] as Map<String, dynamic>, (value) => Cell4Save.fromJson(value as Map<String, dynamic>)),
      playtime: json['playtime'] == null ? Duration.zero : Duration(microseconds: (json['playtime'] as num).toInt()),
      mode: json['mode'] == null ? GameModeSudoku.easy : GameModeSudoku.fromJson(json['mode'] as String),
      notes: (json['notes'] as List<dynamic>?)?.map(SudokuCellNote.fromJson).toList() ?? _defaultNotes(),
    );

Map<String, dynamic> _$SaveSudokuToJson(SaveSudoku instance) => <String, dynamic>{
      'cells': instance.cells.toJson(
        (value) => value,
      ),
      'playtime': instance.playtime.inMicroseconds,
      'mode': instance.mode,
      'notes': instance.notes,
    };
