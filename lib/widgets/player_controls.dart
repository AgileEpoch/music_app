import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerControls extends StatelessWidget {
  final AudioPlayer player;
  final bool isPlaying;
  final VoidCallback onPlayPause;

  const PlayerControls({
    super.key,
    required this.player,
    required this.isPlaying,
    required this.onPlayPause,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 60,
      icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
      color: Colors.red,
      onPressed: onPlayPause,
    );
  }
}
