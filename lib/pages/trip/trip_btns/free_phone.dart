import 'package:flutter/material.dart';

class FreePhone extends StatefulWidget {
  final Widget child;
  FreePhone({Key key, this.child}) : super(key: key);

  @override
  _FreePhoneState createState() => _FreePhoneState();
}

class _FreePhoneState extends State<FreePhone> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("object");
      },
      child: widget.child,
    );
  }
}
