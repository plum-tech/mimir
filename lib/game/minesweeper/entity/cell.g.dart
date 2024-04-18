// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cell.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CellCWProxy {
  Cell row(int row);

  Cell column(int column);

  Cell mine(bool mine);

  Cell state(CellState state);

  Cell minesAround(int minesAround);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Cell(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Cell(...).copyWith(id: 12, name: "My name")
  /// ````
  Cell call({
    int? row,
    int? column,
    bool? mine,
    CellState? state,
    int? minesAround,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCell.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCell.copyWith.fieldName(...)`
class _$CellCWProxyImpl implements _$CellCWProxy {
  const _$CellCWProxyImpl(this._value);

  final Cell _value;

  @override
  Cell row(int row) => this(row: row);

  @override
  Cell column(int column) => this(column: column);

  @override
  Cell mine(bool mine) => this(mine: mine);

  @override
  Cell state(CellState state) => this(state: state);

  @override
  Cell minesAround(int minesAround) => this(minesAround: minesAround);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Cell(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Cell(...).copyWith(id: 12, name: "My name")
  /// ````
  Cell call({
    Object? row = const $CopyWithPlaceholder(),
    Object? column = const $CopyWithPlaceholder(),
    Object? mine = const $CopyWithPlaceholder(),
    Object? state = const $CopyWithPlaceholder(),
    Object? minesAround = const $CopyWithPlaceholder(),
  }) {
    return Cell(
      row: row == const $CopyWithPlaceholder() || row == null
          ? _value.row
          // ignore: cast_nullable_to_non_nullable
          : row as int,
      column: column == const $CopyWithPlaceholder() || column == null
          ? _value.column
          // ignore: cast_nullable_to_non_nullable
          : column as int,
      mine: mine == const $CopyWithPlaceholder() || mine == null
          ? _value.mine
          // ignore: cast_nullable_to_non_nullable
          : mine as bool,
      state: state == const $CopyWithPlaceholder() || state == null
          ? _value.state
          // ignore: cast_nullable_to_non_nullable
          : state as CellState,
      minesAround: minesAround == const $CopyWithPlaceholder() || minesAround == null
          ? _value.minesAround
          // ignore: cast_nullable_to_non_nullable
          : minesAround as int,
    );
  }
}

extension $CellCopyWith on Cell {
  /// Returns a callable class that can be used as follows: `instanceOfCell.copyWith(...)` or like so:`instanceOfCell.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CellCWProxy get copyWith => _$CellCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cell _$CellFromJson(Map<String, dynamic> json) => Cell(
      row: json['row'] as int,
      column: json['column'] as int,
      mine: json['mine'] as bool? ?? false,
      state: $enumDecodeNullable(_$CellStateEnumMap, json['state']) ?? CellState.covered,
      minesAround: json['minesAround'] as int,
    );

Map<String, dynamic> _$CellToJson(Cell instance) => <String, dynamic>{
      'row': instance.row,
      'column': instance.column,
      'mine': instance.mine,
      'state': _$CellStateEnumMap[instance.state]!,
      'minesAround': instance.minesAround,
    };

const _$CellStateEnumMap = {
  CellState.covered: 0,
  CellState.blank: 1,
  CellState.flag: 2,
};
