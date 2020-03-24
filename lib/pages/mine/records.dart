import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:luckyfruit/models/index.dart' show ProfitLog;
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/service/index.dart';

class RecordsPage extends StatefulWidget {
  RecordsPage({Key key}) : super(key: key);

  @override
  _RecordsPageState createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  List<ProfitLog> msgList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _init();
  }

  _init() async {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    List jsonList = await Service().profitLog({
      'acct_id': userModel.value.acct_id,
    });
    if (mounted) {
      setState(() {
        msgList = jsonList.map((e) => ProfitLog.fromJson(e)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.grayColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: MyTheme.blackColor,
        ),
        backgroundColor: MyTheme.grayColor,
        title: Text(
          'Records',
          style: TextStyle(
              color: MyTheme.blackColor,
              fontSize: ScreenUtil().setWidth(70),
              fontFamily: FontFamily.bold,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: ScreenUtil().setWidth(1080),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ScreenUtil().setWidth(40)),
              topRight: Radius.circular(ScreenUtil().setWidth(40)),
            )),
        child: ListView.separated(
          itemCount: msgList.length,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(94),
            vertical: ScreenUtil().setWidth(60),
          ),
          itemBuilder: (context, index) {
            ProfitLog profitLog = msgList[index];
            return Container(
              height: ScreenUtil().setWidth(200),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _recordsTitle[profitLog.module] ?? 'Records',
                        style: TextStyle(
                            color: MyTheme.blackColor,
                            fontSize: ScreenUtil().setWidth(46),
                            fontFamily: FontFamily.semibold,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        profitLog.end_time,
                        style: TextStyle(
                            color: MyTheme.tipsColor,
                            fontSize: ScreenUtil().setWidth(34),
                            fontFamily: FontFamily.regular,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  )),
                  Container(
                    width: ScreenUtil().setWidth(160),
                    child: Text(
                      '${profitLog.module == '6' ? '-' : '+'} ${profitLog.amount}',
                      style: TextStyle(
                          color: MyTheme.blackColor,
                          fontSize: ScreenUtil().setWidth(56),
                          fontFamily: FontFamily.semibold,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(
            height: 1,
          ),
        ),
      ),
    );
  }
}

Map<String, String> _recordsTitle = {
  '1': 'Wishing Trees  earnings',
  '2': 'Limited Time Bouns Tree earnings',
  '3': 'Hops Tree(female)&Hops Tree (male)  earnings',
  '4': 'Bouns Tree earnings',
  '5': 'Partner  earnings',
  '6': 'Cash out(cash out success)',
};
