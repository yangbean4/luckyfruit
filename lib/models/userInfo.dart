import 'package:json_annotation/json_annotation.dart';

part 'userInfo.g.dart';

@JsonSerializable()
class UserInfo {
    UserInfo();

    num acct_bal;
    String separate_amount;
    String coin;
    num wishTreeNum;
    num phoneNum;
    num sign_times;
    String nickname;
    String avatar;
    String invite_code;
    num worker_visible;
    num direct_friend_visible;
    
    factory UserInfo.fromJson(Map<String,dynamic> json) => _$UserInfoFromJson(json);
    Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
