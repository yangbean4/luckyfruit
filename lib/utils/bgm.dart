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

  static bool isPlay = true;

  static init() {
    AudioPlayer.logEnabled = false;
    Bgm.player.loadAll(
        [Bgm._main, Bgm._coin_increase, Bgm._merge_tree, Bgm._puchase_tree]);
    play();
    EVENT_BUS.on(Event_Name.APP_PAUSED, (_) {
      stop();
      fixedPlayer.dispose();
    });
  }

  static stop() {
    isPlay = false;
    fixedPlayer.stop();
  }

  static play() async {
    fixedPlayer = await Bgm.player.loop(Bgm._main);
  }

  static coinIncrease() {
    if (!isPlay) {}
    Bgm.player.play(Bgm._coin_increase);
  }

  static mergeTree() {
    Bgm.player.play(Bgm._merge_tree);
  }

  static puchaseTree() {
    Bgm.player.play(Bgm._puchase_tree);
  }
}
