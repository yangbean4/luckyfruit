import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/models/index.dart';
import 'package:luckyfruit/models/rank_bonus_trees.dart';
import 'package:luckyfruit/models/rank_friends.dart';
import 'package:luckyfruit/models/ranklist.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:provider/provider.dart';
import 'package:luckyfruit/service/index.dart';
import 'dart:convert';

class RankPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RankPageState();
}

class RankPageState extends State<RankPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs = ["Friends Rank", "Bouns Tree Rank"];

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

  int positionSelf = 3;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);

    getRankListInfoData().then((res) {
      setState(() {
        friendsList = res.friends;
        bounsTreeList = res.bounsTrees;
      });
    });
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
          //导航栏
          title: Text("Rank"),
          bottom: TabBar(
              //生成Tab菜单
              controller: _tabController,
              tabs: tabs.map((e) => Tab(text: e)).toList()),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment(-1.0, 0.0),
                  end: Alignment(1.0, 0.0),
                  colors: [
                    Color.fromRGBO(103, 228, 127, 1),
                    Color.fromRGBO(59, 206, 100, 1),
                  ]),
            ),
          )),
      body: TabBarView(
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
                ListView.separated(
                    itemCount: friendsList?.length,
                    itemBuilder: (context, index) {
                      var winnerImgSrc;
                      var winnerWidget;
                      if (index == 0) {
                        winnerImgSrc =
                            "assets/image/rank_page_winner_first.png";
                      } else if (index == 1) {
                        winnerImgSrc =
                            "assets/image/rank_page_winner_second.png";
                      } else if (index == 2) {
                        winnerImgSrc =
                            "assets/image/rank_page_winner_third.png";
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

                      var avatarWidget;
                      if (friendsList[index].avatar?.isEmpty ?? true) {
                        // 如果为空，使用默认的头像
                        avatarWidget = Image.asset(
                          "assets/image/rank_page_portrait_default.png",
                          width: ScreenUtil().setWidth(120),
                          height: ScreenUtil().setWidth(120),
                          fit: BoxFit.cover,
                        );
                      } else {
                        // 如果不为空，使用返回的头像
                        avatarWidget = Image.network(
                          friendsList[index].avatar,
                          width: ScreenUtil().setWidth(120),
                          height: ScreenUtil().setWidth(120),
                          fit: BoxFit.cover,
                        );
                      }

                      return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(50)),
                          color: ((index == positionSelf)
                              ? Color(0xFFBCFFCC)
                              : Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              winnerWidget,
                              Expanded(
                                child: ListTile(
                                  // leading: ClipRRect(borderRadius:BorderRadius.circular(30), child: avatarWidget),
                                  leading: ClipOval(child: avatarWidget),
                                  title: Text(friendsList[index].rela_account),
                                  //TODO 这行描述是否从接口中返回？还是前端写死的？
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
                          ));
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                          height: 1,
                        )),

                // 第二个tab
                ListView.separated(
                    itemCount: bounsTreeList?.length,
                    itemBuilder: (context, index) {
                      var avatarWidget;
                      if (bounsTreeList[index].avatar?.isEmpty ?? true) {
                        // 如果为空，使用默认的头像
                        avatarWidget = Image.asset(
                          "assets/image/rank_page_portrait_default.png",
                          width: ScreenUtil().setWidth(120),
                          height: ScreenUtil().setWidth(120),
                          fit: BoxFit.cover,
                        );
                      } else {
                        // 如果不为空，使用返回的头像
                        avatarWidget = Image.network(
                          bounsTreeList[index].avatar,
                          width: ScreenUtil().setWidth(120),
                          height: ScreenUtil().setWidth(120),
                          fit: BoxFit.cover,
                        );
                      }

                      return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(50),
                              vertical: ScreenUtil().setWidth(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ClipOval(child: avatarWidget),
                              Text(bounsTreeList[index].rela_account),
                              Text("1"),
                              Text(bounsTreeList[index].separate_amount,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 76, 47, 1))),
                            ],
                          ));
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider())
              ]),
      ),
    );
  }
}
