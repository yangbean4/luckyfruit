import 'package:json_annotation/json_annotation.dart';
import "lottoListItem.dart";
part 'lotto_list.g.dart';

@JsonSerializable()
class LottoList {
    LottoList();

    num code;
    String msg;
    List<LottoListItem> data;
    
    factory LottoList.fromJson(Map<String,dynamic> json) => _$Lotto_listFromJson(json);
    Map<String, dynamic> toJson() => _$Lotto_listToJson(this);
}
