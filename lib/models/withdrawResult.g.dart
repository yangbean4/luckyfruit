// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdrawResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawResult _$WithdrawResultFromJson(Map<String, dynamic> json) {
  return WithdrawResult()
    ..msg = json['msg'] as String
    ..code = json['code'] as num;
}

Map<String, dynamic> _$WithdrawResultToJson(WithdrawResult instance) =>
    <String, dynamic>{'msg': instance.msg, 'code': instance.code};
