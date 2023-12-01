// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holding_preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HoldingPreviewItem _$HoldingPreviewItemFromJson(Map<String, dynamic> json) => HoldingPreviewItem(
      bookId: json['bookrecno'] as int,
      barcode: json['barcode'] as String,
      callNumber: json['callno'] as String,
      currentLibrary: json['curlibName'] as String,
      currentLocation: json['curlocalName'] as String,
      copyCount: json['copycount'] as int,
      loanableCount: json['loanableCount'] as int,
    );

Map<String, dynamic> _$HoldingPreviewItemToJson(HoldingPreviewItem instance) => <String, dynamic>{
      'bookrecno': instance.bookId,
      'barcode': instance.barcode,
      'callno': instance.callNumber,
      'curlibName': instance.currentLibrary,
      'curlocalName': instance.currentLocation,
      'copycount': instance.copyCount,
      'loanableCount': instance.loanableCount,
    };
