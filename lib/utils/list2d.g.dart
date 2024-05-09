// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list2d.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

List2D<T> _$List2DFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    List2D<T>(
      (json['rows'] as num?)?.toInt() ?? 0,
      (json['columns'] as num?)?.toInt() ?? 0,
      (json['internal'] as List<dynamic>?)?.map(fromJsonT).toList() ?? const [],
    );

Map<String, dynamic> _$List2DToJson<T>(
  List2D<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'internal': instance._internal.map(toJsonT).toList(),
      'rows': instance.rows,
      'columns': instance.columns,
    };
