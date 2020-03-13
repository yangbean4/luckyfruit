import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/theme/index.dart';

class RankPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RankPageState();
}

class RankPageState extends State<RankPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs = ["Friends Rank", "Bouns Tree Rank"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //导航栏
        title: Text("Rank"),
        backgroundColor: MyTheme.primaryColor,
        bottom: TabBar(
            //生成Tab菜单
            controller: _tabController,
            tabs: tabs.map((e) => Tab(text: e)).toList()),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((e) {
          //创建2个Tab页
          return ListView.separated(
              itemCount: 10,
              itemBuilder: (context, index) {
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
                      child: Text("$index"));
                }

                return Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(50)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        winnerWidget,
                        Expanded(
                          child: ListTile(
                            leading: Image.asset(
                              "assets/image/rank_page_portrait_default.png",
                              width: ScreenUtil().setWidth(120),
                              height: ScreenUtil().setWidth(120),
                            ),
                            title: Text('Linda'),
                            subtitle: Text('A global dividend tree'),
                          ),
                        ),
                        Text(
                          "124233",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ));
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider());
        }).toList(),
      ),
    );
  }
}
