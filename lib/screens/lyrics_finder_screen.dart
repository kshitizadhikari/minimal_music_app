import 'package:flutter/material.dart';
import 'package:minimal_music_app/components/my_button.dart';
import 'package:minimal_music_app/components/my_textfield.dart';
import 'package:minimal_music_app/components/neu_box.dart';
import 'package:minimal_music_app/models/playlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LyricsFinder extends StatefulWidget {
  const LyricsFinder({
    super.key,
  });
  @override
  State<LyricsFinder> createState() => _LyricsFinderScreenState();
}

class _LyricsFinderScreenState extends State<LyricsFinder> {
  late final PlaylistProvider playlistProvider;

  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _songController = TextEditingController();
  String artist = '';
  String song = '';

  @override
  void initState() {
    super.initState();
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  Future<dynamic> getSongLyrics() async {
    var url = Uri.https('api.lyrics.ovh', '/v1/$artist/$song');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return Future.error('Song Not Found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                // app bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_outlined),
                    ),
                    const Text(
                      'Lyrics Finder',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        letterSpacing: 5,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0, // shadow blur
                            color: Colors.orange, // shadow color
                            offset: Offset(
                                4.0, 4.0), // how much shadow will be shown
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

                //search boxes
                Column(
                  children: [
                    // enter song name
                    MyTextField(
                      controller: _artistController,
                      hintText: 'Enter Artist Name',
                      obscureText: false,
                      labelText: 'Artist',
                      suffixIcon: IconButton(
                        onPressed: () {
                          _artistController.clear();
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                    const SizedBox(height: 25),
                    //enter artist name
                    MyTextField(
                      controller: _songController,
                      hintText: 'Enter Song Name',
                      obscureText: false,
                      labelText: 'Song',
                        suffixIcon: IconButton(
                          onPressed: () {
                            _songController.clear();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                    ),
                    const SizedBox(height: 25),

                    NeuBox(
                      child: MyButton(
                        onTap: () {
                          setState(() {
                            artist = _artistController.text;
                            song = _songController.text;
                          });
                        },
                        text: 'Find Lyrics',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                //show lyrics
                //show lyrics
                if (artist.isNotEmpty && song.isNotEmpty)
                  FutureBuilder(
                    future: getSongLyrics(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}', style: TextStyle(
                              fontSize: 24
                            ),),
                          );
                        }
                        var data = snapshot.data;
                        if (data != null) {
                          return SingleChildScrollView(
                            child: Text(data['lyrics']),
                          );
                        } else {
                          return const Center(
                            child: Text('Lyrics not found.'),
                          );
                        }
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return const Center(
                          child: Text('Unexpected error occurred.'),
                        );
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
