import 'package:json_annotation/json_annotation.dart';

part 'rank_bonus_trees.g.dart';

@JsonSerializable()
class Rank_bonus_trees {
    Rank_bonus_trees();

    String acct_id;
    String superior1;
    String rela_account;
    String avatar;
    String amount;
    String separate_amount;
    num tree_num;
    
    factory Rank_bonus_trees.fromJson(Map<String,dynamic> json) => _$Rank_bonus_treesFromJson(json);
    Map<String, dynamic> toJson() => _$Rank_bonus_treesToJson(this);
}
