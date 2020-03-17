import 'package:flutter/material.dart';
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
      onTap: () {
        bool _isSelect = !isSelect;
        setState(() {
          isSelect = _isSelect;
        });
        widget.onClick(_isSelect);
      },
      child: Container(
        height: ScreenUtil().setWidth(200),
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
    Modal(
        onCancel: () {},
        verticalPadding: 0,
        horizontalPadding: 0,
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
                child: Center(
                    child: ModalTitle(
                  'Warehouse',
                  color: Colors.white,
                )),
              ),
              Container(
                height: ScreenUtil().setWidth(740),
                width: ScreenUtil().setWidth(840),
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) => ListItem(
                        warehouseTreeList[index],
                        onClick: (bool isSelect) => isSelect
                            ? treeList.add(warehouseTreeList[index])
                            : treeList.remove(warehouseTreeList[index])),
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(color: MyTheme.mainItemColor),
                    itemCount: warehouseTreeList.length),
              ),
              GestureDetector(
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
