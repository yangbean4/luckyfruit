import 'package:json_annotation/json_annotation.dart';

part 'personalInfo.g.dart';

@JsonSerializable()
class PersonalInfo {
    PersonalInfo();

    num videoTimes;
    num videoTimes_ratio;
    num treeComposer;
    num treeComposer_ratio;
    num deblock_city;
    num deblock_city_ratio;
    num profit;
    num profit_ratio;
    num friends_number;
    num num_ratio;
    num count_ratio;
    String amount;
    String Invite_code;
    String superior1;
    String superior2;
    
    factory PersonalInfo.fromJson(Map<String,dynamic> json) => _$PersonalInfoFromJson(json);
    Map<String, dynamic> toJson() => _$PersonalInfoToJson(this);
}
