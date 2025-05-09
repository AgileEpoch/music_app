import 'package:flutter/material.dart';
import 'screens/music_player_page.dart';

void main() {
  runApp(const AgileepochMusicApp());
}

class AgileepochMusicApp extends StatelessWidget {
  const AgileepochMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agileepoch Music',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const MusicPlayerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
