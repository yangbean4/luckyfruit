import 'package:json_annotation/json_annotation.dart';

part 'partnerSubordinateItem.g.dart';

@JsonSerializable()
class PartnerSubordinateItem {
    PartnerSubordinateItem();

    String avatar;
    String name;
    num fb_login;
    String date;
    num level;
    String today_profit;
    
    factory PartnerSubordinateItem.fromJson(Map<String,dynamic> json) => _$PartnerSubordinateItemFromJson(json);
    Map<String, dynamic> toJson() => _$PartnerSubordinateItemToJson(this);
}
