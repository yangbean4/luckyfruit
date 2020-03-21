// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partnerSuperiorItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerSuperiorItem _$PartnerSuperiorItemFromJson(Map<String, dynamic> json) {
  return PartnerSuperiorItem()
    ..avatar = json['avatar'] as String
    ..name = json['name'] as String
    ..fb_login = json['fb_login'] as num
    ..date = json['date'] as String
    ..level = json['level'] as num
    ..today_profit = json['today_profit'] as String;
}

Map<String, dynamic> _$PartnerSuperiorItemToJson(
        PartnerSuperiorItem instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
      'name': instance.name,
      'fb_login': instance.fb_login,
      'date': instance.date,
      'level': instance.level,
      'today_profit': instance.today_profit
    };
