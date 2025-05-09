import 'dart:async';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';
import '../widgets/player_controls.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  final player = AudioPlayer();
  String? fileName;
  Duration? duration;
  Duration position = Duration.zero;
  bool isPlaying = false;
  Timer? sleepTimer;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null && result.files.single.path != null) {
      await player.setFilePath(result.files.single.path!);
      fileName = result.files.single.name;
      player.play();
      setState(() => isPlaying = true);
      player.durationStream.listen((d) {
        setState(() => duration = d);
      });
      player.positionStream.listen((p) {
        setState(() => position = p);
      });
    }
  }

  void togglePlayPause() {
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
    setState(() => isPlaying = player.playing);
  }

  void setSleepTimer(int minutes) {
    sleepTimer?.cancel();
    sleepTimer = Timer(Duration(minutes: minutes), () {
      player.stop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã tắt nhạc sau $minutes phút.')),
      );
      setState(() => isPlaying = false);
    });
  }

  @override
  void dispose() {
    player.dispose();
    sleepTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formatTime(Duration d) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agileepoch Music'),
        actions: [
          PopupMenuButton<int>(
            onSelected: setSleepTimer,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 5, child: Text("5 phút")),
              const PopupMenuItem(value: 10, child: Text("10 phút")),
              const PopupMenuItem(value: 30, child: Text("30 phút")),
            ],
            icon: const Icon(Icons.timer),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.music_note, size: 100, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              fileName ?? "Chưa chọn bài nhạc",
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Slider(
              value: position.inSeconds.toDouble(),
              max: (duration?.inSeconds ?? 1).toDouble(),
              onChanged: (value) {
                player.seek(Duration(seconds: value.toInt()));
              },
              activeColor: Colors.red,
            ),
            Text(
              "${formatTime(position)} / ${formatTime(duration ?? Duration.zero)}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlayerControls(
                  player: player,
                  isPlaying: isPlaying,
                  onPlayPause: togglePlayPause,
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.folder_open),
                  label: const Text("Chọn nhạc"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: pickFile,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
