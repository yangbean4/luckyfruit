import 'package:json_annotation/json_annotation.dart';

part 'unlockNewTreeLevel.g.dart';

@JsonSerializable()
class UnlockNewTreeLevel {
    UnlockNewTreeLevel();

    num tree_type;
    num tree_id;
    num amount;
    num duration;
    
    factory UnlockNewTreeLevel.fromJson(Map<String,dynamic> json) => _$UnlockNewTreeLevelFromJson(json);
    Map<String, dynamic> toJson() => _$UnlockNewTreeLevelToJson(this);
}
