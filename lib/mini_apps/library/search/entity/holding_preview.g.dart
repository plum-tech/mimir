// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holding_preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HoldingPreviewItem _$HoldingPreviewItemFromJson(Map<String, dynamic> json) => HoldingPreviewItem(
      json['bookrecno'] as int,
      json['barcode'] as String,
      json['callno'] as String,
      json['curlibName'] as String,
      json['curlocalName'] as String,
      json['copycount'] as int,
      json['loanableCount'] as int,
    );

Map<String, dynamic> _$HoldingPreviewItemToJson(HoldingPreviewItem instance) => <String, dynamic>{
      'bookrecno': instance.bookId,
      'barcode': instance.barcode,
      'callno': instance.callNo,
      'curlibName': instance.currentLibrary,
      'curlocalName': instance.currentLocation,
      'copycount': instance.copyCount,
      'loanableCount': instance.loanableCount,
    };

HoldingPreviews _$HoldingPreviewsFromJson(Map<String, dynamic> json) => HoldingPreviews(
      (json['previews'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, (e as List<dynamic>).map((e) => HoldingPreviewItem.fromJson(e as Map<String, dynamic>)).toList()),
      ),
    );

Map<String, dynamic> _$HoldingPreviewsToJson(HoldingPreviews instance) => <String, dynamic>{
      'previews': instance.previews,
    };
