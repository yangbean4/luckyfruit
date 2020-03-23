import 'package:json_annotation/json_annotation.dart';
import "partnerSubordinateList.dart";
import "partnerSuperiorItem.dart";
part 'partnerWrap.g.dart';

@JsonSerializable()
class PartnerWrap {
    PartnerWrap();

    PartnerSubordinateList friends;
    PartnerSuperiorItem superior;
    num fb_no_login;
    num direct_profit;
    num indirect_profit;
    num total_profit;
    num friends_total;
    num fb_no_login_all_profit;
    num fb_login_today_profit;
    num fb_login_history_profit;
    
    factory PartnerWrap.fromJson(Map<String,dynamic> json) => _$PartnerWrapFromJson(json);
    Map<String, dynamic> toJson() => _$PartnerWrapToJson(this);
}
