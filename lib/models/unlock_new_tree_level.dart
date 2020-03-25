import 'package:json_annotation/json_annotation.dart';

part 'unlock_new_tree_level.g.dart';

@JsonSerializable()
class Unlock_new_tree_level {
    Unlock_new_tree_level();

    num tree_type;
    num tree_id;
    num amount;
    num duration;
    
    factory Unlock_new_tree_level.fromJson(Map<String,dynamic> json) => _$Unlock_new_tree_levelFromJson(json);
    Map<String, dynamic> toJson() => _$Unlock_new_tree_levelToJson(this);
}
