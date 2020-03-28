import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/models/index.dart';
import 'package:luckyfruit/models/rank_bonus_trees.dart';
import 'package:luckyfruit/models/rank_friends.dart';
import 'package:luckyfruit/models/ranklist.dart';
import 'package:luckyfruit/provider/tree_group.dart';
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
                "rela_account": "name1",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "name1",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "name1",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "name1",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "name1",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "name1",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "name1",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "name1",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "name1",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "name1",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "name1",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "name1",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "name1",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "name1",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "name1",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "name1",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "name1",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "name1",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "name1",
                "avatar": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583923072944&di=5452b413b4ee332c39f5c04e490293b9&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101216%2F5191712_154719073035_2.jpg",
                "amount": "0.00",
                "separate_amount": "1234",
                "tree_num": 0
            },{
                "acct_id": "67",
                "superior1": "0",
                "rela_account": "name1",
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
            }
        ]}
        """;
  // TODO 走接口
  int positionSelf = 10;

  bool showTopShield = false;
  bool showBottomShield = true;

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_tabBarListener);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    getRankListInfoData().then((res) {
      setState(() {
        friendsList = res.friends;
        bounsTreeList = res.bounsTrees;
      });
    });
  }

  _tabBarListener() {
    setState(() {
      if (_tabController.index == 1) {
        showTopShield = false;
        showBottomShield = false;
      } else {
        showTopShield = false;
        showBottomShield = true;
      }
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
                                height: 1,
                                fontWeight: FontWeight.w500,
                                fontFamily: FontFamily.semibold,
                                fontSize: ScreenUtil().setSp(52),
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
              height: 1,
              fontFamily: FontFamily.black,
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(100),
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
                        Stack(
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
                                  double value = positionSelf *
                                          ScreenUtil().setWidth(200) -
                                      scrollNotification.metrics.pixels;
                                  if (value < thresholdValue &&
                                      !showTopShield) {
                                    setState(() {
                                      showTopShield = true;
                                    });
                                  } else if (value > thresholdValue &&
                                      showTopShield) {
                                    setState(() {
                                      showTopShield = false;
                                    });
                                  }

                                  double value1 = (positionSelf + 1) *
                                          ScreenUtil().setWidth(200) -
                                      (scrollNotification.metrics.pixels +
                                          scrollNotification
                                              .metrics.extentInside);

                                  if (value1 < thresholdValue &&
                                      showBottomShield) {
                                    setState(() {
                                      showBottomShield = false;
                                    });
                                  } else if (value1 > thresholdValue &&
                                      !showBottomShield) {
                                    setState(() {
                                      showBottomShield = true;
                                    });
                                  }
                                } else if (scrollNotification
                                    is ScrollEndNotification) {
                                  print(
                                      "notifyEnd ${scrollNotification.metrics}");
                                }
                              },
                              child: ListView.separated(
                                  controller: _scrollController,
                                  itemCount: friendsList?.length,
                                  itemBuilder: (context, index) =>
                                      getListviewItem(index),
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Divider(
                                            height: 0,
                                          )),
                            ),
                            positionSelf >= 0 && showTopShield
                                ? Positioned(
                                    child: Container(
                                        color: Colors.red,
                                        child: getListviewItem(positionSelf)))
                                : Container(width: 0, height: 0),
                            positionSelf >= 0 && showBottomShield
                                ? Positioned(
                                    bottom: 0,
                                    child: Container(
                                        width: ScreenUtil().setWidth(1080),
                                        height: ScreenUtil().setWidth(200),
                                        child: getListviewItem(positionSelf)))
                                : Container(width: 0, height: 0),
                          ],
                        ),
                        // ),

                        // 第二个tab
                        ListView.separated(
                            itemCount: bounsTreeList?.length,
                            itemBuilder: (context, index) {
                              var avatarWidget = CompatibleNetworkAvatarWidget(
                                bounsTreeList[index].avatar,
                                defaultImageUrl:
                                    "assets/image/rank_page_portrait_default.png",
                                width: ScreenUtil().setWidth(120),
                                height: ScreenUtil().setWidth(120),
                                fit: BoxFit.cover,
                              );

                              return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(50),
                                      vertical: ScreenUtil().setWidth(20)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ClipOval(child: avatarWidget),
                                      Text(bounsTreeList[index].rela_account),
                                      Text("1"),
                                      Text(bounsTreeList[index].separate_amount,
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 76, 47, 1))),
                                    ],
                                  ));
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider())
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

  Widget getListviewItem(int index) {
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
        height: ScreenUtil().setWidth(120),
      );
    } else {
      winnerWidget = Container(
          alignment: Alignment.center,
          width: ScreenUtil().setWidth(110),
          height: ScreenUtil().setWidth(120),
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
            "debugPrint-visible: ${e.key}, ${e.visibleFraction}, ${e.size}, ${e.visibleBounds}");
      },
      child: Container(
          width: ScreenUtil().setWidth(1080),
          height: ScreenUtil().setWidth(200),
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
          color: ((index == positionSelf) ? Color(0xFFBCFFCC) : Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              winnerWidget,
              Expanded(
                child: ListTile(
                  leading: ClipOval(child: avatarWidget),
                  title: Text(friendsList[index].rela_account),
                  subtitle: Text(friendsList[index].tree_num > 0
                      ? "${friendsList[index].tree_num} global dividend tree(s)"
                      : "No global dividend dog"),
                ),
              ),
              Text(
                "\$${friendsList[index].separate_amount}",
                style: TextStyle(color: Colors.red),
              ),
            ],
          )),
    );
  }
}
