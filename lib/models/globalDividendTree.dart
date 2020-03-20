import 'package:json_annotation/json_annotation.dart';

part 'globalDividendTree.g.dart';

@JsonSerializable()
class GlobalDividendTree {
    GlobalDividendTree();

    num amount;
    num total;
    num today;
    num tree_num;
    
    factory GlobalDividendTree.fromJson(Map<String,dynamic> json) => _$GlobalDividendTreeFromJson(json);
    Map<String, dynamic> toJson() => _$GlobalDividendTreeToJson(this);
}
