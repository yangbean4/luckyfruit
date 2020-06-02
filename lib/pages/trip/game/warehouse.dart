import 'package:flutter/material.dart';
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/widgets/modal.dart';
import 'package:luckyfruit/widgets/tree_widget.dart';
import 'package:luckyfruit/theme/public/public.dart';

class ListItem extends StatefulWidget {
  final Tree tree;
  final void Function(bool isSelect) onClick;
  ListItem(this.tree, {Key key, this.onClick}) : super(key: key);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool isSelect = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        bool _isSelect = !isSelect;
        setState(() {
          isSelect = _isSelect;
        });
        widget.onClick(_isSelect);
      },
      child: Container(
        height: ScreenUtil().setWidth(200),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    style: BorderStyle.solid,
                    width: 1,
                    color: MyTheme.mainItemColor))),
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(70)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(180),
              height: ScreenUtil().setWidth(180),
              decoration: BoxDecoration(
                  border: isSelect
                      ? Border.all(width: 1, color: MyTheme.primaryColor)
                      : null),
              child: Center(
                child: TreeWidget(
                  tree: widget.tree,
                  imgHeight: ScreenUtil().setWidth(142),
                  imgWidth: ScreenUtil().setWidth(130),
                  labelWidth: ScreenUtil().setWidth(80),
                  primary: true,
                ),
              ),
            ),
            Expanded(child: SecondaryText(widget.tree.name)),
            SecondaryText('${widget.tree.grade}')
          ],
        ),
      ),
    );
  }
}

class Warehouse extends StatefulWidget {
  final Widget child;

  Warehouse({Key key, this.child}) : super(key: key);

  @override
  _WarehouseState createState() => _WarehouseState();
}

class _WarehouseState extends State<Warehouse> {
  List<Tree> treeList = [];

  _showWillModal(BuildContext context, Tree tree) {
    Modal(
        onCancel: () {},
        closeIconDelayedTime: 0,
        childrenBuilder: (Modal modal) => <Widget>[
              TreeWidget(
                tree: tree,
                imgHeight: ScreenUtil().setWidth(218),
                imgWidth: ScreenUtil().setWidth(237),
                labelWidth: ScreenUtil().setWidth(110),
                primary: true,
              ),
              Container(
                margin: EdgeInsets.only(
                    top: ScreenUtil().setWidth(50),
                    bottom: ScreenUtil().setWidth(60)),
                child: SecondaryText('put it in the warehouse?'),
              ),
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    TreeGroup treeGroup =
                        Provider.of<TreeGroup>(context, listen: false);
                    treeGroup.inWarehouse(tree);
                    modal.hide();
                  },
                  child: PrimaryButton(
                    width: 600,
                    height: 124,
                    text: 'YES',
                  )),
              Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(50),
                ),
                child: ThirdText(
                    "Tips：Trees put in warehouse won't generate revenue"),
              )
            ]).show();
  }

  _showWarehouse(List<Tree> warehouseTreeList) {
    BurialReport.report('page_imp', {'page_code': '013'});
    BurialReport.report('event_entr_click', {'entr_code': '8'});
    List<Widget> children = warehouseTreeList
        .map((tree) => ListItem(tree,
            onClick: (bool isSelect) =>
                isSelect ? treeList.add(tree) : treeList.remove(tree)))
        .toList();

    Modal(
        onCancel: () {},
        verticalPadding: 0,
        horizontalPadding: 0,
        closeIconDelayedTime: 0,
        childrenBuilder: (Modal modal) => <Widget>[
              Container(
                height: ScreenUtil().setWidth(174),
                width: ScreenUtil().setWidth(840),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(ScreenUtil().setWidth(100)),
                    topRight: Radius.circular(ScreenUtil().setWidth(100)),
                  ),
                  gradient: LinearGradient(
                      begin: Alignment(0.0, -1.0),
                      end: Alignment(0.0, 1.0),
                      colors: <Color>[
                        Color.fromRGBO(36, 185, 71, 1),
                        Color.fromRGBO(49, 200, 84, 1)
                      ]),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ModalTitle(
                        'Warehouse',
                        color: Colors.white,
                      ),
                      SizedBox(height: ScreenUtil().setWidth(10)),
                      Text(
                        'Capacity ${warehouseTreeList.length}/${TreeGroup.WAREHOUSE_MAX_LENGTH}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(36),
                            height: 1,
                            fontFamily: FontFamily.semibold,
                            fontWeight: FontWeight.w500),
                      ),
                    ]),
              ),
              Container(
                  height: ScreenUtil().setWidth(740),
                  width: ScreenUtil().setWidth(840),
                  child: SingleChildScrollView(
                    child: Column(
                      children: children,
                    ),
                  )),
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    TreeGroup treeGroup =
                        Provider.of<TreeGroup>(context, listen: false);
                    treeGroup.outWarehouse(treeList);
                    modal.hide();
                  },
                  child: Container(
                      margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(50),
                        bottom: ScreenUtil().setWidth(50),
                      ),
                      child: PrimaryButton(
                        width: 600,
                        height: 124,
                        text: 'Take out',
                      )))
            ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      builder: (context, candidateData, rejectedData) {
        return Selector<TreeGroup, List<Tree>>(
            selector: (context, provider) => provider.warehouseTreeList,
            builder: (context, List<Tree> warehouseTreeList, child) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: widget.child,
                onTap: () {
                  setState(() {
                    treeList = [];
                  });
                  _showWarehouse(warehouseTreeList);
                },
              );
            });
      },
      onWillAccept: (Tree source) {
        _showWillModal(context, source);
        return true;
      },
      onAccept: (Tree source) {
        return true;
      },
    );
  }
}
