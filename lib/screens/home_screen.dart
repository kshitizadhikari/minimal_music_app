import 'package:flutter/material.dart';
import 'package:minimal_music_app/components/my_drawer.dart';
import 'package:minimal_music_app/models/playlist_provider.dart';
import 'package:minimal_music_app/models/song.dart';
import 'package:minimal_music_app/screens/song_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
  void gotoSong(int songIndex) {
    //update current song index
    playlistProvider.currentSongIndex = songIndex;

    //navigate to song page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('P L A Y L I S T'),
      ),
      drawer: MyDrawer(),
      body: Consumer<PlaylistProvider>(builder: (context, value, child) {
        //get the playlist
        final List<Song> playlist = value.playlist;

        //return the list view UI
        return ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              final Song song = playlist[index];
              return ListTile(
                title: Text(song.songName),
                subtitle: Text(song.artistName),
                leading: Image.asset(song.albumArtImagePath),
                onTap: () => gotoSong(index),
              );
            });
      }),
    );
  }
}
