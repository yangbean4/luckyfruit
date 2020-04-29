import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:luckyfruit/widgets/no_data.dart';
import 'package:provider/provider.dart';

import 'package:luckyfruit/models/index.dart' show Message;
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/service/index.dart';

class MessagePage extends StatefulWidget {
  MessagePage({Key key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Message> msgList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _init();
  }

  _init() async {
    BurialReport.report('page_imp', {'page_code': '020'});

    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    List jsonList = await Service().messageCentre({
      'acct_id': userModel.value.acct_id,
    });
    if (mounted && jsonList != null) {
      setState(() {
        msgList = jsonList.map((e) => Message.fromJson(e)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.grayColor,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        iconTheme: IconThemeData(
          color: MyTheme.blackColor,
        ),
        backgroundColor: MyTheme.grayColor,
        title: Align(
          alignment: Alignment(-0.3, 0),
          child: Text(
            'Message',
            style: TextStyle(
                color: MyTheme.blackColor,
                fontSize: ScreenUtil().setSp(70),
                fontFamily: FontFamily.bold,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body:
          //  msgList.isEmpty
          //     ? NoData(
          //         msg: 'no....data...',
          //       )
          //     :
          ListView.separated(
              itemCount: msgList.length,
              // itemExtent: ScreenUtil().setWidth(490 + 32),
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(60),
                  vertical: ScreenUtil().setWidth(60)),
              separatorBuilder: (BuildContext context, int index) => Divider(
                    height: ScreenUtil().setWidth(32).toDouble(),
                  ),
              itemBuilder: (context, index) {
                Message message = msgList[index];
                return Container(
                  width: ScreenUtil().setWidth(960),
                  height: ScreenUtil().setWidth(490),
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(80),
                      vertical: ScreenUtil().setWidth(44)),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(40)))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.asset(
                        'assets/image/${message.wdl_status == '2' ? 'error' : 'success'}.png',
                        width: ScreenUtil().setWidth(151),
                        height: ScreenUtil().setWidth(151),
                      ),
                      Text(
                        message.wdl_status == '2'
                            ? 'cash out failed'
                            : 'cash out success',
                        style: TextStyle(
                            color: MyTheme.blackColor,
                            fontSize: ScreenUtil().setSp(70),
                            fontFamily: FontFamily.bold,
                            fontWeight: FontWeight.bold),
                      ),
                      message.wdl_status == '2'
                          ? Text(message.msg_content ?? '',
                              // "Your \$${message.wdl_amt} cash out failed,Please check if you haven't login with FB",
                              style: TextStyle(
                                  color: MyTheme.blackColor,
                                  fontSize: ScreenUtil().setSp(34),
                                  fontFamily: FontFamily.regular,
                                  fontWeight: FontWeight.w400))
                          : RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text:
                                      'your \$${message.wdl_amt} Amazon Gift card redeeded sucessfully,your came is:',
                                  style: TextStyle(
                                      color: MyTheme.blackColor,
                                      fontSize: ScreenUtil().setSp(34),
                                      fontFamily: FontFamily.regular,
                                      fontWeight: FontWeight.w400),
                                  children: [
                                    TextSpan(
                                        text: message.gift_id,
                                        style: TextStyle(
                                            color: MyTheme.blackColor,
                                            fontSize: ScreenUtil().setSp(34),
                                            fontFamily: FontFamily.semibold,
                                            fontWeight: FontWeight.w400))
                                  ]),
                            ),
                    ],
                  ),
                );
              }),
    );
  }
}
