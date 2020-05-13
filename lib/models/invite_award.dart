import 'package:json_annotation/json_annotation.dart';

part 'invite_award.g.dart';

@JsonSerializable()
class Invite_award {
    Invite_award();

    num tree_type;
    num tree_id;
    num amount;
    num duration;
    
    factory Invite_award.fromJson(Map<String,dynamic> json) => _$Invite_awardFromJson(json);
    Map<String, dynamic> toJson() => _$Invite_awardToJson(this);
}
