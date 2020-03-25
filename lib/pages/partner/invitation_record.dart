import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/models/partnerSubordinateItem.dart';
import 'package:luckyfruit/models/partnerSubordinateList.dart';
import 'package:luckyfruit/theme/index.dart';

class InvitationRecordListPage extends StatefulWidget {
  final PartnerSubordinateList partnerSubordinateList;

  const InvitationRecordListPage(
      {Key key, @required this.partnerSubordinateList})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => InvitationRecordListPageState();
}

class InvitationRecordListPageState extends State<InvitationRecordListPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs = ["Direct Friends", "Indirect Friends", "Pending Activation"];

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
          title: Text("Invitation Record"),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(ScreenUtil().setWidth(200)),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil().setWidth(40)),
                        topRight: Radius.circular(ScreenUtil().setWidth(40)))),
                padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(20),
                    bottom: ScreenUtil().setWidth(20)),
                child: TabBar(
                    //生成Tab菜单
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 5.0,
                    indicatorColor: Colors.green,
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
                                  fontSize: ScreenUtil().setWidth(52),
                                ),
                              )),
                            ))
                        .toList()),
              )),
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
      body: TabBarView(controller: _tabController, children: [
        generateListViewWithInfoList(widget.partnerSubordinateList?.lower1),
        generateListViewWithInfoList(widget.partnerSubordinateList?.lower2),
        generateListViewWithInfoList(widget.partnerSubordinateList?.pending),
      ]),
    );
  }

  Widget generateListViewWithInfoList(
      List<PartnerSubordinateItem> friendsList) {
    if (friendsList == null || friendsList.isEmpty) {
      return Center(
        child: Text("No Data"),
      );
    }

    return ListView.separated(
        itemCount: friendsList?.length,
        itemBuilder: (context, index) {
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
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      leading: ClipOval(child: avatarWidget),
                      title: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: "${friendsList[index].name}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: FontFamily.semibold,
                                    fontSize: ScreenUtil().setWidth(50),
                                    color: MyTheme.blackColor)),
                            friendsList[index].fb_login != 1
                                ? TextSpan(
                                    text: '(FB has not logged in)',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setWidth(40),
                                        color: Color(0xFF7C7C7C),
                                        fontFamily: FontFamily.regular,
                                        fontWeight: FontWeight.w400))
                                : TextSpan(),
                          ],
                        ),
                      ),
                      subtitle: Text(friendsList[index].date,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: FontFamily.regular,
                              fontSize: ScreenUtil().setWidth(34),
                              color: Color(0XFF7C7C7C))),
                    ),
                  ),
                  Text(
                    "Lv.${friendsList[index].level}",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: FontFamily.semibold,
                        fontSize: ScreenUtil().setWidth(56),
                        color: MyTheme.blackColor),
                  ),
                ],
              ));
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
              height: 1,
            ));
  }
}
