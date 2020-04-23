// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partnerWrap.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerWrap _$PartnerWrapFromJson(Map<String, dynamic> json) {
  return PartnerWrap()
    ..friends = json['friends'] == null
        ? null
        : PartnerSubordinateList.fromJson(
            json['friends'] as Map<String, dynamic>)
    ..superior = json['superior'] == null
        ? null
        : PartnerSuperiorItem.fromJson(json['superior'] as Map<String, dynamic>)
    ..fb_no_login = json['fb_no_login'] as num
    ..direct_profit = json['direct_profit'] as num
    ..indirect_profit = json['indirect_profit'] as num
    ..total_profit = json['total_profit'] as num
    ..friends_total = json['friends_total'] as num
    ..fb_no_login_all_profit = json['fb_no_login_all_profit'] as num
    ..fb_login_today_profit = json['fb_login_today_profit'] as num
    ..fb_login_history_profit = json['fb_login_history_profit'] as num
    ..direct_today_profit = json['direct_today_profit'] as num
    ..indirect_today_profit = json['indirect_today_profit'] as num;
}

Map<String, dynamic> _$PartnerWrapToJson(PartnerWrap instance) =>
    <String, dynamic>{
      'friends': instance.friends,
      'superior': instance.superior,
      'fb_no_login': instance.fb_no_login,
      'direct_profit': instance.direct_profit,
      'indirect_profit': instance.indirect_profit,
      'total_profit': instance.total_profit,
      'friends_total': instance.friends_total,
      'fb_no_login_all_profit': instance.fb_no_login_all_profit,
      'fb_login_today_profit': instance.fb_login_today_profit,
      'fb_login_history_profit': instance.fb_login_history_profit,
      'direct_today_profit': instance.direct_today_profit,
      'indirect_today_profit': instance.indirect_today_profit
    };
