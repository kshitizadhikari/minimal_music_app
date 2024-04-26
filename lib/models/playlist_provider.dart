import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:minimal_music_app/models/song.dart';
import 'package:minimal_music_app/services/firestore.dart';
import 'dart:math';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistProvider extends ChangeNotifier {
  final audioQuery = OnAudioQuery();
  final FireStoreService fireStoreService = FireStoreService();
  late List<Song> _playlist = [];

  Future<void> loadSongs() async {
    final _audioQuery = OnAudioQuery();
    final List<SongModel> songModels = await _audioQuery.querySongs();
    // Clear the existing songs list
    _playlist.clear();

    // Iterate over each SongModel and create a new Song object
    songModels.forEach((songModel) {
      final song = Song(
        id: songModel.id,
        songName: songModel.title ?? "",
        artistName: songModel.artist ?? "",
        albumArtImagePath:
            "assets/images/music5.gif", // Set album art path accordingly
        audioPath: songModel.data ?? "", // choose the correct audio path
        isFavourite: false, // Set default value for isFavourite
      );

      // Add the song to the songs list
      _playlist.add(song);
    });
  }

  Random random = Random();
  //current song playing index
  int? _currentSongIndex;

  bool? _isFav;
  //G E T T E R S
  List<Song> get playlist => _playlist;

  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  bool get isLoopOn => _isLoopOn;
  bool? get isFav => _isFav;
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
    await _audioPlayer.play(DeviceFileSource(path));
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

  void shuffle() async {
    // Generate a random index different from the current song index
    int randomIndex;
    do {
      randomIndex = random.nextInt(_playlist.length);
    } while (randomIndex == _currentSongIndex);

    _currentSongIndex = randomIndex;
    String path = _playlist[randomIndex].audioPath;

    // Play the audio of the randomly selected song
    await _audioPlayer.stop(); // Stop the current song
    await _audioPlayer.play(DeviceFileSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  // loop a particular song
  void toggleLoop() async {
    if (!_isLoopOn) {
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
    if (_playlist[currentSongIndex!].isFavourite == true) {
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

  //search for a particular song
  void searchSong(String song) {
    // Convert the search query to lowercase for case-insensitive search
    final query = song.toLowerCase();

    // Filter songs that contain the search query in either song name or artist name
    final searchResult = _playlist
        .where((song) =>
            song.songName.toLowerCase().contains(query) ||
            song.artistName.toLowerCase().contains(query))
        .toList();

    // Notify listeners with the search result
    _playlist = searchResult;
    notifyListeners();
  }

  //check if a song is favourite or not
  Future<bool> checkFavourite(int songId, String userId) async {
    bool fav = await fireStoreService.checkIfFavourite(songId, userId);
    return fav;
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

  set isFav(value) {
    if (_isFav == false) {
      _isFav = true;
    } else {
      _isFav = false;
    }
  }
}
