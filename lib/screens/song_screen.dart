import 'package:flutter/material.dart';
import 'package:minimal_music_app/components/neu_box.dart';

class SongScreen extends StatelessWidget {
  const SongScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: const Text("S O N G  P A G E"),
      ),
      body: Center(
        child: NeuBox(child: Icon(Icons.abc),),
      ),
    );
  }
}
