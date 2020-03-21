import 'package:json_annotation/json_annotation.dart';
import "partnerSubordinateItem.dart";
part 'partnerSubordinateList.g.dart';

@JsonSerializable()
class PartnerSubordinateList {
    PartnerSubordinateList();

    List<PartnerSubordinateItem> lower1;
    List<PartnerSubordinateItem> lower2;
    List<PartnerSubordinateItem> pending;
    
    factory PartnerSubordinateList.fromJson(Map<String,dynamic> json) => _$PartnerSubordinateListFromJson(json);
    Map<String, dynamic> toJson() => _$PartnerSubordinateListToJson(this);
}
