import 'package:json_annotation/json_annotation.dart';
import "sign.dart";
import "reward.dart";
part 'drawInfo.g.dart';

@JsonSerializable()
class DrawInfo {
    DrawInfo();

    List<Sign> sign;
    List<Reward> reward;
    
    factory DrawInfo.fromJson(Map<String,dynamic> json) => _$DrawInfoFromJson(json);
    Map<String, dynamic> toJson() => _$DrawInfoToJson(this);
}
