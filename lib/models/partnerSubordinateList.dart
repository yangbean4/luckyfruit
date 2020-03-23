import 'package:json_annotation/json_annotation.dart';
import "partnerSubordinateItem.dart";
part 'partnerSubordinateList.g.dart';

@JsonSerializable()
class PartnerSubordinateList {
  PartnerSubordinateList();

  List<PartnerSubordinateItem> lower1;
  List<PartnerSubordinateItem> lower2;
  List<PartnerSubordinateItem> pending;

  List<String> getAvatarListOfFriends() {
    List<String> resultList = [];
    for (var i = 0; lower1 != null && i < lower1.length; i++) {
      resultList.add(lower1[i]?.avatar ?? "");
    }
    for (var i = 0; lower2 != null && i < lower2.length; i++) {
      resultList.add(lower2[i]?.avatar ?? "");
    }
    for (var i = 0; pending != null && i < pending.length; i++) {
      resultList.add(pending[i]?.avatar ?? "");
    }

    return resultList;
  }

  factory PartnerSubordinateList.fromJson(Map<String, dynamic> json) =>
      _$PartnerSubordinateListFromJson(json);
  Map<String, dynamic> toJson() => _$PartnerSubordinateListToJson(this);
}
