// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fruit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Fruit {
  String get id => throw _privateConstructorUsedError;
  Vector2 get pos => throw _privateConstructorUsedError;
  double get radius => throw _privateConstructorUsedError;
  PaletteEntry get color => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FruitCopyWith<Fruit> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FruitCopyWith<$Res> {
  factory $FruitCopyWith(Fruit value, $Res Function(Fruit) then) =
      _$FruitCopyWithImpl<$Res, Fruit>;
  @useResult
  $Res call(
      {String id,
      Vector2 pos,
      double radius,
      PaletteEntry color,
      String image});
}

/// @nodoc
class _$FruitCopyWithImpl<$Res, $Val extends Fruit>
    implements $FruitCopyWith<$Res> {
  _$FruitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pos = null,
    Object? radius = null,
    Object? color = null,
    Object? image = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as Vector2,
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as double,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as PaletteEntry,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FruitImplCopyWith<$Res> implements $FruitCopyWith<$Res> {
  factory _$$FruitImplCopyWith(
          _$FruitImpl value, $Res Function(_$FruitImpl) then) =
      __$$FruitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      Vector2 pos,
      double radius,
      PaletteEntry color,
      String image});
}

/// @nodoc
class __$$FruitImplCopyWithImpl<$Res>
    extends _$FruitCopyWithImpl<$Res, _$FruitImpl>
    implements _$$FruitImplCopyWith<$Res> {
  __$$FruitImplCopyWithImpl(
      _$FruitImpl _value, $Res Function(_$FruitImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pos = null,
    Object? radius = null,
    Object? color = null,
    Object? image = null,
  }) {
    return _then(_$FruitImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as Vector2,
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as double,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as PaletteEntry,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FruitImpl extends _Fruit {
  _$FruitImpl(
      {required this.id,
      required this.pos,
      required this.radius,
      required this.color,
      required this.image})
      : super._();

  @override
  final String id;
  @override
  final Vector2 pos;
  @override
  final double radius;
  @override
  final PaletteEntry color;
  @override
  final String image;

  @override
  String toString() {
    return 'Fruit(id: $id, pos: $pos, radius: $radius, color: $color, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FruitImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pos, pos) || other.pos == pos) &&
            (identical(other.radius, radius) || other.radius == radius) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.image, image) || other.image == image));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, pos, radius, color, image);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FruitImplCopyWith<_$FruitImpl> get copyWith =>
      __$$FruitImplCopyWithImpl<_$FruitImpl>(this, _$identity);
}

abstract class _Fruit extends Fruit {
  factory _Fruit(
      {required final String id,
      required final Vector2 pos,
      required final double radius,
      required final PaletteEntry color,
      required final String image}) = _$FruitImpl;
  _Fruit._() : super._();

  @override
  String get id;
  @override
  Vector2 get pos;
  @override
  double get radius;
  @override
  PaletteEntry get color;
  @override
  String get image;
  @override
  @JsonKey(ignore: true)
  _$$FruitImplCopyWith<_$FruitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
