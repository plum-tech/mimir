// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SudokuCellCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// SudokuCell(...).copyWith(id: 12, name: "My name")
  /// ````
  SudokuCell call({
    int? userInput,
    int? correctValue,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSudokuCell.copyWith(...)`.
class _$SudokuCellCWProxyImpl implements _$SudokuCellCWProxy {
  const _$SudokuCellCWProxyImpl(this._value);

  final SudokuCell _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// SudokuCell(...).copyWith(id: 12, name: "My name")
  /// ````
  SudokuCell call({
    Object? userInput = const $CopyWithPlaceholder(),
    Object? correctValue = const $CopyWithPlaceholder(),
  }) {
    return SudokuCell(
      userInput: userInput == const $CopyWithPlaceholder() || userInput == null
          ? _value.userInput
          // ignore: cast_nullable_to_non_nullable
          : userInput as int,
      correctValue: correctValue == const $CopyWithPlaceholder() || correctValue == null
          ? _value.correctValue
          // ignore: cast_nullable_to_non_nullable
          : correctValue as int,
    );
  }
}

extension $SudokuCellCopyWith on SudokuCell {
  /// Returns a callable class that can be used as follows: `instanceOfSudokuCell.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$SudokuCellCWProxy get copyWith => _$SudokuCellCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SudokuCell _$SudokuCellFromJson(Map<String, dynamic> json) => SudokuCell(
      userInput: (json['userInput'] as num).toInt(),
      correctValue: (json['correctValue'] as num).toInt(),
    );

Map<String, dynamic> _$SudokuCellToJson(SudokuCell instance) => <String, dynamic>{
      'userInput': instance.userInput,
      'correctValue': instance.correctValue,
    };
