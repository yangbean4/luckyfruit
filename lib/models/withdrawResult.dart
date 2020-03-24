import 'package:json_annotation/json_annotation.dart';

part 'withdrawResult.g.dart';

@JsonSerializable()
class WithdrawResult {
    WithdrawResult();

    String msg;
    num code;
    
    factory WithdrawResult.fromJson(Map<String,dynamic> json) => _$WithdrawResultFromJson(json);
    Map<String, dynamic> toJson() => _$WithdrawResultToJson(this);
}
