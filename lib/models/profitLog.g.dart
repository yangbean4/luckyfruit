// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profitLog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfitLog _$ProfitLogFromJson(Map<String, dynamic> json) {
  return ProfitLog()
    ..amount = json['amount'] as String
    ..module = json['module'] as String
    ..start_time = json['start_time'] as String
    ..add_time = json['add_time'] as String;
}

Map<String, dynamic> _$ProfitLogToJson(ProfitLog instance) => <String, dynamic>{
      'amount': instance.amount,
      'module': instance.module,
      'start_time': instance.start_time,
      'add_time': instance.add_time
    };
