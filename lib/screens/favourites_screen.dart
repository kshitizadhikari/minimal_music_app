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

  //get the playlist provider
  late final PlaylistProvider playlistProvider;
  List<Song> favPlaylist = [];

  @override
  void initState() {
    super.initState();
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  //goto a song
  void gotoSong(int index) {
    //update current song index

    playlistProvider.currentSongIndex = index;

    //navigate to song page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongScreen(user: user),
      ),
    );
  }

  //search a song
  void runFilter(String value) {
    // Check if playlistProvider is initialized
    // Call the searchSong method with the provided value
    playlistProvider.searchSong(value);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Consumer<PlaylistProvider>(builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: FutureBuilder(
              future: value.loadFavoriteSongs(user.uid),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  favPlaylist = snapshot.data!;
                  if (favPlaylist.isEmpty) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //back button
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                        Icons.arrow_back_ios_new_outlined),
                                  ),

                                  //title
                                  const Text(
                                    'MusicVerse',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 5,
                                    ),
                                  ),

                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child:
                                        Image.asset("assets/images/music2.gif"),
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
                                suffixIcon: const Icon(Icons.search),
                                onChanged: (value) => runFilter(value),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 200),
                        const Center(
                          child: Text(
                            '    No\nFavourite\n  Songs',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              letterSpacing: 5,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //back button
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                        Icons.arrow_back_ios_new_outlined),
                                  ),

                                  //title
                                  const Text(
                                    'MusicVerse',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 5,
                                    ),
                                  ),

                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child:
                                        Image.asset("assets/images/music2.gif"),
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
                                suffixIcon: const Icon(Icons.search),
                                onChanged: (value) => runFilter(value),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                              itemCount: favPlaylist.length,
                              itemBuilder: (context, index) {
                                final Song song = favPlaylist[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: NeuBox(
                                    child: ListTile(
                                      title: Text(song.songName),
                                      subtitle: Text(song.artistName),
                                      leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Image.asset(
                                              song.albumArtImagePath)),
                                      onTap: () => gotoSong(index),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    );
                  }
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const MyPopUp(
                      title: 'Music Error', message: 'Error fetching music');
                }
              }),
            ),
          );
        }),
      ),
    );
  }
}
