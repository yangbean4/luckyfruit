import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/elliptical_widget.dart';
import './tree_item.dart';
import './tree_no_animation.dart';

class GridItem extends StatefulWidget {
  final Tree tree;
  GridItem({Key key, this.tree}) : super(key: key);

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  @override
  Widget build(BuildContext context) {
    Widget _tree = TreeItem(widget.tree);

    return Container(
      width: ScreenUtil().setWidth(200),
      height: ScreenUtil().setWidth(210),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                  width: ScreenUtil().setWidth(200),
                  height: ScreenUtil().setWidth(100),
                  decoration: BoxDecoration(
                      color: MyTheme.grayColor,
                      borderRadius: BorderRadius.all(
                        Radius.elliptical(ScreenUtil().setWidth(200) / 2,
                            ScreenUtil().setWidth(100) / 2),
                      )))),
          widget.tree != null
              ? Positioned(
                  bottom: ScreenUtil().setWidth(25),
                  child: Center(
                      child: Selector<TreeGroup, Function>(
                          selector: (context, provider) =>
                              provider.transRecycle,
                          shouldRebuild: (pre, next) => false,
                          builder: (context, Function transRecycle, child) {
                            return Draggable(
                                child: _tree,
                                onDragStarted: () => transRecycle(widget.tree),
                                onDragEnd: (_) => transRecycle(null),
                                // feedback: _tree,
                                feedback: TreeNoAnimation(widget.tree),
                                data: widget.tree,
                                childWhenDragging: Container());
                          })),
                )
              : Container()
          // Positioned(child: null)
        ],
      ),
    );
  }
}
