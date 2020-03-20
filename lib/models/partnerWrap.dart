import 'package:json_annotation/json_annotation.dart';
import "partnerSubordinateList.dart";
part 'partnerWrap.g.dart';

@JsonSerializable()
class PartnerWrap {
    PartnerWrap();

    PartnerSubordinateList friends;
    num fb_no_login;
    num direct_profit;
    num indirect_profit;
    num total_profit;
    num friends_total;
    
    factory PartnerWrap.fromJson(Map<String,dynamic> json) => _$PartnerWrapFromJson(json);
    Map<String, dynamic> toJson() => _$PartnerWrapToJson(this);
}
