import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimal_music_app/components/neu_box.dart';
import 'package:minimal_music_app/models/playlist_provider.dart';
import 'package:provider/provider.dart';

class SongScreen extends StatelessWidget {
  const SongScreen({super.key});

  //convert duration into min:sec
  String formatTime(Duration duration) {
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        //get the playlist
        final playlist = value.playlist;

        //get the current song
        final currentSong = playlist[value.currentSongIndex ?? 0];

        //return the Scaffold UI
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  //appbar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //back button
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios_new_outlined)),

                      //title
                      Text('S O N G  P A G E'),

                      //menu button
                      IconButton(onPressed: () {}, icon:const Icon(Icons.menu)),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  //album artwork
                  NeuBox(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(currentSong.albumArtImagePath),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //song and artist name
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentSong.songName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  Text(currentSong.artistName),
                                ],
                              ),
                            ),
                            IconButton(onPressed: () {
                              value.toggleFavourite();
                            }, icon: Icon(currentSong.isFavourite ? Icons.favorite : Icons.favorite_outline_rounded))


                            //heart icon
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  //song duration progress
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //start time
                            Text(formatTime(value.currentDuration)),

                            //shuffle icon
                            IconButton(
                                onPressed: () {
                                  value.shuffle();
                                },
                                icon: const Icon(Icons.shuffle)),

                            //repeat icon
                            IconButton(
                              onPressed: () {
                                value.toggleLoop();
                              },
                              icon: Icon(
                                Icons.repeat,
                                color: value.isLoopOn ? Colors.green : null,
                              ),
                            ),

                            //end time
                            Text(formatTime(value.totalDuration)),
                          ],
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 5),
                          ),
                          child: Slider(
                            value: value.currentDuration.inSeconds.toDouble(),
                            min: 0,
                            max: value.totalDuration.inSeconds.toDouble(),
                            activeColor: Colors.green,
                            onChanged: (double double) {
                              //when the user is sliding the slider
                            },
                            onChangeEnd: (double double) {
                              //sliding has finished.. go to that specific position of the song
                              value.seek(Duration(seconds: double.toInt()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  //playback controls
                  Row(
                    children: [
                      //skip previous
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playPrevious,
                          child: NeuBox(
                            child: Icon(Icons.skip_previous),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),

                      //play pause
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: value.pauseOrResume,
                          child: NeuBox(
                            child: Icon(value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),

                      //skip forward
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playNext,
                          child: NeuBox(
                            child: Icon(Icons.skip_next),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
