import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/models/index.dart';
import 'package:luckyfruit/models/rank_bonus_trees.dart';
import 'package:luckyfruit/models/rank_friends.dart';
import 'package:luckyfruit/models/ranklist.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/compatible_avatar_widget.dart';
import 'package:luckyfruit/theme/public/primary_btn.dart';
import 'package:provider/provider.dart';
import 'package:luckyfruit/service/index.dart';
import 'dart:convert';

import 'package:visibility_detector/visibility_detector.dart';

class RankPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RankPageState();
}

class RankPageState extends State<RankPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs = ["Friends Rank", "Bonus Tree Rank"];

  List<Rank_friends> friendsList;
  List<Rank_bonus_trees> bounsTreeList;

  String testJson = """
       { "friends": [
            {
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "Linda",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "Linda",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "Linda",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "508",
                "superior1": "0",
                "rela_account": "Linda",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "Linda",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "Linda",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "Linda",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "Linda",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "Linda",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "Linda",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "Linda",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "Linda",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "Linda",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "Linda",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "Linda",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "Linda",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "Linda",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "Linda",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "Linda",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "Linda",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            }
        ],
        "bounsTrees": [
            {
                "acct_id": "4",
                "superior1": "3",
                "rela_account": "name2",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "12.00",
                "separate_amount": "1111.00"
            },{
                "acct_id": "4",
                "superior1": "3",
                "rela_account": "name2",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "12.00",
                "separate_amount": "1111.00"
            },{
                "acct_id": "4",
                "superior1": "3",
                "rela_account": "name2",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "12.00",
                "separate_amount": "1111.00"
            },{
                "acct_id": "4",
                "superior1": "3",
                "rela_account": "name2",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "12.00",
                "separate_amount": "1111.00"
            },{
                "acct_id": "4",
                "superior1": "3",
                "rela_account": "name2",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "12.00",
                "separate_amount": "1111.00"
            },
                        {
                "acct_id": "4",
                "superior1": "3",
                "rela_account": "name2",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "12.00",
                "separate_amount": "1111.00"
            },{
                "acct_id": "4",
                "superior1": "3",
                "rela_account": "name2",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "12.00",
                "separate_amount": "1111.00"
            },{
                "acct_id": "4",
                "superior1": "3",
                "rela_account": "name2",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "12.00",
                "separate_amount": "1111.00"
            },{
                "acct_id": "4",
                "superior1": "3",
                "rela_account": "name2",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "12.00",
                "separate_amount": "1111.00"
            },{
                "acct_id": "4",
                "superior1": "3",
                "rela_account": "name2",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "12.00",
                "separate_amount": "1111.00"
            },
                        {
                "acct_id": "508",
                "superior1": "3",
                "rela_account": "name2",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "12.00",
                "separate_amount": "1111.00"
            },{
                "acct_id": "4",
                "superior1": "3",
                "rela_account": "name2",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "12.00",
                "separate_amount": "1111.00"
            },{
                "acct_id": "4",
                "superior1": "3",
                "rela_account": "name2",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "12.00",
                "separate_amount": "1111.00"
            },{
                "acct_id": "4",
                "superior1": "3",
                "rela_account": "name2",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "12.00",
                "separate_amount": "1111.00"
            },{
                "acct_id": "4",
                "superior1": "3",
                "rela_account": "name2",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "12.00",
                "separate_amount": "1111.00"
            }
        ]}
        """;
  // TODO 走接口
  List positionSelf = [-1, -1];

  List showTopShield = [false, false];
  List showBottomShield = [false, false];
  List flagFirstTime = [false, false];

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_tabBarListener);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    getRankListInfoData().then((res) {
      if (!mounted || res?.friends == null || res?.bounsTrees == null) {
        return;
      }

      UserModel userModel = Provider.of<UserModel>(context, listen: false);

      // 取出自己所在的position
      positionSelf[0] = res.friends.indexWhere(((tree) {
        if (tree?.acct_id != null &&
            tree?.acct_id?.compareTo(userModel?.value?.acct_id) == 0) {
          return true;
        }
        return false;
      }));

      positionSelf[1] = res.bounsTrees.indexWhere(((tree) {
        if (tree?.acct_id != null &&
            tree?.acct_id?.compareTo(userModel?.value?.acct_id) == 0) {
          return true;
        }
        return false;
      }));

      print("positionSelf after= $positionSelf");

      // TODO 测试
      positionSelf = [10, 10];
      setState(() {
        friendsList = res.friends;
        bounsTreeList = res.bounsTrees;
      });
    });
  }

  _tabBarListener() {
    if (mounted)
      setState(() {
        showTopShield = [false, false];
        showBottomShield = [false, false];
        flagFirstTime = [false, false];
      });
  }

  _scrollListener() {
    // print(
    //     "offset=${_scrollController.offset}, maxSE=${_scrollController.position.maxScrollExtent}, minSE=${_scrollController.position.minScrollExtent}");
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // setState(() {
      //   message = "reach the bottom";
      // });
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      // setState(() {
      //   message = "reach the top";
      // });
    }
  }

  Future<Ranklist> getRankListInfoData() async {
    TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);

    dynamic rankMap =
        await Service().getRankInfo({'acct_id': treeGroup.acct_id});
    //TODO 测试
    // Ranklist rankList = Ranklist.fromJson(rankMap);
    Ranklist rankList = Ranklist.fromJson(json.decode(testJson));
    // TODO 测试空白页面使用
    await Future.delayed(Duration(seconds: 3));
    return rankList;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool enableToShow = true;
    if (friendsList == null ||
        friendsList.isEmpty ||
        bounsTreeList == null ||
        bounsTreeList.isEmpty) {
      enableToShow = false;
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
            iconSize: 20,
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(ScreenUtil().setWidth(300)),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(ScreenUtil().setWidth(40)),
                      topRight: Radius.circular(ScreenUtil().setWidth(40)))),
              padding: EdgeInsets.only(
                  top: ScreenUtil().setWidth(10),
                  bottom: ScreenUtil().setWidth(10)),
              child: TabBar(
                  //生成Tab菜单
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 5.0,
                  indicatorColor: Colors.green,
                  // labelPadding: EdgeInsets.only(left:1, top:1, bottom:0),
                  labelColor: MyTheme.primaryColor,
                  unselectedLabelColor: MyTheme.blackColor,
                  tabs: tabs
                      .map((e) => Tab(
                            child: Container(
                                // color: Colors.white,
                                child: Text(
                              e,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: FontFamily.semibold,
                                fontSize: ScreenUtil().setWidth(50),
                              ),
                            )),
                          ))
                      .toList()),
            )),
        flexibleSpace: Container(
          width: ScreenUtil().setWidth(1080),
          height: ScreenUtil().setWidth(1000),
          alignment: Alignment(0, -0.2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment(-1.0, 0.0),
                end: Alignment(1.0, 0.0),
                colors: [
                  Color.fromRGBO(103, 228, 127, 1),
                  Color.fromRGBO(59, 206, 100, 1),
                ]),
          ),
          child: Text(
            "RANK",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: FontFamily.black,
              fontWeight: FontWeight.w900,
              fontSize: ScreenUtil().setWidth(90),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: ScreenUtil().setWidth(1080),
              child: TabBarView(
                controller: _tabController,
                children: !enableToShow
                    ? List<Widget>.from([
                        Center(
                          child: Text("Loading..."),
                        ),
                        Center(
                          child: Text("Loading..."),
                        )
                      ])
                    : List<Widget>.from([
                        LayoutBuilder(builder: (context, constraints) {
                          int visiblePosition = (constraints.maxHeight /
                                  ScreenUtil().setWidth(200))
                              .ceil();
                          print("visiblePosition= $visiblePosition");
                          if (positionSelf[0] >= visiblePosition - 1 &&
                              !flagFirstTime[0]) {
                            flagFirstTime[0] = showBottomShield[0] = true;
                          }
                          return Stack(
                            children: [
                              NotificationListener<ScrollNotification>(
                                onNotification: (scrollNotification) {
                                  if (scrollNotification
                                      is ScrollStartNotification) {
                                    print(
                                        "notifyStart ${scrollNotification.metrics}");
                                  } else if (scrollNotification
                                      is ScrollUpdateNotification) {
                                    print(
                                        "notifyUpdate ${scrollNotification.metrics}");
                                    double thresholdValue = .5;
                                    double value = positionSelf[0] *
                                            ScreenUtil().setWidth(200) -
                                        scrollNotification.metrics.pixels;
                                    if (value < thresholdValue &&
                                        !showTopShield[0]) {
                                      if (mounted)
                                        setState(() {
                                          showTopShield[0] = true;
                                        });
                                    } else if (value > thresholdValue &&
                                        showTopShield[0]) {
                                      if (mounted)
                                        setState(() {
                                          showTopShield[0] = false;
                                        });
                                    }

                                    double value1 = (positionSelf[0] + 1) *
                                            ScreenUtil().setWidth(200) -
                                        (scrollNotification.metrics.pixels +
                                            scrollNotification
                                                .metrics.extentInside);

                                    if (value1 < thresholdValue &&
                                        showBottomShield[0]) {
                                      if (mounted)
                                        setState(() {
                                          showBottomShield[0] = false;
                                        });
                                    } else if (value1 > thresholdValue &&
                                        !showBottomShield[0]) {
                                      if (mounted)
                                        setState(() {
                                          showBottomShield[0] = true;
                                        });
                                    }
                                  } else if (scrollNotification
                                      is ScrollEndNotification) {
                                    print(
                                        "notifyEnd ${scrollNotification.metrics}");
                                  }

                                  return false;
                                },
                                child: ListView.separated(
                                    controller: _scrollController,
                                    itemCount: friendsList?.length,
                                    itemBuilder: (context, index) =>
                                        getListviewItemInTab1(index),
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const Divider(
                                              height: 0,
                                            )),
                              ),
                              positionSelf[0] >= 0 && showTopShield[0]
                                  ? Positioned(
                                      child: Container(
                                          color: Colors.red,
                                          child: getListviewItemInTab1(
                                              positionSelf[0])))
                                  : Container(width: 0, height: 0),
                              positionSelf[0] >= 0 && showBottomShield[0]
                                  ? Positioned(
                                      bottom: 0,
                                      child: Container(
                                          child: getListviewItemInTab1(
                                              positionSelf[0])))
                                  : Container(width: 0, height: 0),
                            ],
                          );
                        }),
                        // ),

                        // 第二个tab
                        LayoutBuilder(builder: (context, constraints) {
                          int visiblePosition = (constraints.maxHeight /
                                  ScreenUtil().setWidth(200))
                              .ceil();
                          print("visiblePosition= $visiblePosition");
                          if (positionSelf[1] >= visiblePosition - 1 &&
                              !flagFirstTime[1]) {
                            flagFirstTime[1] = showBottomShield[1] = true;
                          }
                          return Stack(
                            children: [
                              NotificationListener<ScrollNotification>(
                                onNotification: (scrollNotification) {
                                  if (scrollNotification
                                      is ScrollStartNotification) {
                                    print(
                                        "notifyStart ${scrollNotification.metrics}");
                                  } else if (scrollNotification
                                      is ScrollUpdateNotification) {
                                    print(
                                        "notifyUpdate ${scrollNotification.metrics}");
                                    double thresholdValue = .5;
                                    double value = positionSelf[1] *
                                            ScreenUtil().setWidth(200) -
                                        scrollNotification.metrics.pixels;
                                    if (value < thresholdValue &&
                                        !showTopShield[1]) {
                                      if (mounted)
                                        setState(() {
                                          showTopShield[1] = true;
                                        });
                                    } else if (value > thresholdValue &&
                                        showTopShield[1]) {
                                      if (mounted)
                                        setState(() {
                                          showTopShield[1] = false;
                                        });
                                    }

                                    double value1 = (positionSelf[1] + 1) *
                                            ScreenUtil().setWidth(200) -
                                        (scrollNotification.metrics.pixels +
                                            scrollNotification
                                                .metrics.extentInside);

                                    if (value1 < thresholdValue &&
                                        showBottomShield[1]) {
                                      if (mounted)
                                        setState(() {
                                          showBottomShield[1] = false;
                                        });
                                    } else if (value1 > thresholdValue &&
                                        !showBottomShield[1]) {
                                      if (mounted)
                                        setState(() {
                                          showBottomShield[1] = true;
                                        });
                                    }
                                  } else if (scrollNotification
                                      is ScrollEndNotification) {
                                    print(
                                        "notifyEnd ${scrollNotification.metrics}");
                                  }

                                  return false;
                                },
                                child: ListView.separated(
                                    controller: _scrollController,
                                    itemCount: bounsTreeList?.length,
                                    itemBuilder: (context, index) =>
                                        getListviewItemInTab2(index),
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const Divider(
                                              height: 0,
                                            )),
                              ),
                              positionSelf[1] >= 0 && showTopShield[1]
                                  ? Positioned(
                                      child: Container(
                                          color: Colors.red,
                                          child: getListviewItemInTab2(
                                              positionSelf[1])))
                                  : Container(width: 0, height: 0),
                              positionSelf[1] >= 0 && showBottomShield[1]
                                  ? Positioned(
                                      bottom: 0,
                                      child: Container(
                                          child: getListviewItemInTab2(
                                              positionSelf[1])))
                                  : Container(width: 0, height: 0),
                            ],
                          );
                        }),
                      ]),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            width: ScreenUtil().setWidth(1080),
            height: ScreenUtil().setWidth(244),
            alignment: Alignment(0, 0),
            child: GestureDetector(
                onTap: () {
                  print("_tabController.index= ${_tabController.index}");
                },
                child: PrimaryButton(text: "Invite", width: 600, height: 124)),
          ),
        ],
      ),
    );
  }

  Widget getListviewItemInTab1(int index) {
    if (index < 0 ||
        friendsList?.length == null ||
        index >= friendsList?.length) {
      return Container(width: 0, height: 0);
    }
    // debugger(when: index == 3);
    var winnerImgSrc;
    var winnerWidget;
    if (index == 0) {
      winnerImgSrc = "assets/image/rank_page_winner_first.png";
    } else if (index == 1) {
      winnerImgSrc = "assets/image/rank_page_winner_second.png";
    } else if (index == 2) {
      winnerImgSrc = "assets/image/rank_page_winner_third.png";
    }

    if (index < 3) {
      winnerWidget = Image.asset(
        winnerImgSrc,
        width: ScreenUtil().setWidth(110),
        height: ScreenUtil().setWidth(124),
      );
    } else {
      winnerWidget = Container(
          alignment: Alignment.center,
          width: ScreenUtil().setWidth(110),
          height: ScreenUtil().setWidth(124),
          child: Text("${index + 1}"));
    }

    var avatarWidget = CompatibleNetworkAvatarWidget(
      friendsList[index]?.avatar,
      defaultImageUrl: "assets/image/rank_page_portrait_default.png",
      width: ScreenUtil().setWidth(120),
      height: ScreenUtil().setWidth(120),
      fit: BoxFit.cover,
    );

    return VisibilityDetector(
      key: Key("unique_key_$index"),
      onVisibilityChanged: (e) {
        debugPrint(
            "debugPrint-visible: ${e.key}, ${e.visibleFraction}, ${e.size}, ${e.visibleBounds}, mounted=$mounted");
        // 如果positionSelf位置还不可见
        // if (e.key.toString().contains("$positionSelf") &&
        //     flag == false &&
        //     mounted) {
        //   setState(() {
        //     print("!contains");
        //     flag = showBottomShield = false;
        //   });
        // }
      },
      child: Container(
          width: ScreenUtil().setWidth(1080),
          height: ScreenUtil().setWidth(200),
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(95)),
          color:
              ((index == positionSelf[0]) ? Color(0xFFBCFFCC) : Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              winnerWidget,
              Expanded(
                child: ListTile(
                  leading: ClipOval(child: avatarWidget),
                  title: Text(
                    friendsList[index].rela_account,
                    style: TextStyle(
                        fontSize: ScreenUtil().setWidth(50),
                        fontFamily: FontFamily.semibold,
                        fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    friendsList[index].tree_num > 0
                        ? "${friendsList[index].tree_num} global dividend tree(s)"
                        : "No global dividend tree",
                    style: TextStyle(
                        color: index == positionSelf[0]
                            ? Color.fromRGBO(38, 38, 38, 1)
                            : Color.fromRGBO(124, 124, 124, 1),
                        fontSize: ScreenUtil().setWidth(34),
                        fontFamily: FontFamily.regular,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Text(
                "\$${friendsList[index].separate_amount}",
                style: TextStyle(
                    color: Color.fromRGBO(38, 38, 38, 1),
                    fontSize: ScreenUtil().setWidth(56),
                    fontFamily: FontFamily.semibold,
                    fontWeight: FontWeight.w500),
              ),
            ],
          )),
    );
  }

  Widget getListviewItemInTab2(int index) {
    var avatarWidget = CompatibleNetworkAvatarWidget(
      bounsTreeList[index]?.avatar,
      defaultImageUrl: "assets/image/rank_page_portrait_default.png",
      width: ScreenUtil().setWidth(120),
      height: ScreenUtil().setWidth(120),
      fit: BoxFit.cover,
    );

    return Container(
        width: ScreenUtil().setWidth(1080),
        height: ScreenUtil().setWidth(200),
        color: ((index == positionSelf[1]) ? Color(0xFFBCFFCC) : Colors.white),
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(95),
            vertical: ScreenUtil().setWidth(40)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipOval(child: avatarWidget),
                SizedBox(
                  width: ScreenUtil().setWidth(30),
                ),
                Text(
                  bounsTreeList[index]?.rela_account,
                  style: TextStyle(
                      color: MyTheme.blackColor,
                      fontSize: ScreenUtil().setWidth(50),
                      fontFamily: FontFamily.semibold,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Text(
              bounsTreeList[index]?.tree_num?.toString() ?? "0",
              style: TextStyle(
                  color: MyTheme.blackColor,
                  fontSize: ScreenUtil().setWidth(50),
                  fontFamily: FontFamily.semibold,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              bounsTreeList[index]?.separate_amount,
              style: TextStyle(
                  color: MyTheme.blackColor,
                  fontSize: ScreenUtil().setWidth(56),
                  fontFamily: FontFamily.semibold,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ));
  }
}
