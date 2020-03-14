import 'package:json_annotation/json_annotation.dart';

part 'Issued.g.dart';

@JsonSerializable()
class Issued {
    Issued();

    num game_timeLen;
    num two_adSpace;
    num reward_multiple;
    num limited_time;
    num automatic_time;
    num random_m_level;
    num random_space_time;
    num purchase_tree_level;
    num compose_numbers;
    num automatic_game_timelen;
    num automatic_two_adSpace;
    num balloon_timeLen;
    num balloon_adSpace;
    num balloon_time;
    
    factory Issued.fromJson(Map<String,dynamic> json) => _$IssuedFromJson(json);
    Map<String, dynamic> toJson() => _$IssuedToJson(this);
}