import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer player = AudioPlayer();

  Future<void> setAudioFile(String path) async {
    await player.setFilePath(path);
  }

  Future<void> play() async => await player.play();
  Future<void> pause() async => await player.pause();
  Future<void> stop() async => await player.stop();
}
