import 'dart:async';
import 'package:flutter/material.dart';
import 'package:luckyfruit/utils/index.dart';

class Countdown extends StatefulWidget {
  const Countdown({
    Key key,
    @required this.duration,
    @required this.builder,
    this.onFinish,
    this.interval = const Duration(seconds: 1),
  }) : super(key: key);

  final Duration duration;
  final Duration interval;
  final void Function() onFinish;
  final Widget Function(BuildContext context, Duration remaining) builder;
  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  Timer _timer;
  Duration _duration;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _duration = widget.duration;
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(widget.interval, timerCallback);
  }

  void timerCallback(Timer timer) {
    if (mounted)
      setState(() {
        if (_duration.inSeconds == 0) {
          timer.cancel();
          if (widget.onFinish != null) widget.onFinish();
        } else {
          _duration -= widget.interval;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _duration);
  }
}

class CountdownFormatted extends StatelessWidget {
  const CountdownFormatted({
    Key key,
    @required this.duration,
    @required this.builder,
    this.onFinish,
    this.interval = const Duration(seconds: 1),
  }) : super(key: key);

  final Duration duration;
  final Duration interval;
  final void Function() onFinish;
  final Widget Function(BuildContext context, Duration remaining) builder;

  @override
  Widget build(BuildContext context) {
    return Countdown(
      interval: interval,
      onFinish: onFinish,
      duration: duration,
      builder: (BuildContext ctx, Duration remaining) {
        return builder(ctx, remaining);
      },
    );
  }
}
