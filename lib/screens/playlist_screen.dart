import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimal_music_app/components/my_textfield.dart';
import 'package:minimal_music_app/components/neu_box.dart';
import 'package:minimal_music_app/models/playlist_provider.dart';
import 'package:minimal_music_app/models/song.dart';
import 'package:minimal_music_app/screens/song_screen.dart';
import 'package:provider/provider.dart';

class PlaylistScreen extends StatefulWidget {
  PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  //get the playlist provider
  late final dynamic playlistProvider;

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
    if (playlistProvider != null) {
      // Call the searchSong method with the provided value
      playlistProvider.searchSong(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Consumer<PlaylistProvider>(builder: (context, value, child) {
          //get the playlist
          value.loadSongs(user.uid);
          var playlist = value.playlist;
          // return the list view UI
          return Padding(
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
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 5,
                            ),
                          ),

                          //menu button
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: const Icon(Icons.menu),
                          // ),
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.asset("assets/images/music2.gif"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
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
                      itemCount: playlist.length,
                      itemBuilder: (context, index) {
                        final Song song = playlist[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: NeuBox(
                            child: ListTile(
                              title: Text(song.songName),
                              subtitle: Text(song.artistName),
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.asset(song.albumArtImagePath)),
                              onTap: () => gotoSong(index),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
