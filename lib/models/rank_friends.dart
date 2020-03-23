import 'package:json_annotation/json_annotation.dart';

part 'rank_friends.g.dart';

@JsonSerializable()
class Rank_friends {
    Rank_friends();

    String acct_id;
    String superior1;
    String rela_account;
    String avatar;
    String amount;
    String separate_amount;
    num tree_num;
    
    factory Rank_friends.fromJson(Map<String,dynamic> json) => _$Rank_friendsFromJson(json);
    Map<String, dynamic> toJson() => _$Rank_friendsToJson(this);
}
