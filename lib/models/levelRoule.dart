import 'package:json_annotation/json_annotation.dart';

part 'levelRoule.g.dart';

@JsonSerializable()
class LevelRoule {
    LevelRoule();

    String id;
    String level;
    String need_coin_prefix;
    String need_coin_times;
    String deblock_city;
    String award_coin_prefix;
    String award_coin_time;
    
    factory LevelRoule.fromJson(Map<String,dynamic> json) => _$LevelRouleFromJson(json);
    Map<String, dynamic> toJson() => _$LevelRouleToJson(this);
}
