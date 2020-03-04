import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/elliptical_widget.dart';
import './tree_item.dart';

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
        children: <Widget>[
          Positioned(
              left: 0,
              bottom: 0,
              child: EllipticalWidget(
                width: ScreenUtil().setWidth(200),
                height: ScreenUtil().setWidth(100),
                color: MyTheme.grayColor,
              )),
          widget.tree != null
              ? Positioned(
                  bottom: ScreenUtil().setWidth(25),
                  child: Center(
                    child: Draggable(
                        child: _tree,
                        // feedback: _tree,
                        feedback: TreeNoAnimation(widget.tree),
                        data: widget.tree,
                        childWhenDragging: Container()),
                  ),
                )
              : Container()
          // Positioned(child: null)
        ],
      ),
    );
  }
}
