import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:luckyfruit/config/app.dart';

import './event_bus.dart';

class Bgm {
  static AudioCache player = new AudioCache(prefix: 'bgm/');
  static AudioPlayer fixedPlayer;
  static String _main = 'bgm.mp3';
  static String coin_increase = 'coin_increase.mp3';
  static String merge_tree = 'merge_tree.mp3';
  static String puchase_tree = 'puchase_tree.mp3';

  static String claimmoney = 'claimmoney.mp3';
  static String claimGold = 'claimgold.mp3';
  static String captainlevelup = 'captainlevelup.mp3';
  static String newleveluptree = 'newleveluptree.mp3';

  static bool isPlay = false;
  static bool _canPlay = true;

  static init() {
    AudioPlayer.logEnabled = false;
    Bgm.player.loadAll([
      Bgm._main,
      Bgm.coin_increase,
      Bgm.merge_tree,
      Bgm.puchase_tree,
      Bgm.claimmoney,
      Bgm.claimGold,
      Bgm.captainlevelup,
      Bgm.newleveluptree
    ]);
    play();
    EVENT_BUS.on(Event_Name.APP_PAUSED, (_) {
      paused();
    });
    EVENT_BUS.on(Event_Name.APP_RESUMED, (_) {
      resumed();
    });

    EVENT_BUS.on(Event_Name.VIEW_AD, (_) {
      paused();
    });
    EVENT_BUS.on(Event_Name.VIEW_AD_END, (_) {
      resumed();
    });
  }

  static paused() {
    _canPlay = false;
    fixedPlayer.stop();
  }

  static resumed() async {
    _canPlay = true;
    if (isPlay &&
        (fixedPlayer == null ||
            (fixedPlayer.state != null &&
                fixedPlayer.state != AudioPlayerState.PLAYING))) {
      fixedPlayer = await Bgm.player.loop(Bgm._main);
    }
  }

  static stop() {
    isPlay = false;
    fixedPlayer?.stop();
  }

  static play() async {
    isPlay = true;
    if (isPlay &&
        (fixedPlayer == null ||
            fixedPlayer.state != AudioPlayerState.PLAYING)) {
      fixedPlayer = await Bgm.player.loop(Bgm._main);
    }
  }

  static coinIncrease() {
    if (isPlay && _canPlay) {
      Bgm.player.play(Bgm.coin_increase);
    }
  }

  static mergeTree() {
    if (isPlay && _canPlay) {
      Bgm.player.play(Bgm.merge_tree);
    }
  }

  static puchaseTree() {
    if (isPlay && _canPlay) {
      Bgm.player.play(Bgm.puchase_tree);
    }
  }

  static playMoney() {
    if (isPlay && _canPlay) {
      Bgm.player.play(Bgm.claimmoney);
    }
  }

  static playClaimGold() {
    if (isPlay && _canPlay) {
      Bgm.player.play(Bgm.claimGold);
    }
  }

  static userlevelup() {
    if (isPlay && _canPlay) {
      Bgm.player.play(Bgm.captainlevelup);
    }
  }

  static treenewlevelup() {
    if (isPlay && _canPlay) {
      Bgm.player.play(Bgm.newleveluptree);
    }
  }
}
