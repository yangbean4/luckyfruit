import 'package:json_annotation/json_annotation.dart';
import "rank_friends.dart";
import "rank_bonus_trees.dart";
part 'ranklist.g.dart';

@JsonSerializable()
class Ranklist {
    Ranklist();

    List<Rank_friends> friends;
    List<Rank_bonus_trees> bounsTrees;
    
    factory Ranklist.fromJson(Map<String,dynamic> json) => _$RanklistFromJson(json);
    Map<String, dynamic> toJson() => _$RanklistToJson(this);
}
