import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimal_music_app/components/my_drawer.dart';
import 'package:minimal_music_app/components/neu_box.dart';
import 'package:minimal_music_app/screens/favourites_screen.dart';
import 'package:minimal_music_app/screens/lyrics_finder_screen.dart';
import 'package:minimal_music_app/screens/playlist_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext x) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 27),
          child: Text(
            'MusicVerse',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              letterSpacing: 5,
              shadows: [
                Shadow(
                  blurRadius:5.0,  // shadow blur
                  color: Colors.green, // shadow color
                  offset: Offset(4.0,4.0), // how much shadow will be shown
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const MyDrawer(),
      body: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: NeuBox(
                child: ListTile(
                  title: const Text(
                    'My Favourites',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5),
                  ),
                  trailing: const Icon(Icons.favorite),
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FavoriteScreen()),
                    ),
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: NeuBox(
                child: ListTile(
                  title: const Text(
                    'Songs',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5),
                  ),
                  trailing: const Icon(Icons.my_library_music_rounded),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PlaylistScreen()),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: NeuBox(
                child: ListTile(
                  title: const Text(
                    'Lyrics Finder',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5),
                  ),
                  trailing: const Icon(Icons.lyrics),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LyricsFinder()),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
    );
  }
}
