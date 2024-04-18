import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:minimal_music_app/models/song.dart';
import 'dart:math';

class PlaylistProvider extends ChangeNotifier {
  final List<Song> _playlist = [
    //song
    Song(
        songName: "Like We Used To",
        artistName: "A Rocket to the Moon",
        albumArtImagePath: "assets/images/a_rocket_to_the_moon.jpg",
        audioPath: "music/A Rocket To The Moon-Like We Used To.wma",
    ),
    Song(
        songName: "It's Time",
        artistName: "Imagine Dragons",
        albumArtImagePath: "assets/images/imagine_dragons.jpg",
        audioPath: "music/Imagine Dragons-It's Time.mp3",
    ),
    Song(
        songName: "Benediction",
        artistName: "Luke Sital Singh",
        albumArtImagePath: "assets/images/luke_sital_singh.jpg",
        audioPath: "music/Luke Sital Singh-Benediction.mp3",
    )
  ];


  Random random = Random();
  //current song playing index
  int? _currentSongIndex;
  //G E T T E R S
  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  bool get isLoopOn => _isLoopOn;
  Duration get totalDuration => _totalDuration;
  Duration get currentDuration => _currentDuration;

  //A U D I O  P L A Y E R S
  final AudioPlayer _audioPlayer = AudioPlayer();

  // durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // constructor
  PlaylistProvider() {
    listenToDuration();
  }

  // initially not playing
  bool _isPlaying = false;

  // initially not shuffled
  bool _isLoopOn = false;

  // play the song
  void play() async {
    final String path = _playlist[currentSongIndex!].audioPath;
    await _audioPlayer.stop(); // stop the current song
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  // pause the song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  //pause or resume
  void pauseOrResume() {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  // seek to a specific point int a song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // shuffle the songs
  void shuffle() async {
    int randomIndex = random.nextInt(_playlist.length);
    while(randomIndex == _currentSongIndex) {
      int randomIndex = random.nextInt(_playlist.length);
    }

    _currentSongIndex = randomIndex;
    final String path = _playlist[currentSongIndex!].audioPath;
    await _audioPlayer.stop(); // stop the current song
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  // loop a particular song
  void toggleLoop() async {
    if(!_isLoopOn) {
      // loop the song
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
      _isLoopOn = true;
    } else {
      // turn off the looping
      _audioPlayer.setReleaseMode(ReleaseMode.release);
      _isLoopOn = false;

    }
    notifyListeners();
  }

  // make a song favourite
  void toggleFavourite() async {
    if(_playlist[currentSongIndex!].isFavourite == true) {
      _playlist[currentSongIndex!].isFavourite = false;
    } else {
      _playlist[currentSongIndex!].isFavourite = true;
    }
    notifyListeners();
  }

  // play next song
  void playNext() {
    if (currentSongIndex != null) {
      if (currentSongIndex! < _playlist.length - 1) {
        // go to the next song unless it's the last song
        currentSongIndex = currentSongIndex! + 1;
      } else {
        // loop back to the first song if it's the last song
        currentSongIndex = 0;
      }
    }
  }

  // play previous song
  void playPrevious() {
    //if more than 2 seconds in to the current song, start from the beginning
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      //go to previous song if less than 2 seconds into the current song
      if (_currentSongIndex! > 0) {
        currentSongIndex = currentSongIndex! - 1;
      } else {
        currentSongIndex = 0;
      }
    }
    notifyListeners();
  }

  // list the duration
  void listenToDuration() {
    // listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    // listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    // listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNext();
    });
  }

  // dispose audio player

  //S E T T E R S
  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      play();
    }
    notifyListeners();
  }
}
