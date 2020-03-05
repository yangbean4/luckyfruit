import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

import './event_bus.dart';
import 'package:luckyfruit/config/app.dart';

class NativeEvent {
  String name;
  dynamic data;
}

class ChannelBus {
  ChannelBus._internal() {
    if (_onEvent == null) {
      _eventLisen();
    }
  }

  static ChannelBus _singleton = new ChannelBus._internal();

  factory ChannelBus() => _singleton;

  var _emap = new Map<Object, List<EventCallback>>();

  MethodChannel methodChannel = new MethodChannel(App.METHOD_CHANNEL);
  BasicMessageChannel basicMessageChannel = new BasicMessageChannel<Object>(
      App.EVENT_CHANNEL, StandardMessageCodec());
  EventCallback _onEvent;

  void _eventLisen() {
    _onEvent = (_event) {
      var event = _event;
      var list = _emap[event["name"]];
      if (list == null) return;
      int len = list.length - 1;
      //反向遍历，防止订阅者在回调中移除自身带来的下标错位
      for (var i = len; i > -1; --i) {
        list[i](event["data"]);
      }
    };

    // eventChannel.receiveBroadcastStream().listen(_onEvent,
    //     onError: (Object error) {
    //   print("Failed to get battery level: '$error'.");
    // });

    basicMessageChannel.setMessageHandler((msg) async {
      // print('==================================');
      print('Native post: $msg');
      _onEvent(msg); // todo confirm
    });
  }

//   Future<Map<String, dynamic>>
  Future callNativeMethod(String methodName, {dynamic arguments}) async {
    print("callNativeMethod:" + methodName);
    print("callNativeMethod arguments:" + arguments.toString());
    Map<String, dynamic> result;
    try {
      String resultstr =
          await methodChannel.invokeMethod(methodName, arguments);
      result = json.decode(resultstr);
    } catch (e) {
      print("Failed to call ${methodName}: '${e}'.");
    }
    print('调用native方法 $methodName:返回:${result.toString()}');
    return result;
  }

  registerReceiver(String eventName, EventCallback f) {
    if (eventName == null || f == null) return;
    _emap[eventName] ??= new List<EventCallback>();
    _emap[eventName].add(f);
  }

  unRegisterReceiver(eventName, [EventCallback f]) {
    var list = _emap[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _emap[eventName] = null;
    } else {
      list.remove(f);
      print(list.length);
    }
  }
}

var channelBus = new ChannelBus();
