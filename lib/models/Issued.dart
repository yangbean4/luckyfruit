import 'package:json_annotation/json_annotation.dart';
import "cash_amount.dart";
part 'Issued.g.dart';

@JsonSerializable()
class Issued {
    Issued();

    num random_m_level;
    num random_space_time;
    num purchase_tree_level;
    num compose_numbers;
    num box_remain_time;
    num game_timeLen;
    num two_adSpace;
    num reward_multiple;
    num automatic_time;
    num automatic_game_timelen;
    num automatic_two_adSpace;
    num automatic_remain_time;
    num balloon_timeLen;
    num balloon_adSpace;
    num balloon_time;
    num balloon_remain_time;
    num coin_award;
    num box_time;
    num double_coin_remain_time;
    num double_coin_time;
    num hops_reward;
    num first_reward_coin;
    List<Cash_amount> cash_amount_list;
    num ad_reset_time;
    num merge_number;
    num level_up_reward_multipe;
    num randon_remain_time;
    
    factory Issued.fromJson(Map<String,dynamic> json) => _$IssuedFromJson(json);
    Map<String, dynamic> toJson() => _$IssuedToJson(this);
}
