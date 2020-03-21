import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/models/index.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/theme/index.dart';
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

    getPartnerProfitListInfoData().then((result) {
      setState(() {
        _partnerProfitList = result;
      });
    });
  }

  Future<PartnerProfitList> getPartnerProfitListInfoData() async {
    TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);

    // dynamic profitMap = await Service()
    //     .getPartnerProfitListInfo({'acct_id': treeGroup.acct_id});
    // Ranklist rankList = Ranklist.fromJson(rankMap);
    PartnerProfitList profitList =
        PartnerProfitList.fromJson(json.decode(testJson));
    // 测试空白页面使用
    await Future.delayed(Duration(seconds: 3));
    return profitList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //导航栏
          title: Text("Partners Earning"),
          backgroundColor: MyTheme.primaryColor,
        ),
        body: _partnerProfitList?.data?.length != null
            ? ListView.separated(
                itemCount: _partnerProfitList?.data?.length,
                itemBuilder: (context, index) {
                  return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(50),
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
                                        fontSize: ScreenUtil().setWidth(50),
                                        fontFamily: FontFamily.semibold,
                                        fontWeight: FontWeight.w500,
                                        color: MyTheme.blackColor)),
                                Text(_partnerProfitList.data[index].date,
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setWidth(34),
                                        fontFamily: FontFamily.regular,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF7C7C7C))),
                              ]),
                          Text("\$${_partnerProfitList.data[index].amount}",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setWidth(50),
                                  fontFamily: FontFamily.semibold,
                                  fontWeight: FontWeight.w500,
                                  color: MyTheme.blackColor)),
                        ],
                      ));
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider())
            : Center(
                child: Text("Loading..."),
              ));
  }
}
