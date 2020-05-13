import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/models/index.dart';
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:provider/provider.dart';

class FriendsFestProgressType {
  static const int Progress_One = 1;
  static const int Progress_Three = 3;
  static const int Progress_Five = 5;
}

enum FriendsFestStatusType { Status_Disable, Status_Enable, Status_Rewarded }

class FriendsFestRewardWidget extends StatefulWidget {
  final int progressType;
  FriendsFestStatusType statusType;

  FriendsFestRewardWidget(this.progressType, this.statusType);

  @override
  _FriendsFestRewardWidgetState createState() =>
      _FriendsFestRewardWidgetState();
}

class _FriendsFestRewardWidgetState extends State<FriendsFestRewardWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Image.asset(
          getFirstImgPath(),
          width: ScreenUtil().setWidth(132),
          height: ScreenUtil().setWidth(86),
        ),
        GestureDetector(
          onTap: () {
            if (widget.statusType != FriendsFestStatusType.Status_Enable) {
              return;
            }

            dynamic stateMap =
                Service().inviteAward({'num': widget.progressType});

//            String test = """{
//                          "tree_type": 0,
//                          "tree_id": 8827,
//                          "amount": 1000.0,
//                          "duration": 300
//                          }""";
//            stateMap = json.decode(test);

            if (stateMap == null) {
              return;
            }
            Invite_award invite_award = Invite_award.fromJson(stateMap);
            if (invite_award.tree_type == 1) {
              // 限时分红树
              GetReward.showLimitedTimeBonusTree(invite_award.duration, () {
                TreeGroup treeGroup =
                    Provider.of<TreeGroup>(context, listen: false);
                treeGroup.addTree(
                    tree: Tree(
                  grade: Tree.MAX_LEVEL,
                  type: TreeType.Type_TimeLimited_Bonus,
                  duration: invite_award.duration,
                  amount: invite_award.amount,
                  showCountDown: true,
                  treeId: invite_award.tree_id,
                  timePlantedLimitedBonusTree:
                      DateTime.now().millisecondsSinceEpoch,
                ));

                setState(() {
                  widget.statusType = FriendsFestStatusType.Status_Rewarded;
                });
              });
            } else if (invite_award.tree_type == 0) {
              // 奖励金币
              GetReward.showGoldWindow(invite_award.amount, () {
                EVENT_BUS.emit(MoneyGroup.ADD_GOLD, invite_award.amount);
                setState(() {
                  widget.statusType = FriendsFestStatusType.Status_Rewarded;
                });
              });
            }
          },
          child: Image.asset(
            getSecondImgPath(),
            width: ScreenUtil().setWidth(170),
            height: ScreenUtil().setWidth(170),
          ),
        ),
        Container(
          width: ScreenUtil().setWidth(102),
          height: ScreenUtil().setWidth(48),
          decoration: BoxDecoration(
            color: getThirdBgColor(),
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(24))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset(
                'assets/image/friends_fest_people_single.png',
                width: ScreenUtil().setWidth(28),
                height: ScreenUtil().setWidth(35),
              ),
              Text(
                getFourthInviteNum(),
                style: TextStyle(
                    color: Colors.white,
                    height: 1,
                    fontFamily: FontFamily.bold,
                    fontSize: ScreenUtil().setSp(26),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
  }

  String getFirstImgPath() {
    String path;
    switch (widget.progressType) {
      case FriendsFestProgressType.Progress_One:
        if (widget.statusType == FriendsFestStatusType.Status_Disable) {
          path = "assets/image/friends_fest_first_1stage_disable.png";
        } else if (widget.statusType == FriendsFestStatusType.Status_Enable) {
          path = "assets/image/friends_fest_first_1stage_enable.png";
        } else if (widget.statusType == FriendsFestStatusType.Status_Rewarded) {
          path = "assets/image/friends_fest_first_1stage_enable.png";
        }
        break;
      case FriendsFestProgressType.Progress_Three:
        if (widget.statusType == FriendsFestStatusType.Status_Disable) {
          path = "assets/image/friends_fest_first_3stage_disable.png";
        } else if (widget.statusType == FriendsFestStatusType.Status_Enable) {
          path = "assets/image/friends_fest_first_3stage_enable.png";
        } else if (widget.statusType == FriendsFestStatusType.Status_Rewarded) {
          path = "assets/image/friends_fest_first_3stage_enable.png";
        }
        break;
      case FriendsFestProgressType.Progress_Five:
        if (widget.statusType == FriendsFestStatusType.Status_Disable) {
          path = "assets/image/friends_fest_first_5stage_disable.png";
        } else if (widget.statusType == FriendsFestStatusType.Status_Enable) {
          path = "assets/image/friends_fest_first_5stage_enable.png";
        } else if (widget.statusType == FriendsFestStatusType.Status_Rewarded) {
          path = "assets/image/friends_fest_first_5stage_enable.png";
        }
        break;
      default:
        break;
    }

    return path;
  }

  String getSecondImgPath() {
    String path;
    switch (widget.progressType) {
      case FriendsFestProgressType.Progress_One:
        if (widget.statusType == FriendsFestStatusType.Status_Disable) {
          path = "assets/image/friends_fest_second_1stage_disable.png";
        } else if (widget.statusType == FriendsFestStatusType.Status_Enable) {
          path = "assets/image/friends_fest_second_1stage_enable.png";
        } else if (widget.statusType == FriendsFestStatusType.Status_Rewarded) {
          path = "assets/image/friends_fest_second_1stage_rewarded.png";
        }
        break;
      case FriendsFestProgressType.Progress_Three:
        if (widget.statusType == FriendsFestStatusType.Status_Disable) {
          path = "assets/image/friends_fest_second_3stage_disable.png";
        } else if (widget.statusType == FriendsFestStatusType.Status_Enable) {
          path = "assets/image/friends_fest_second_3stage_enable.png";
        } else if (widget.statusType == FriendsFestStatusType.Status_Rewarded) {
          path = "assets/image/friends_fest_second_3stage_rewarded.png";
        }

        break;
      case FriendsFestProgressType.Progress_Five:
        if (widget.statusType == FriendsFestStatusType.Status_Disable) {
          path = "assets/image/friends_fest_second_5stage_disable.png";
        } else if (widget.statusType == FriendsFestStatusType.Status_Enable) {
          path = "assets/image/friends_fest_second_5stage_enable.png";
        } else if (widget.statusType == FriendsFestStatusType.Status_Rewarded) {
          path = "assets/image/friends_fest_second_5stage_rewarded.png";
        }
        break;
      default:
        break;
    }

    return path;
  }

  Color getThirdBgColor() {
    Color bgColor;
    switch (widget.statusType) {
      case FriendsFestStatusType.Status_Disable:
        bgColor = Color(0xFF9C9C9C);
        break;
      case FriendsFestStatusType.Status_Enable:
        bgColor = Color(0xFF3EA1FE);
        break;
      case FriendsFestStatusType.Status_Rewarded:
        bgColor = Color(0xFF3EA1FE);
        break;
      default:
        break;
    }

    return bgColor;
  }

  String getFourthInviteNum() {
    String num;
    switch (widget.progressType) {
      case FriendsFestProgressType.Progress_One:
        num = "1";
        break;
      case FriendsFestProgressType.Progress_Three:
        num = "3";
        break;
      case FriendsFestProgressType.Progress_Five:
        num = "5";
        break;
      default:
        break;
    }

    return num;
  }
}