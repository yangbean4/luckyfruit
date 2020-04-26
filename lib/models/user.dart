import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
    User();

    String acct_id;
    String nickname;
    String icon_path;
    String rela_type;
    String rela_account;
    String last_leave_time;
    String active;
    num acct_bal;
    String separate_amount;
    String coin;
    String version;
    String share_version;
    num sign_times;
    String last_draw_time;
    String level;
    num ticket;
    String deblock_city;
    num ticket_time;
    num is_m;
    String update_time;
    String today_profit_update_time;
    String profit_update_time;
    
    factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);
    Map<String, dynamic> toJson() => _$UserToJson(this);
}
