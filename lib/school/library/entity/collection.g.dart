// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookCirculateType _$BookCirculateTypeFromJson(Map<String, dynamic> json) => BookCirculateType(
      json['cirtype'] as String,
      json['libcode'] as String,
      json['name'] as String,
      json['descripe'] as String,
      (json['loanNumSign'] as num).toInt(),
      (json['isPreviService'] as num).toInt(),
    );

Map<String, dynamic> _$BookCirculateTypeToJson(BookCirculateType instance) => <String, dynamic>{
      'cirtype': instance.circulateType,
      'libcode': instance.libraryCode,
      'name': instance.name,
      'descripe': instance.description,
      'loanNumSign': instance.loanNumSign,
      'isPreviService': instance.isPreviService,
    };

BookCollectionState _$BookCollectionStateFromJson(Map<String, dynamic> json) => BookCollectionState(
      (json['stateType'] as num).toInt(),
      json['stateName'] as String,
    );

Map<String, dynamic> _$BookCollectionStateToJson(BookCollectionState instance) => <String, dynamic>{
      'stateType': instance.stateType,
      'stateName': instance.stateName,
    };

BookCollectionItem _$BookCollectionItemFromJson(Map<String, dynamic> json) => BookCollectionItem(
      bookRecordId: (json['recno'] as num).toInt(),
      bookId: (json['bookrecno'] as num).toInt(),
      stateType: (json['state'] as num).toInt(),
      barcode: json['barcode'] as String,
      callNumber: json['callno'] as String,
      originLibraryCode: json['orglib'] as String,
      originLocationCode: json['orglocal'] as String,
      currentLibraryCode: json['curlib'] as String,
      currentLocationCode: json['curlocal'] as String,
      circulateType: json['cirtype'] as String,
      registerDate: json['regdate'] as String,
      inDate: json['indate'] as String,
      singlePrice: (json['singlePrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$BookCollectionItemToJson(BookCollectionItem instance) => <String, dynamic>{
      'recno': instance.bookRecordId,
      'bookrecno': instance.bookId,
      'state': instance.stateType,
      'barcode': instance.barcode,
      'callno': instance.callNumber,
      'orglib': instance.originLibraryCode,
      'orglocal': instance.originLocationCode,
      'curlib': instance.currentLibraryCode,
      'curlocal': instance.currentLocationCode,
      'cirtype': instance.circulateType,
      'regdate': instance.registerDate,
      'indate': instance.inDate,
      'singlePrice': instance.singlePrice,
      'totalPrice': instance.totalPrice,
    };

BookCollectionInfo _$BookCollectionInfoFromJson(Map<String, dynamic> json) => BookCollectionInfo(
      holdingList: (json['holdingList'] as List<dynamic>)
          .map((e) => BookCollectionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      libraryCodeMap: Map<String, String>.from(json['libcodeMap'] as Map),
      locationMap: Map<String, String>.from(json['localMap'] as Map),
      circulateTypeMap: (json['pBCtypeMap'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, BookCirculateType.fromJson(e as Map<String, dynamic>)),
      ),
      holdStateMap: (json['holdStateMap'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, BookCollectionState.fromJson(e as Map<String, dynamic>)),
      ),
      libcodeDeferDateMap: Map<String, int>.from(json['libcodeDeferDateMap'] as Map),
      barcodeLocationUrlMap: Map<String, String>.from(json['barcodeLocationUrlMap'] as Map),
    );

Map<String, dynamic> _$BookCollectionInfoToJson(BookCollectionInfo instance) => <String, dynamic>{
      'holdingList': instance.holdingList,
      'libcodeMap': instance.libraryCodeMap,
      'localMap': instance.locationMap,
      'pBCtypeMap': instance.circulateTypeMap,
      'holdStateMap': instance.holdStateMap,
      'libcodeDeferDateMap': instance.libcodeDeferDateMap,
      'barcodeLocationUrlMap': instance.barcodeLocationUrlMap,
    };
