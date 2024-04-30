import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimal_music_app/components/my_textfield.dart';
import 'package:minimal_music_app/components/neu_box.dart';
import 'package:minimal_music_app/models/playlist_provider.dart';
import 'package:minimal_music_app/models/song.dart';
import 'package:minimal_music_app/screens/song_screen.dart';
import 'package:provider/provider.dart';

import '../components/popup.dart';

class FavoriteScreen extends StatefulWidget {
  FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  late final PlaylistProvider playlistProvider;
  late Future<List<Song>> _favoriteSongsFuture;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    _favoriteSongsFuture = playlistProvider.loadFavoriteSongs(user.uid, "");
  }

  void gotoFavoriteSong(int index) {
    playlistProvider.currentSongIndex = index;
    //navigate to song page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongScreen(user: user),
      ),
    );
  }

  void runFilter(String value) {
    // Cancel the previous debounce timer
    _debounceTimer?.cancel();

    // Set a new debounce timer
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        // Reload the favorite songs future with the filtered search parameter
        _favoriteSongsFuture =
            playlistProvider.loadFavoriteSongs(user.uid, value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: Column(
            children: [
              // Your common UI elements here
              // Back button, title, search field, etc.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //back button
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_outlined),
                  ),

                  //title
                  const Text(
                    'MusicVerse',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0, // shadow blur
                          color: Colors.blue, // shadow color
                          offset:
                              Offset(4.0, 4.0), // how much shadow will be shown
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
              const Text(
                'My Favourites',
                style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 20,),
              // search box
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MyTextField(
                  hintText: 'Enter a song',
                  obscureText: false,
                  labelText: 'Search in Favourites',
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary,),
                  ),
                  onChanged: (value) => runFilter(value),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Song>>(
                  future: _favoriteSongsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const MyPopUp(
                        title: 'Music Error',
                        message: 'Error fetching music',
                      );
                    } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No Favourite Songs',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            letterSpacing: 5,
                          ),
                        ),
                      );
                    } else {
                      final favPlaylist = snapshot.data!;
                      return ListView.builder(
                        itemCount: favPlaylist.length,
                        itemBuilder: (context, index) {
                          final song = favPlaylist[index];
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
                                onTap: () => gotoFavoriteSong(index),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
