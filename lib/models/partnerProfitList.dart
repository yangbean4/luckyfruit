import 'package:json_annotation/json_annotation.dart';
import "partnerProfitItem.dart";
part 'partnerProfitList.g.dart';

@JsonSerializable()
class PartnerProfitList {
    PartnerProfitList();

    num code;
    String msg;
    List<PartnerProfitItem> data;
    
    factory PartnerProfitList.fromJson(Map<String,dynamic> json) => _$PartnerProfitListFromJson(json);
    Map<String, dynamic> toJson() => _$PartnerProfitListToJson(this);
}
