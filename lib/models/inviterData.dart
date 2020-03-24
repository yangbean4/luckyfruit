import 'package:json_annotation/json_annotation.dart';

part 'inviterData.g.dart';

@JsonSerializable()
class InviterData {
    InviterData();

    String acct_id;
    String nickname;
    String avatar;
    String level;
    
    factory InviterData.fromJson(Map<String,dynamic> json) => _$InviterDataFromJson(json);
    Map<String, dynamic> toJson() => _$InviterDataToJson(this);
}
