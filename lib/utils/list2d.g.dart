// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list2d.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

List2D<T> _$List2DFromJson<T>(Map<String, dynamic> json) => List2D<T>(
      (json['rows'] as num?)?.toInt() ?? 0,
      (json['columns'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$List2DToJson<T>(List2D<T> instance) => <String, dynamic>{
      'rows': instance.rows,
      'columns': instance.columns,
    };
