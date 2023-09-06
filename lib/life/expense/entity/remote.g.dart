// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataPackRaw _$DataPackRawFromJson(Map<String, dynamic> json) => DataPackRaw(
      code: json['retcode'] as int,
      count: json['retcount'] as int,
      transactions:
          (json['retdata'] as List<dynamic>).map((e) => TransactionRaw.fromJson(e as Map<String, dynamic>)).toList(),
      message: json['retmsg'] as String,
    );

TransactionRaw _$TransactionRawFromJson(Map<String, dynamic> json) => TransactionRaw(
      date: json['transdate'] as String,
      time: json['transtime'] as String,
      customerId: json['custid'] as int,
      flag: json['transflag'] as int,
      balanceBeforeTransaction: (json['cardbefbal'] as num).toDouble(),
      balanceAfterTransaction: (json['cardaftbal'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      deviceName: json['devicename'] as String?,
      name: json['transname'] as String,
    );
