import "package:eventsource/eventsource.dart";
import 'package:luckyfruit/config/app.dart';

class Sse {
  static init() async {
    EventSource eventSource =
        await EventSource.connect('${App.BASE_URL}/Index/realLook');

    eventSource.listen((Event event) {
      print("New event:-------------------------");
      print("  event: ${event.event}");
      print("  data: ${event.data}");
    });
  }
}
