// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Issued.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Issued _$IssuedFromJson(Map<String, dynamic> json) {
  return Issued()
    ..random_m_level = json['random_m_level'] as num
    ..random_space_time = json['random_space_time'] as num
    ..purchase_tree_level = json['purchase_tree_level'] as num
    ..compose_numbers = json['compose_numbers'] as num
    ..box_remain_time = json['box_remain_time'] as num
    ..game_timeLen = json['game_timeLen'] as num
    ..two_adSpace = json['two_adSpace'] as num
    ..reward_multiple = json['reward_multiple'] as num
    ..automatic_time = json['automatic_time'] as num
    ..automatic_game_timelen = json['automatic_game_timelen'] as num
    ..automatic_two_adSpace = json['automatic_two_adSpace'] as num
    ..automatic_remain_time = json['automatic_remain_time'] as num
    ..balloon_timeLen = json['balloon_timeLen'] as num
    ..balloon_adSpace = json['balloon_adSpace'] as num
    ..balloon_time = json['balloon_time'] as num
    ..balloon_remain_time = json['balloon_remain_time'] as num
    ..coin_award = json['coin_award'] as num
    ..box_time = json['box_time'] as num
    ..double_coin_remain_time = json['double_coin_remain_time'] as num
    ..double_coin_time = json['double_coin_time'] as num
    ..hops_reward = json['hops_reward'] as num
    ..first_reward_coin = json['first_reward_coin'] as num
    ..cash_amount_list = (json['cash_amount_list'] as List)
        ?.map((e) =>
            e == null ? null : Cash_amount.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..ad_reset_time = json['ad_reset_time'] as num
    ..merge_number = json['merge_number'] as num
    ..level_up_reward_multipe = json['level_up_reward_multipe'] as num
    ..randon_remain_time = json['randon_remain_time'] as num;
}

Map<String, dynamic> _$IssuedToJson(Issued instance) => <String, dynamic>{
      'random_m_level': instance.random_m_level,
      'random_space_time': instance.random_space_time,
      'purchase_tree_level': instance.purchase_tree_level,
      'compose_numbers': instance.compose_numbers,
      'box_remain_time': instance.box_remain_time,
      'game_timeLen': instance.game_timeLen,
      'two_adSpace': instance.two_adSpace,
      'reward_multiple': instance.reward_multiple,
      'automatic_time': instance.automatic_time,
      'automatic_game_timelen': instance.automatic_game_timelen,
      'automatic_two_adSpace': instance.automatic_two_adSpace,
      'automatic_remain_time': instance.automatic_remain_time,
      'balloon_timeLen': instance.balloon_timeLen,
      'balloon_adSpace': instance.balloon_adSpace,
      'balloon_time': instance.balloon_time,
      'balloon_remain_time': instance.balloon_remain_time,
      'coin_award': instance.coin_award,
      'box_time': instance.box_time,
      'double_coin_remain_time': instance.double_coin_remain_time,
      'double_coin_time': instance.double_coin_time,
      'hops_reward': instance.hops_reward,
      'first_reward_coin': instance.first_reward_coin,
      'cash_amount_list': instance.cash_amount_list,
      'ad_reset_time': instance.ad_reset_time,
      'merge_number': instance.merge_number,
      'level_up_reward_multipe': instance.level_up_reward_multipe,
      'randon_remain_time': instance.randon_remain_time
    };
