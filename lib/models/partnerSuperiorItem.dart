import 'package:json_annotation/json_annotation.dart';

part 'partnerSuperiorItem.g.dart';

@JsonSerializable()
class PartnerSuperiorItem {
    PartnerSuperiorItem();

    String avatar;
    String name;
    num fb_login;
    String date;
    num level;
    String today_profit;
    
    factory PartnerSuperiorItem.fromJson(Map<String,dynamic> json) => _$PartnerSuperiorItemFromJson(json);
    Map<String, dynamic> toJson() => _$PartnerSuperiorItemToJson(this);
}
