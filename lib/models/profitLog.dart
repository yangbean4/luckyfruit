import 'package:json_annotation/json_annotation.dart';

part 'profitLog.g.dart';

@JsonSerializable()
class ProfitLog {
    ProfitLog();

    String amount;
    String module;
    String start_time;
    String end_time;
    
    factory ProfitLog.fromJson(Map<String,dynamic> json) => _$ProfitLogFromJson(json);
    Map<String, dynamic> toJson() => _$ProfitLogToJson(this);
}
