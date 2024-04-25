import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimal_music_app/components/my_textfield.dart';
import 'package:minimal_music_app/components/my_drawer.dart';
import 'package:minimal_music_app/components/neu_box.dart';
import 'package:minimal_music_app/models/playlist_provider.dart';
import 'package:minimal_music_app/models/song.dart';
import 'package:minimal_music_app/screens/song_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        builder: (context) => const SongScreen(),
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('MusicVerse'),
      ),
      drawer: const MyDrawer(),
      body: Consumer<PlaylistProvider>(builder: (context, value, child) {
        //get the playlist
        value.loadSongs();
        var playlist = value.playlist;
        // return the list view UI
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: NeuBox(
                child: MyTextField(
                  hintText: 'Enter a song',
                  obscureText: false,
                  labelText: 'Search',
                  suffixIcon: const Icon(Icons.search),
                  onChanged: (value) => runFilter(value),
                ),
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
                          leading: Image.asset(song.albumArtImagePath),
                          onTap: () => gotoSong(index),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        );
      }),
    );
  }


}
