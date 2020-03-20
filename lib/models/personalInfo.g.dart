// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personalInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalInfo _$PersonalInfoFromJson(Map<String, dynamic> json) {
  return PersonalInfo()
    ..videoTimes = json['videoTimes'] as num
    ..videoTimes_ratio = json['videoTimes_ratio'] as num
    ..treeComposer = json['treeComposer'] as num
    ..treeComposer_ratio = json['treeComposer_ratio'] as num
    ..deblock_city = json['deblock_city'] as num
    ..deblock_city_ratio = json['deblock_city_ratio'] as num
    ..profit = json['profit'] as num
    ..profit_ratio = json['profit_ratio'] as num
    ..friends_number = json['friends_number'] as num
    ..num_ratio = json['num_ratio'] as num
    ..count_ratio = json['count_ratio'] as num
    ..amount = json['amount'] as String
    ..Invite_code = json['Invite_code'] as String
    ..superior1 = json['superior1'] as String
    ..superior2 = json['superior2'] as String;
}

Map<String, dynamic> _$PersonalInfoToJson(PersonalInfo instance) =>
    <String, dynamic>{
      'videoTimes': instance.videoTimes,
      'videoTimes_ratio': instance.videoTimes_ratio,
      'treeComposer': instance.treeComposer,
      'treeComposer_ratio': instance.treeComposer_ratio,
      'deblock_city': instance.deblock_city,
      'deblock_city_ratio': instance.deblock_city_ratio,
      'profit': instance.profit,
      'profit_ratio': instance.profit_ratio,
      'friends_number': instance.friends_number,
      'num_ratio': instance.num_ratio,
      'count_ratio': instance.count_ratio,
      'amount': instance.amount,
      'Invite_code': instance.Invite_code,
      'superior1': instance.superior1,
      'superior2': instance.superior2
    };
