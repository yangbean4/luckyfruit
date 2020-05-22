import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
    Message();

    String id;
    String order_id;
    String gift_id;
    String wdl_amt;
    String wdl_status;
    String claim_code;
    String chan_type;
    String msg_content;
    String type;
    String create_time;
    
    factory Message.fromJson(Map<String,dynamic> json) => _$MessageFromJson(json);
    Map<String, dynamic> toJson() => _$MessageToJson(this);
}
