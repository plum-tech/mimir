// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DatapackRaw _$DatapackRawFromJson(Map<String, dynamic> json) => DatapackRaw()
  ..retcode = json['retcode'] as int
  ..retcount = json['retcount'] as int
  ..retdata = (json['retdata'] as List<dynamic>).map((e) => TransactionRaw.fromJson(e as Map<String, dynamic>)).toList()
  ..retmsg = json['retmsg'] as String;

Map<String, dynamic> _$DatapackRawToJson(DatapackRaw instance) => <String, dynamic>{
      'retcode': instance.retcode,
      'retcount': instance.retcount,
      'retdata': instance.retdata,
      'retmsg': instance.retmsg,
    };

TransactionRaw _$TransactionRawFromJson(Map<String, dynamic> json) => TransactionRaw()
  ..transdate = json['transdate'] as String
  ..transtime = json['transtime'] as String
  ..custid = json['custid'] as int
  ..transflag = json['transflag'] as int
  ..cardbefbal = (json['cardbefbal'] as num).toDouble()
  ..cardaftbal = (json['cardaftbal'] as num).toDouble()
  ..amount = (json['amount'] as num).toDouble()
  ..devicename = json['devicename'] as String?
  ..transname = json['transname'] as String;

Map<String, dynamic> _$TransactionRawToJson(TransactionRaw instance) => <String, dynamic>{
      'transdate': instance.transdate,
      'transtime': instance.transtime,
      'custid': instance.custid,
      'transflag': instance.transflag,
      'cardbefbal': instance.cardbefbal,
      'cardaftbal': instance.cardaftbal,
      'amount': instance.amount,
      'devicename': instance.devicename,
      'transname': instance.transname,
    };
