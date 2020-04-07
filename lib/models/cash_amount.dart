import 'package:json_annotation/json_annotation.dart';

part 'cash_amount.g.dart';

@JsonSerializable()
class Cash_amount {
    Cash_amount();

    num value;
    num show;
    
    factory Cash_amount.fromJson(Map<String,dynamic> json) => _$Cash_amountFromJson(json);
    Map<String, dynamic> toJson() => _$Cash_amountToJson(this);
}
