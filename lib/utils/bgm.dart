import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:luckyfruit/config/app.dart';
import './event_bus.dart';

class Bgm {
  static AudioCache player = new AudioCache(prefix: 'bgm/');
  static AudioPlayer fixedPlayer;
  static String _main = 'bgm.mp3';
  static String _coin_increase = 'coin_increase.mp3';
  static String _merge_tree = 'merge_tree.mp3';
  static String _puchase_tree = 'puchase_tree.mp3';

  static bool isPlay = false;
  static bool _canPlay = true;

  static init() {
    AudioPlayer.logEnabled = false;
    Bgm.player.loadAll(
        [Bgm._main, Bgm._coin_increase, Bgm._merge_tree, Bgm._puchase_tree]);
    play();
    EVENT_BUS.on(Event_Name.APP_PAUSED, (_) {
      _canPlay = false;
      fixedPlayer.stop();
      try {
        fixedPlayer.dispose();
      } catch (e) {}
    });
    EVENT_BUS.on(Event_Name.APP_RESUMED, (_) async {
      _canPlay = true;
      if (isPlay) {
        fixedPlayer = await Bgm.player.loop(Bgm._main);
      }
    });
  }

  static stop() {
    isPlay = false;
    fixedPlayer.stop();
  }

  static play() async {
    isPlay = true;
    fixedPlayer = await Bgm.player.loop(Bgm._main);
  }

  static coinIncrease() {
    if (isPlay && _canPlay) {
      Bgm.player.play(Bgm._coin_increase);
    }
  }

  static mergeTree() {
    if (isPlay && _canPlay) {
      Bgm.player.play(Bgm._merge_tree);
    }
  }

  static puchaseTree() {
    if (isPlay) {
      Bgm.player.play(Bgm._puchase_tree);
    }
  }
}
