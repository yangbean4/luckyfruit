import 'package:json_annotation/json_annotation.dart';

part 'partnerProfitItem.g.dart';

@JsonSerializable()
class PartnerProfitItem {
    PartnerProfitItem();

    String date;
    String amount;
    
    factory PartnerProfitItem.fromJson(Map<String,dynamic> json) => _$PartnerProfitItemFromJson(json);
    Map<String, dynamic> toJson() => _$PartnerProfitItemToJson(this);
}
