import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/models/index.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:provider/provider.dart';

class PartnerProfitPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PartnerProfitPageState();
}

class PartnerProfitPageState extends State<PartnerProfitPageWidget> {
  String testJson = """
    {
    "code": 0,
    "msg": "Success",
    "data": [
        {
            "date": "2020-03-17",
            "amount": "100.00"
        },
        {
            "date": "2020-03-16",
            "amount": "121.21"
        },
        {
            "date": "2020-03-17",
            "amount": "100.00"
        },
        {
            "date": "2020-03-16",
            "amount": "121.21"
        },        
        {
            "date": "2020-03-17",
            "amount": "100.00"
        },
        {
            "date": "2020-03-16",
            "amount": "121.21"
        }
    ]
}
  """;

  PartnerProfitList _partnerProfitList;

  @override
  void initState() {
    super.initState();
    BurialReport.report('page_imp', {'page_code': '018'});

    getPartnerProfitListInfoData().then((result) {
      setState(() {
        _partnerProfitList = result;
      });
    });
  }

  Future<PartnerProfitList> getPartnerProfitListInfoData() async {
    TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);

    dynamic profitMap = await Service()
        .getPartnerProfitListInfo({'acct_id': treeGroup.acct_id});
    PartnerProfitList profitList = PartnerProfitList.fromJson(profitMap);
    // PartnerProfitList profitList =
    //     PartnerProfitList.fromJson(json.decode(testJson));
    return profitList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            leading: Container(),
            elevation: 0,
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(ScreenUtil().setWidth(100)),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(ScreenUtil().setWidth(40)),
                          topRight:
                              Radius.circular(ScreenUtil().setWidth(40)))),
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setWidth(20),
                      bottom: ScreenUtil().setWidth(20)),
                )),
            flexibleSpace: Container(
              width: ScreenUtil().setWidth(1080),
              height: ScreenUtil().setWidth(1000),
              alignment: Alignment(0, 0.2),
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
                      "Partners Earning",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
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
        body: _partnerProfitList?.data?.length != null
            ? ListView.separated(
                itemCount: _partnerProfitList?.data?.length,
                itemBuilder: (context, index) {
                  return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(95),
                          vertical: ScreenUtil().setWidth(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Partners Earning",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(50),
                                        fontFamily: FontFamily.semibold,
                                        fontWeight: FontWeight.w500,
                                        color: MyTheme.blackColor)),
                                Text(_partnerProfitList.data[index].date,
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(34),
                                        fontFamily: FontFamily.regular,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF7C7C7C))),
                              ]),
                          Text(
                              "\$${Util.formatNumber(num.tryParse(_partnerProfitList.data[index].amount), fixed: 2)}",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(56),
                                  fontFamily: FontFamily.semibold,
                                  fontWeight: FontWeight.w500,
                                  color: MyTheme.blackColor)),
                        ],
                      ));
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider())
            : Center(
                child: Text("No Data"),
              ));
  }
}
