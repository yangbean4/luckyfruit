import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/public.dart';

class Illustration extends StatelessWidget {
  Illustration({Key key}) : super(key: key);

  List nameList = [
    "Bouns tree",
    "Wishing Tree",
    "Hop Tree(male)",
    "Hop Tree(Female)",
    "American Tree",
    "EuropeanTree",
    "Asian Tree",
    "African Tree",
    "Oceania Tree",
    "Limited Time\nBouns Tree",
  ];

  List titleList = [
    "Get 20% of platform ad revenue every day",
    "Receive random reward up to \$5 after recycling trees",
    "Merge female hops and male hops to get \$7 reward",
    "Merge female hops and male hops to get \$7 reward",
    "Merge 5 continental trees (from Asia, Africa, Europe, American and Oceania),get Bonus Tree",
    "Merge 5 continental trees (from Asia, Africa, Europe, American and Oceania),get Bonus Tree",
    "Merge 5 continental trees (from Asia, Africa, Europe, American and Oceania),get Bonus Tree",
    "Merge 5 continental trees (from Asia, Africa, Europe, American and Oceania),get Bonus Tree",
    "Merge 5 continental trees (from Asia, Africa, Europe, American and Oceania),get Bonus Tree",
    "Merge 5 continental trees (from Asia, Africa, Europe, American and Oceania),get Bonus Tree",
    "Experience 5-15 minutes Bouns Tree"
  ];

  List wayList = [
    "1.Merge 5 continental trees, 100% chance to get it\n2.Merge any 2 trees in Level 37 \n3.Stay active in the game, 100% chance to get",
    "1.Merge any 2 trees in Level 37 \n2.Collect 100 wishing tree chips",
    "Merge any 2 trees in Level 37",
    "Merge any 2 trees in Level 37",
    "Merge any 2 trees in Level 37",
    "Merge any 2 trees in Level 37",
    "Merge any 2 trees in Level 37",
    "Merge any 2 trees in Level 37",
    "Merge any 2 trees in Level 37",
    "1.Upgrade trees to Level 5 \n2.Unlock  in every new tree level \n3.Unlock new cities"
  ];

  List imageUrlList = [
    "assets/image/dividend_tree.png",
    "assets/image/dividend_tree.png",
    "assets/image/dividend_tree.png",
    "assets/image/dividend_tree.png",
    "assets/image/dividend_tree.png",
    "assets/image/dividend_tree.png",
    "assets/image/dividend_tree.png",
    "assets/image/dividend_tree.png",
    "assets/image/dividend_tree.png",
    "assets/image/dividend_tree.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            //导航栏
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            backgroundColor: Color.fromRGBO(239, 238, 243, 1),
            title: Text(
              "Instruction",
              style: TextStyle(
                  fontFamily: FontFamily.bold,
                  fontSize: ScreenUtil().setSp(70),
                  color: MyTheme.blackColor),
            ),
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: Container(
          color: Color.fromRGBO(239, 238, 243, 1),
          padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setWidth(60),
              horizontal: ScreenUtil().setWidth(60)),
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return generateCellItems(index);
            },
          ),
        ));
  }

  Widget generateCellItems(int index) {
    return Container(
        child: Card(
            elevation: 2,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(50)),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(children: [
                        Image.asset(
                          imageUrlList[index],
                          width: ScreenUtil().setWidth(240),
                          height: ScreenUtil().setWidth(260),
                          fit: BoxFit.cover,
                        ),
                        Container(
                          height: ScreenUtil().setWidth(18),
                        ),
                        FourthText(
                          nameList[index],
                          fontFamily: FontFamily.bold,
                          fontWeight: FontWeight.bold,
                          color: MyTheme.blackColor,
                          fontsize: 43,
                        )
                      ]),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(35),
                    ),
                    Flexible(
                      child:
                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Text(
                              titleList[index],
                              style: TextStyle(
                                  fontFamily: FontFamily.bold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setWidth(40),
                                  color: MyTheme.blackColor),
                            ),
                            Container(
                              height: ScreenUtil().setWidth(20),
                            ),
                            Text(
                              "How to get it:",
                              style: TextStyle(
                                  fontFamily: FontFamily.semibold,
                                  fontSize: ScreenUtil().setWidth(38),
                                  color: Color(0xFF7C7C7C)),
                            ),
                            Container(
                              height: ScreenUtil().setWidth(25),
                            ),
                            Text(
                              wayList[index],
                              style: TextStyle(
                                  fontSize: ScreenUtil().setWidth(32),
                                  color: MyTheme.blackColor),
                            ),
                          ]),
                    )
                  ]),
            )));
  }
}
