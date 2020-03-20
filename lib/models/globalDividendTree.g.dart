// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'globalDividendTree.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GlobalDividendTree _$GlobalDividendTreeFromJson(Map<String, dynamic> json) {
  return GlobalDividendTree()
    ..amount = json['amount'] as num
    ..total = json['total'] as num
    ..today = json['today'] as num
    ..tree_num = json['tree_num'] as num;
}

Map<String, dynamic> _$GlobalDividendTreeToJson(GlobalDividendTree instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'total': instance.total,
      'today': instance.today,
      'tree_num': instance.tree_num
    };
