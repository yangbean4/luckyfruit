// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..acct_id = json['acct_id'] as String
    ..nickname = json['nickname'] as String
    ..icon_path = json['icon_path'] as String
    ..rela_type = json['rela_type'] as String
    ..rela_account = json['rela_account'] as String
    ..last_leave_time = json['last_leave_time'] as String
    ..active = json['active'] as String
    ..acct_bal = json['acct_bal'] as num
    ..separate_amount = json['separate_amount'] as String
    ..coin = json['coin'] as String
    ..version = json['version'] as String
    ..share_version = json['share_version'] as String
    ..sign_times = json['sign_times'] as num
    ..last_draw_time = json['last_draw_time'] as String
    ..level = json['level'] as String
    ..ticket = json['ticket'] as num
    ..deblock_city = json['deblock_city'] as String
    ..ticket_time = json['ticket_time'] as num
    ..is_m = json['is_m'] as num
    ..is_dl_p = json['is_dl_p'] as num
    ..update_time = json['update_time'] as String
    ..today_profit_update_time = json['today_profit_update_time'] as String
    ..profit_update_time = json['profit_update_time'] as String
    ..access_token = json['access_token'] as String
    ..device_id = json['device_id'] as String
    ..invite_friend = json['invite_friend'] as List
    ..residue_7days_time = json['residue_7days_time'] as List
    ..lotto_residue_time = json['lotto_residue_time'] as num
    ..lotto_nums = json['lotto_nums'] as num
    ..flower_nums = json['flower_nums'] as num
    ..attack_num = json['attack_num'] as num;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'acct_id': instance.acct_id,
      'nickname': instance.nickname,
      'icon_path': instance.icon_path,
      'rela_type': instance.rela_type,
      'rela_account': instance.rela_account,
      'last_leave_time': instance.last_leave_time,
      'active': instance.active,
      'acct_bal': instance.acct_bal,
      'separate_amount': instance.separate_amount,
      'coin': instance.coin,
      'version': instance.version,
      'share_version': instance.share_version,
      'sign_times': instance.sign_times,
      'last_draw_time': instance.last_draw_time,
      'level': instance.level,
      'ticket': instance.ticket,
      'deblock_city': instance.deblock_city,
      'ticket_time': instance.ticket_time,
      'is_m': instance.is_m,
      'is_dl_p': instance.is_dl_p,
      'update_time': instance.update_time,
      'today_profit_update_time': instance.today_profit_update_time,
      'profit_update_time': instance.profit_update_time,
      'access_token': instance.access_token,
      'device_id': instance.device_id,
      'invite_friend': instance.invite_friend,
      'residue_7days_time': instance.residue_7days_time,
      'lotto_residue_time': instance.lotto_residue_time,
      'lotto_nums': instance.lotto_nums,
      'flower_nums': instance.flower_nums,
      'attack_num': instance.attack_num
    };
