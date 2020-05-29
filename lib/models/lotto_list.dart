import 'package:json_annotation/json_annotation.dart';
import "lottoListItem.dart";
part 'lotto_list.g.dart';

@JsonSerializable()
class Lotto_list {
    Lotto_list();

    num code;
    String msg;
    List<LottoListItem> data;
    
    factory Lotto_list.fromJson(Map<String,dynamic> json) => _$Lotto_listFromJson(json);
    Map<String, dynamic> toJson() => _$Lotto_listToJson(this);
}
