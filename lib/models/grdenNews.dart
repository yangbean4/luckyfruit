import 'package:json_annotation/json_annotation.dart';

part 'grdenNews.g.dart';

@JsonSerializable()
class GrdenNews {
    GrdenNews();

    String stolen_acct_id;
    num type;
    String tree_type;
    String content;
    String percent;
    String is_show;
    String add_time;
    String nickname;
    String avatar;
    num deblock_city;
    String space_time;
    num level;
    
    factory GrdenNews.fromJson(Map<String,dynamic> json) => _$GrdenNewsFromJson(json);
    Map<String, dynamic> toJson() => _$GrdenNewsToJson(this);
}
