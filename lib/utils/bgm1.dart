import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class Bgm {
  init() {
    _MainBgm.init();
  }
}

class _MainBgm {
  static AudioCache player = new AudioCache();
  static const String alarmAudioPath = "bgm/bgm.mp3";

  static init() {
    player.loop(_MainBgm.alarmAudioPath);
  }
}

class _CoinBgm {
  static AudioCache player = new AudioCache();
  static const String alarmAudioPath = "bgm/coin_increase.mp3";

  static init() {
    player.play(_CoinBgm.alarmAudioPath);
  }
}

class _Merge_tree {
  static AudioCache player = new AudioCache();
  static const String alarmAudioPath = "bgm/merge_tree.mp3";

  static init() {
    player.play(_Merge_tree.alarmAudioPath);
  }
}

class _Puchase_tree {
  static AudioCache player = new AudioCache();
  static const String alarmAudioPath = "bgm/puchase_tree.mp3";

  static init() {
    player.play(_Puchase_tree.alarmAudioPath);
  }
}
