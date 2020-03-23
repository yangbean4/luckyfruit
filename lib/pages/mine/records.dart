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
        child: ListView.builder(
            itemCount: msgList.length,
            itemExtent: ScreenUtil().setWidth(490 + 32),
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(60),
            ),
            itemBuilder: (context, index) {
              return Container(
                width: ScreenUtil().setWidth(960),
                height: ScreenUtil().setWidth(490),
              );
            }),
      ),
    );
  }
}
