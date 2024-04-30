import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimal_music_app/components/my_textfield.dart';
import 'package:minimal_music_app/components/neu_box.dart';
import 'package:minimal_music_app/models/playlist_provider.dart';
import 'package:minimal_music_app/models/song.dart';
import 'package:minimal_music_app/screens/song_screen.dart';
import 'package:provider/provider.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  late final PlaylistProvider playlistProvider;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // Initialize playlist provider
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
        playlistProvider.loadSongs(user.uid, "");
  }

  // Navigate to song screen
  void gotoSong(int index) {
    playlistProvider.currentSongIndex =
        index;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongScreen(user: user),
      ),
    );
  }

  // Search songs
  void runFilter(String value) {
    // Cancel the previous debounce timer
    _debounceTimer?.cancel();

    // Set a new debounce timer
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      // Reload the songs with the filtered search parameter
      playlistProvider.loadSongs(user.uid, value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<PlaylistProvider>(
        builder: (context, playlistProviderModel, child) {
          var playlist = playlistProviderModel.playlist;
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon:
                                  const Icon(Icons.arrow_back_ios_new_outlined),
                            ),
                            const Text(
                              'MusicVerse',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                                letterSpacing: 5,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0, // shadow blur
                                    color: Colors.orange, // shadow color
                                    offset: Offset(4.0,
                                        4.0), // how much shadow will be shown
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.asset("assets/images/music2.gif"),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MyTextField(
                          hintText: 'Enter a song',
                          obscureText: false,
                          labelText: 'Search',
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary,),
                          ),
                          onChanged: (value) => runFilter(value),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: playlist.length,
                      itemBuilder: (context, index) {
                        final Song song = playlist[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: NeuBox(
                            child: ListTile(
                              title: Text(song.songName),
                              // subtitle: Text(song.artistName),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(song.albumArtImagePath),
                              ),
                              onTap: () => gotoSong(index),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
