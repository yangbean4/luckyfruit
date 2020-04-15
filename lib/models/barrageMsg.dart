import 'package:json_annotation/json_annotation.dart';

part 'barrageMsg.g.dart';

@JsonSerializable()
class BarrageMsg {
    BarrageMsg();

    String id;
    String punch_time;
    String nickname;
    String num;
    String module;
    
    factory BarrageMsg.fromJson(Map<String,dynamic> json) => _$BarrageMsgFromJson(json);
    Map<String, dynamic> toJson() => _$BarrageMsgToJson(this);
}
