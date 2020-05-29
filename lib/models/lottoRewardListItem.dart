import 'package:json_annotation/json_annotation.dart';

part 'lottoRewardListItem.g.dart';

@JsonSerializable()
class LottoRewardListItem {
    LottoRewardListItem();

    String lottery_draw_num;
    String lottery_plus_one_num;
    num winning_grade;
    
    factory LottoRewardListItem.fromJson(Map<String,dynamic> json) => _$LottoRewardListItemFromJson(json);
    Map<String, dynamic> toJson() => _$LottoRewardListItemToJson(this);
}
