import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/utils/burial_report.dart';

class InstructionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BurialReport.report('page_imp', {'page_code': '017'});

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              iconSize: 20,
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(
            color: MyTheme.blackColor,
          ),
          title: Align(
            alignment: Alignment(-0.4, 0),
            child: Text(
              'Instruction',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: MyTheme.blackColor,
                  fontSize: ScreenUtil().setSp(70),
                  fontFamily: FontFamily.bold,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              child: Image.asset(
            'assets/image/instruction.jpg',
            fit: BoxFit.cover,
            width: ScreenUtil().setWidth(1080),
          )),
        ));
  }
}
