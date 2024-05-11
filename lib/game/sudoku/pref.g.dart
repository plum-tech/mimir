// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pref.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GamePrefSudokuCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GamePrefSudoku(...).copyWith(id: 12, name: "My name")
  /// ````
  GamePrefSudoku call({
    GameMode? mode,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGamePrefSudoku.copyWith(...)`.
class _$GamePrefSudokuCWProxyImpl implements _$GamePrefSudokuCWProxy {
  const _$GamePrefSudokuCWProxyImpl(this._value);

  final GamePrefSudoku _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GamePrefSudoku(...).copyWith(id: 12, name: "My name")
  /// ````
  GamePrefSudoku call({
    Object? mode = const $CopyWithPlaceholder(),
  }) {
    return GamePrefSudoku(
      mode: mode == const $CopyWithPlaceholder() || mode == null
          ? _value.mode
          // ignore: cast_nullable_to_non_nullable
          : mode as GameMode,
    );
  }
}

extension $GamePrefSudokuCopyWith on GamePrefSudoku {
  /// Returns a callable class that can be used as follows: `instanceOfGamePrefSudoku.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$GamePrefSudokuCWProxy get copyWith => _$GamePrefSudokuCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GamePrefSudoku _$GamePrefSudokuFromJson(Map<String, dynamic> json) => GamePrefSudoku(
      mode: json['mode'] == null ? GameMode.easy : GameMode.fromJson(json['mode'] as String),
    );

Map<String, dynamic> _$GamePrefSudokuToJson(GamePrefSudoku instance) => <String, dynamic>{
      'mode': instance.mode,
    };
