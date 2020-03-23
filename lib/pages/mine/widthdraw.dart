import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/primary_btn.dart';
import 'package:provider/provider.dart';

class WithDrawPage extends StatefulWidget {
  String amount;
  WithDrawPage({Key key, String amount}) {
    if (amount == null) {
      this.amount = "--";
    } else {
      this.amount = amount;
    }
  }

  @override
  _WithDrawPageState createState() => _WithDrawPageState();
}

class _WithDrawPageState extends State<WithDrawPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //导航栏
        title: Text("Cash Out",
            style: TextStyle(
                fontFamily: FontFamily.bold,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: ScreenUtil().setWidth(70))),
        elevation: 0,
        actions: <Widget>[
          Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(77)),
              // color: Colors.red,
              alignment: Alignment.center,
              child: Text(
                "Records",
                style: TextStyle(
                    fontFamily: FontFamily.semibold,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: ScreenUtil().setWidth(36)),
              ))
        ],
        backgroundColor: MyTheme.primaryColor,
      ),
      body: Stack(children: [
        Positioned(
            top: 0,
            child: Container(
              width: ScreenUtil().setWidth(1080),
              height: ScreenUtil().setWidth(300),
              color: MyTheme.primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Balance",
                    style: TextStyle(
                        fontFamily: FontFamily.regular,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: ScreenUtil().setWidth(50)),
                  ),
                  Text(
                    "\$${widget.amount}",
                    style: TextStyle(
                        fontFamily: FontFamily.bold,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: ScreenUtil().setWidth(90)),
                  ),
                ],
              ),
            )),
        Positioned(
            top: ScreenUtil().setWidth(250),
            child: Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(50)),
                width: ScreenUtil().setWidth(1080),
                height: ScreenUtil().setWidth(1920),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil().setWidth(40)),
                        topRight: Radius.circular(ScreenUtil().setWidth(40)))),
                child: ChangeNotifierProvider(
                  create: (_) => WithDrawProvider(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Cash Out  Ways",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: FontFamily.semibold,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: ScreenUtil().setWidth(50))),
                      SizedBox(height: ScreenUtil().setWidth(30)),
                      Selector<WithDrawProvider, WithDrawProvider>(
                        selector: (context, provider) => provider,
                        shouldRebuild: (pre, next) {
                          return true;
                        },
                        builder: (context, provider, child) {
                          return Wrap(
                              spacing: ScreenUtil().setWidth(30),
                              runSpacing: ScreenUtil().setWidth(30),
                              children: provider._typesList
                                  .map((e) => GestureDetector(
                                      onTap: () {
                                        provider.selectTypesItem(e);
                                      },
                                      child: WithDrawTypesItemWidget(e)))
                                  .toList());

                          // return WithDrawItemWidget();
                        },
                      ),
                      SizedBox(height: ScreenUtil().setWidth(80)),
                      Text("Cash Out  Amount",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: FontFamily.semibold,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: ScreenUtil().setWidth(50))),
                      SizedBox(height: ScreenUtil().setWidth(30)),
                      Selector<WithDrawProvider, WithDrawProvider>(
                        selector: (context, provider) => provider,
                        shouldRebuild: (pre, next) {
                          return true;
                        },
                        builder: (context, provider, child) {
                          return Wrap(
                              spacing: ScreenUtil().setWidth(30),
                              runSpacing: ScreenUtil().setWidth(30),
                              children: provider._amountList
                                  .map((e) => GestureDetector(
                                      onTap: () {
                                        provider.selectAmountItem(e);
                                      },
                                      child: WithDrawAmountItemWidget(e)))
                                  .toList());

                          // return WithDrawItemWidget();
                        },
                      ),
                      //TODO 文字换行后对齐
                      SizedBox(height: ScreenUtil().setWidth(100)),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: "Tips\n",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setWidth(40),
                                    fontFamily: FontFamily.semibold,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF262626))),
                            TextSpan(
                                text: '1.It takes up to 3 business days to cash out and the service fee is 3%\n' +
                                    '2.No service fee for the first cashout.',
                                
                                style: TextStyle(
                                  wordSpacing: 1,
                                    fontSize: ScreenUtil().setWidth(40),
                                    color: Color(0xFF535353),
                                    fontFamily: FontFamily.regular,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))),
        Positioned(
            bottom: ScreenUtil().setWidth(108),
            left: ScreenUtil().setWidth(240),
            child: PrimaryButton(
                width: 600,
                height: 124,
                child: Center(
                    child: Text(
                  "Cash Out",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    height: 1,
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setWidth(56),
                  ),
                ))))
      ]),
    );
  }
}

class WithDrawProvider with ChangeNotifier {
  //TODO 提现数目是否写死?
  List availableAmountList = [0.5, 20, 50, 100, 200, 300];
  List<WithDrawAmountItem> _amountList;

  WithDrawProvider() {
    _amountList = availableAmountList
        .map((val) =>
            WithDrawAmountItem(val, false, val == availableAmountList[0]))
        .toList();
    _typesList =
        availableTypesList.map((e) => WithDrawTypesItem(false, e)).toList();
  }

  selectAmountItem(WithDrawAmountItem item) {
    _amountList.forEach((e) {
      e.selected = false;
    });
    item.selected = true;
    notifyListeners();
  }

  List availableTypesList = [
    WithDrawTypes.Type_Paypal,
    WithDrawTypes.Type_Amazon
  ];
  List<WithDrawTypesItem> _typesList;

  selectTypesItem(WithDrawTypesItem item) {
    _typesList.forEach((e) {
      e.selected = false;
    });

    item.selected = true;
    notifyListeners();
  }
}

enum WithDrawTypes { Type_Paypal, Type_Amazon }

class WithDrawTypesItem {
  bool selected;
  WithDrawTypes type;

  WithDrawTypesItem(this.selected, this.type);
}

class WithDrawTypesItemWidget extends StatelessWidget {
  final WithDrawTypesItem item;
  WithDrawTypesItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    String imgUrl = item.type == WithDrawTypes.Type_Paypal
        ? "assets/image/withdraw_paypal.png"
        : "assets/image/withdraw_amazon.png";
    return Container(
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(300),
      height: ScreenUtil().setWidth(100),
      decoration: BoxDecoration(
          border: item.selected
              ? Border.all(
                  width: ScreenUtil().setWidth(6),
                  style: BorderStyle.solid,
                  color: Color.fromRGBO(41, 191, 76, 1),
                )
              : Border.all(width: 0),
          image: DecorationImage(
            alignment: Alignment.center,
            image: AssetImage(imgUrl),
            fit: BoxFit.cover,
          ),
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(20)))),
    );
  }
}

class WithDrawAmountItem {
  bool selected;
  num amount;
  // 判断是第一个选项,特殊处理
  bool first = false;

  WithDrawAmountItem(this.amount, this.selected, this.first);
}

class WithDrawAmountItemWidget extends StatelessWidget {
  final WithDrawAmountItem item;
  WithDrawAmountItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Container(
          alignment: Alignment.center,
          width: ScreenUtil().setWidth(300),
          height: ScreenUtil().setWidth(100),
          //TODO 背景颜色渐变
          decoration: BoxDecoration(
              color: item.selected ? MyTheme.primaryColor : Color(0xFFEFEEF3),
              borderRadius:
                  BorderRadius.all(Radius.circular(ScreenUtil().setWidth(20)))),
          child: Text("\$${item.amount}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: FontFamily.semibold,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: ScreenUtil().setWidth(50))),
        ),
        item.first
            ? Positioned(
                right: -ScreenUtil().setWidth(10),
                top: -ScreenUtil().setWidth(10),
                child: Image.asset(
                  "assets/image/withdraw_first_cash.png",
                  width: ScreenUtil().setWidth(60),
                  height: ScreenUtil().setWidth(40),
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                width: 0,
                height: 0,
              )
      ],
    );
  }
}
