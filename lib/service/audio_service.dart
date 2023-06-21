import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  final AudioPlayer _player = AudioPlayer();

  factory AudioService() {
    return _instance;
  }

  AudioService._internal() {
    // _player.audioCache.loadAll(['sounds/teroren.mp3']);
    _player.setAsset('sound/teroren.mp3');
  }

  void play() async {
    _player.play().then((_) => _player.pause());
  }
}
