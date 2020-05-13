import 'package:json_annotation/json_annotation.dart';

part 'sign.g.dart';

@JsonSerializable()
class Sign {
    Sign();

    String type;
    String sign;
    String count;
    String module;
    String content;
    
    factory Sign.fromJson(Map<String,dynamic> json) => _$SignFromJson(json);
    Map<String, dynamic> toJson() => _$SignToJson(this);
}
