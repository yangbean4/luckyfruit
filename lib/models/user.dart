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
    num sign_times;
    String last_draw_time;
    String level;
    num ticket;
    
    factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);
    Map<String, dynamic> toJson() => _$UserToJson(this);
}
