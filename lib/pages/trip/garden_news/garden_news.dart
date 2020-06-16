/*
 * @Description: 
 * @Author:  bean^ <bean_4@163.com>
 * @Date: 2020-06-12 14:36:53
 * @LastEditors:  bean^ <bean_4@163.com>
 * @LastEditTime: 2020-06-16 15:07:53
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/models/index.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/compatible_avatar_widget.dart';
import 'package:luckyfruit/theme/public/primary_btn.dart';
import 'package:luckyfruit/widgets/modal.dart';
import 'package:provider/provider.dart';

class GardenNews {
  static Modal _modal;
  static Function closeCallBack;

  static show({Function callBack}) {
    closeCallBack = callBack;
    Modal(
        verticalPadding: 0,
        horizontalPadding: 0,
        closeIconDelayedTime: 0,
        width: 1080,
        decorationColor: Color.fromRGBO(0, 0, 0, 0),
        childrenBuilder: (Modal modal) {
          _modal = modal;
          return <Widget>[
            Container(
              width: ScreenUtil().setWidth(960),
              height: ScreenUtil().setHeight(362),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/image/garder_news.png'),
                      alignment: Alignment.center,
                      fit: BoxFit.fill)),
              child: Stack(children: [
                Positioned(
                    bottom: ScreenUtil().setWidth(64),
                    left: 0,
                    child: Container(
                        width: ScreenUtil().setWidth(960),
                        height: ScreenUtil().setHeight(70),
                        child: Text(
                          'Garden News!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: FontFamily.bold,
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(72)),
                        ))),
                Positioned(
                    bottom: ScreenUtil().setWidth(44),
                    right: ScreenUtil().setWidth(47),
                    child: Container(
                      width: ScreenUtil().setWidth(100),
                      height: ScreenUtil().setWidth(100),
                      child: GestureDetector(
                        onTap: () {
                          modal.hide();
                        },
                        child: Center(
                            child: Image.asset(
                          'assets/image/lucky_wheel_close.png',
                          width: ScreenUtil().setWidth(50),
                          height: ScreenUtil().setWidth(50),
                        )),
                      ),
                    ))
              ]),
            ),
            _Grden(),
          ];
        }).show();
  }

  static hide() {
    _modal.hide();
    if (closeCallBack != null) {
      closeCallBack();
    }
  }
}

class _Grden extends StatefulWidget {
  final Function closeCallBack;
  _Grden({Key key, this.closeCallBack}) : super(key: key);

  @override
  __GrdenState createState() => __GrdenState();
}

class __GrdenState extends State<_Grden> {
  List<GrdenNews> grdenNewsList = [];
  GrdenNews selectNews;
  ScrollController _controller = new ScrollController();
  double top = 0.0;
  GlobalKey list = new GlobalKey(debugLabel: '_for_list');
  GlobalKey view = new GlobalKey(debugLabel: '_for_view');
  double listHeight = ScreenUtil().setWidth(920);
  double barHeight = ScreenUtil().setWidth(550);
  double scrollViewHeight = 0.0;
  double itemHeight = ScreenUtil().setWidth(194);
  double marginHeight = ScreenUtil().setWidth(30);
  bool isRevenge = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _controller.offset;
      setState(() {
        top = (listHeight - barHeight) *
            _controller.offset /
            (scrollViewHeight - listHeight);
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);
      List list = await Service()
          .gardenList({"deblock_tree_level": treeGroup.hasMaxLevel});

      setState(() {
        grdenNewsList = list.map((e) => GrdenNews.fromJson(e)).toList();
      });
      scrollViewHeight = list.length * itemHeight + marginHeight;
    });
  }

  revenge() {
    if (isRevenge) {
      if (widget.closeCallBack != null) {
        widget.closeCallBack();
      }
      return;
    }
    isRevenge = true;
    if (selectNews == null) {
      setState(() {
        selectNews = grdenNewsList[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    List<Widget> _children = grdenNewsList
        .map((news) => _ListItem(news,
                isSelect: news == selectNews,
                height: itemHeight,
                marginHeight: marginHeight, onClick: () {
              setState(() {
                selectNews = selectNews == news ? null : news;
              });
            }))
        .toList();

    children
      ..addAll(_children)
      ..add(SizedBox(height: marginHeight));

    return Stack(children: [
      Container(
        width: ScreenUtil().setWidth(960),
        height: ScreenUtil().setWidth(1200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(ScreenUtil().setWidth(100)),
              bottomRight: Radius.circular(ScreenUtil().setWidth(100))),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
            height: ScreenUtil().setWidth(32),
          ),
          Expanded(
              child: Container(
            width: ScreenUtil().setWidth(960),
            height: listHeight,
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(15),
              right: ScreenUtil().setWidth(20),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: ScreenUtil().setWidth(880),
                    height: listHeight,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(252, 250, 232, 1),
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(20))),
                    ),
                    child: SingleChildScrollView(
                      controller: _controller,
                      child: Column(
                        key: list,
                        children: children,
                      ),
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(20),
                    height: listHeight,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(252, 250, 232, 1),
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(10))),
                    ),
                    child: Stack(children: [
                      Positioned(
                          top: top,
                          child: Container(
                            width: ScreenUtil().setWidth(20),
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 172, 30, 1),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(10))),
                            ),
                            child: null,
                          ))
                    ]),
                  )
                ]),
          )),
          SizedBox(
            height: ScreenUtil().setWidth(60),
          ),
          GestureDetector(
            onTap: revenge,
            child: PrimaryButton(
              // minWidth: ScreenUtil().setWidth(560),
              width: 600,
              height: 128,
              colors: <Color>[
                Color.fromRGBO(51, 199, 86, 1),
                Color.fromRGBO(36, 182, 69, 1)
              ],

              child: Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Image.asset(
                      'assets/image/attack.png',
                      height: ScreenUtil().setWidth(84),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(244),
                      height: ScreenUtil().setWidth(60),
                      child: Center(
                          child: Text(
                        'Revenge!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: FontFamily.bold,
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(58)),
                      )),
                    )
                  ])),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(60),
          ),
        ]),
      ),
      // Positioned(child: null)
    ]);
  }
}

class _ListItem extends StatefulWidget {
  final GrdenNews grdenNews;
  final double height;
  final double marginHeight;
  final void Function() onClick;
  final bool isSelect;
  _ListItem(this.grdenNews,
      {Key key, this.onClick, this.isSelect, this.height, this.marginHeight})
      : super(key: key);

  @override
  __ListItemState createState() => __ListItemState();
}

class __ListItemState extends State<_ListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onClick,
      child: Container(
        width: ScreenUtil().setWidth(840),
        height: widget.height,
        child: Column(
          children: <Widget>[
            SizedBox(height: widget.marginHeight),
            Container(
              width: ScreenUtil().setWidth(840),
              height: ScreenUtil().setWidth(163),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 236, 153, 1),
                  borderRadius: BorderRadius.all(Radius.circular(
                    ScreenUtil().setWidth(10),
                  )),
                  border: widget.isSelect
                      ? Border.all(
                          width: ScreenUtil().setWidth(6),
                          style: BorderStyle.solid,
                          color: Color.fromRGBO(255, 172, 30, 1),
                        )
                      : null),
              child: Stack(children: [
                Container(
                  width: ScreenUtil().setWidth(840),
                  height: ScreenUtil().setWidth(163),
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(10),
                    right: ScreenUtil().setWidth(20),
                  ),
                  child: Row(children: [
                    Container(
                        width: ScreenUtil().setWidth(140),
                        height: ScreenUtil().setWidth(140),
                        alignment: Alignment(0.0, -1.0),
                        child: Container(
                          width: ScreenUtil().setWidth(120),
                          height: ScreenUtil().setWidth(120),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(90)),
                              border: Border.all(
                                width: ScreenUtil().setWidth(3),
                                style: BorderStyle.solid,
                                color: Colors.white,
                              )),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(90)),
                            child: CompatibleNetworkAvatarWidget(
                              widget.grdenNews.avatar,
                              defaultImageUrl:
                                  "assets/image/rank_page_portrait_default.png",
                              width: ScreenUtil().setWidth(100),
                              height: ScreenUtil().setWidth(100),
                              fit: BoxFit.contain,
                            ),
                          ),
                        )),
                    SizedBox(
                      width: ScreenUtil().setWidth(40),
                    ),
                    Expanded(
                        child: Text(
                      widget.grdenNews.content,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color.fromRGBO(97, 66, 22, 1),
                          fontFamily: FontFamily.semibold,
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(42)),
                    )),
                    Text(
                      '${widget.grdenNews.space_time} ago',
                      style: TextStyle(
                          color: MyTheme.blackColor,
                          fontFamily: FontFamily.bold,
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(36)),
                    )
                  ]),
                ),
                Positioned(
                    left: 0,
                    bottom: ScreenUtil().setWidth(2),
                    child: Container(
                      width: ScreenUtil().setWidth(156),
                      height: ScreenUtil().setWidth(47),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: ScreenUtil().setWidth(3),
                            color: Colors.white,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.only(
                          topRight:
                              Radius.circular((ScreenUtil().setWidth(40))),
                        ),
                        gradient: LinearGradient(
                            begin: Alignment(-1.0, 0.0),
                            end: Alignment(1.0, 0.0),
                            colors: [
                              // Color.fromRGBO(46, 146, 223, 1),
                              Color.fromRGBO(247, 122, 45, 1),
                              Color.fromRGBO(234, 91, 27, 1),
                            ]),
                      ),
                      child: Text(
                        widget.grdenNews.nickname,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: FontFamily.semibold,
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(36)),
                      ),
                    ))
              ]),
            )
          ],
        ),
      ),
    );
  }
}
