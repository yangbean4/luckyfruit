import 'package:json_annotation/json_annotation.dart';

part 'reward.g.dart';

@JsonSerializable()
class Reward {
    Reward();

    String type;
    String sign;
    String module;
    String num;
    String content;
    
    factory Reward.fromJson(Map<String,dynamic> json) => _$RewardFromJson(json);
    Map<String, dynamic> toJson() => _$RewardToJson(this);
}
