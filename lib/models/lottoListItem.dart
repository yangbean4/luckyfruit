import 'package:json_annotation/json_annotation.dart';
import "lottoRewardListItem.dart";
part 'lottoListItem.g.dart';

@JsonSerializable()
class LottoListItem {
    LottoListItem();

    String acct_id;
    String awards_date;
    String is_cash_prize;
    String update_time;
    String lottery_draw_num_win;
    String lottery_plus_one_num_win;
    List countdown_prize;
    List<LottoRewardListItem> reward_list;
    
    factory LottoListItem.fromJson(Map<String,dynamic> json) => _$LottoListItemFromJson(json);
    Map<String, dynamic> toJson() => _$LottoListItemToJson(this);
}
