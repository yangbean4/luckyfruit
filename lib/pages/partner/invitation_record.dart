import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/models/partnerSubordinateItem.dart';
import 'package:luckyfruit/models/partnerSubordinateList.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/compatible_avatar_widget.dart';

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
  List tabs = [
    "Direct \nFriends",
    "Indirect \nFriends",
    "Pending \nActivation"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Container(),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(ScreenUtil().setWidth(240)),
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
                                  fontSize: ScreenUtil().setSp(52),
                                ),
                              )),
                            ))
                        .toList()),
              )),
          flexibleSpace: Container(
            width: ScreenUtil().setWidth(1080),
            height: ScreenUtil().setWidth(1000),
            alignment: Alignment(0, -0.5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment(-1.0, 0.0),
                  end: Alignment(1.0, 0.0),
                  colors: [
                    Color.fromRGBO(103, 228, 127, 1),
                    Color.fromRGBO(59, 206, 100, 1),
                  ]),
            ),
            child: Container(
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(60),
                        right: ScreenUtil().setWidth(190),
                      ),
                      child: Image.asset(
                        'assets/image/close_left_arrow_pages.png',
                        width: ScreenUtil().setWidth(30),
                        height: ScreenUtil().setWidth(50),
                      ),
                    ),
                  ),
                  Text(
                    "Invitation Record",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      // backgroundColor: Colors.yellow,
                      height: 1,
                      fontFamily: FontFamily.bold,
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(70),
                    ),
                  ),
                ],
              ),
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
          var avatarWidget = CompatibleNetworkAvatarWidget(
            friendsList[index].avatar,
            defaultImageUrl: "assets/image/rank_page_portrait_default.png",
            width: ScreenUtil().setWidth(120),
            height: ScreenUtil().setWidth(120),
            fit: BoxFit.cover,
          );

          return Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(50),
                // vertical: ScreenUtil().setWidth(40),
              ),
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
                                    fontSize: ScreenUtil().setSp(50),
                                    color: MyTheme.blackColor)),
                            friendsList[index].fb_login != 1
                                ? TextSpan(
                                    text: '(FB has not logged in)',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(40),
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
                              fontSize: ScreenUtil().setSp(34),
                              color: Color(0XFF7C7C7C))),
                    ),
                  ),
                  Text(
                    "Lv.${friendsList[index].level}",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: FontFamily.semibold,
                        fontSize: ScreenUtil().setSp(56),
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
