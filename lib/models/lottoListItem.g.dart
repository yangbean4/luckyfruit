// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lottoListItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LottoListItem _$LottoListItemFromJson(Map<String, dynamic> json) {
  return LottoListItem()
    ..acct_id = json['acct_id'] as String
    ..awards_date = json['awards_date'] as String
    ..winning_grade = json['winning_grade'] as String
    ..is_cash_prize = json['is_cash_prize'] as String
    ..update_time = json['update_time'] as String
    ..lottery_draw_num_win = json['lottery_draw_num_win'] as String
    ..lottery_plus_one_num_win = json['lottery_plus_one_num_win'] as String
    ..countdown_prize = json['countdown_prize'] as List
    ..reward_list = json['reward_list'] as List;
}

Map<String, dynamic> _$LottoListItemToJson(LottoListItem instance) =>
    <String, dynamic>{
      'acct_id': instance.acct_id,
      'awards_date': instance.awards_date,
      'winning_grade': instance.winning_grade,
      'is_cash_prize': instance.is_cash_prize,
      'update_time': instance.update_time,
      'lottery_draw_num_win': instance.lottery_draw_num_win,
      'lottery_plus_one_num_win': instance.lottery_plus_one_num_win,
      'countdown_prize': instance.countdown_prize,
      'reward_list': instance.reward_list
    };
