import 'package:firebase_messaging/firebase_messaging.dart';
import './event_bus.dart';

/**
 * https://medium.com/@kenaragorn/flutter-push-notification-with-firebase-cloud-messaging-fcm-and-routing-to-specific-screen-b065742f2e5e
 */
class FbMsg {
  static init(String accId) {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          _handelMsg(message);
        },
        onBackgroundMessage: _myBackgroundMessageHandler,
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          _handelMsg(message);
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          _handelMsg(message);
        });
    try {
      firebaseMessaging.getToken().then((token) {
        // Service().updateUser({'acct_id': accId, "token": token});
        print(token); // Print the Token in Console
      });
    } catch (e) {
      print('firebaseMessaging----------------error $e');
    }
  }

  static _handelMsg(Map<String, dynamic> message) {
    if (message['data'] != null) {
      var data = message['data'];
      if (data['key'] != null) {
        EVENT_BUS.emit('navGo', data['key']);
      }
    }
  }

  static Future<dynamic> _myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    _handelMsg(message);

    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      print(data);
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print(notification);
    }
  }
}
