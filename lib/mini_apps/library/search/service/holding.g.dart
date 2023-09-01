// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holding.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CirculateType _$CirculateTypeFromJson(Map<String, dynamic> json) =>
    _CirculateType(
      json['cirtype'] as String,
      json['libcode'] as String,
      json['name'] as String,
      json['descripe'] as String,
      json['loanNumSign'] as int,
      json['isPreviService'] as int,
    );

Map<String, dynamic> _$CirculateTypeToJson(_CirculateType instance) =>
    <String, dynamic>{
      'cirtype': instance.circulateType,
      'libcode': instance.libraryCode,
      'name': instance.name,
      'descripe': instance.description,
      'loanNumSign': instance.loanNumSign,
      'isPreviService': instance.isPreviService,
    };

_HoldState _$HoldStateFromJson(Map<String, dynamic> json) => _HoldState(
      json['stateType'] as int,
      json['stateName'] as String,
    );

Map<String, dynamic> _$HoldStateToJson(_HoldState instance) =>
    <String, dynamic>{
      'stateType': instance.stateType,
      'stateName': instance.stateName,
    };

_HoldingItem _$HoldingItemFromJson(Map<String, dynamic> json) => _HoldingItem(
      json['recno'] as int,
      json['bookrecno'] as int,
      json['state'] as int,
      json['barcode'] as String,
      json['callno'] as String,
      json['orglib'] as String,
      json['orglocal'] as String,
      json['curlib'] as String,
      json['curlocal'] as String,
      json['cirtype'] as String,
      json['regdate'] as String,
      json['indate'] as String,
      (json['singlePrice'] as num).toDouble(),
      (json['totalPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$HoldingItemToJson(_HoldingItem instance) =>
    <String, dynamic>{
      'recno': instance.bookRecordId,
      'bookrecno': instance.bookId,
      'state': instance.stateType,
      'barcode': instance.barcode,
      'callno': instance.callNo,
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

_BookHoldingInfo _$BookHoldingInfoFromJson(Map<String, dynamic> json) =>
    _BookHoldingInfo(
      (json['holdingList'] as List<dynamic>)
          .map((e) => _HoldingItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      Map<String, String>.from(json['libcodeMap'] as Map),
      Map<String, String>.from(json['localMap'] as Map),
      (json['pBCtypeMap'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, _CirculateType.fromJson(e as Map<String, dynamic>)),
      ),
      (json['holdStateMap'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, _HoldState.fromJson(e as Map<String, dynamic>)),
      ),
      Map<String, int>.from(json['libcodeDeferDateMap'] as Map),
      Map<String, String>.from(json['barcodeLocationUrlMap'] as Map),
    );

Map<String, dynamic> _$BookHoldingInfoToJson(_BookHoldingInfo instance) =>
    <String, dynamic>{
      'holdingList': instance.holdingList,
      'libcodeMap': instance.libraryCodeMap,
      'localMap': instance.locationMap,
      'pBCtypeMap': instance.circulateTypeMap,
      'holdStateMap': instance.holdStateMap,
      'libcodeDeferDateMap': instance.libcodeDeferDateMap,
      'barcodeLocationUrlMap': instance.barcodeLocationUrlMap,
    };
