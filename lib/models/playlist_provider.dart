import 'package:flutter/material.dart';
import 'package:minimal_music_app/models/song.dart';

class PlaylistProvider extends ChangeNotifier
{
  final List<Song> _playlist = [
    //song
    Song(songName: "Like We Used To", artistName: "A Rocket to the Moon", albumArtImagePath: "assets/images/a_rocket_to_the_moon.jpg", audioPath: "assets/music/A Rocket To The Moon-Like We Used To.wma"),
    Song(songName: "It's Time", artistName: "Imagine Dragons", albumArtImagePath: "assets/images/imagine_dragons.jpg", audioPath: "assets/music/Imagine Dragons-It's Time.mp3"),
    Song(songName: "Benediction", artistName: "Luke Sital Singh", albumArtImagePath: "assets/images/luke_sital_singh.jpg", audioPath: "assets/music/Luke Sital Singh-Benediction.mp3")
  ];

  //current song playing index
  int? _currentSongIndex;
  //G E T T E R S
  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;


  //S E T T E R S
  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    notifyListeners();
  }
}