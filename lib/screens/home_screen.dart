import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimal_music_app/components/my_drawer.dart';
import 'package:minimal_music_app/models/playlist_provider.dart';
import 'package:minimal_music_app/models/song.dart';
import 'package:minimal_music_app/screens/song_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
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
  late final List<Song> songs;
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
        builder: (context) => SongScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('MusicVerse'),
          ],
        ),
      ),
      drawer: MyDrawer(),
      body: Consumer<PlaylistProvider>(builder: (context, value, child) {
        //get the playlist
        value.loadSongs();
        var playlist = value.playlist;
        // return the list view UI
        return ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              final Song song = playlist[index];
              return Padding(
                padding: const EdgeInsets.all(10),
                child: ListTile(
                  tileColor: Colors.grey.shade400,
                  title: Text(song.songName),
                  subtitle: Text(song.artistName),
                  leading: Image.asset(song.albumArtImagePath),
                  onTap: () => gotoSong(index),
                ),
              );
            });
        // return FutureBuilder<List<SongModel>>(
        //   future: _audioQuery.querySongs(
        //     sortType: null,
        //     uriType: UriType.EXTERNAL,
        //     orderType: OrderType.ASC_OR_SMALLER,
        //     ignoreCase: true,
        //   ),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //
        //     if (snapshot.hasError) {
        //       return Center(
        //         child: Text('Error: ${snapshot.error}'),
        //       );
        //     }
        //
        //     final List<SongModel>? songs = snapshot.data;
        //
        //     if (songs == null || songs.isEmpty) {
        //       return const Center(
        //         child: Text('No Songs Found'),
        //       );
        //     }
        //     value.loadSongs();
        //     return ListView.builder(
        //       itemCount: songs.length,
        //       itemBuilder: (context, index) {
        //         final song = songs[index];
        //         return ListTile(
        //           leading: const Icon(Icons.music_note),
        //           title: Text(song.displayNameWOExt),
        //           trailing: const Icon(Icons.more_horiz),
        //           onTap: () => gotoSong(song.uri!),
        //         );
        //       },
        //     );
        //   },
        // );

      }),
    );
  }
}
