// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lottoRewardListItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LottoRewardListItem _$LottoRewardListItemFromJson(Map<String, dynamic> json) {
  return LottoRewardListItem()
    ..lottery_draw_num = json['lottery_draw_num'] as String
    ..lottery_plus_one_num = json['lottery_plus_one_num'] as String
    ..winning_grade = json['winning_grade'] as num;
}

Map<String, dynamic> _$LottoRewardListItemToJson(
        LottoRewardListItem instance) =>
    <String, dynamic>{
      'lottery_draw_num': instance.lottery_draw_num,
      'lottery_plus_one_num': instance.lottery_plus_one_num,
      'winning_grade': instance.winning_grade
    };
