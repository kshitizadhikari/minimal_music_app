class Song
{
  final String songName;
  final String artistName;
  final String albumArtImagePath;
  final String audioPath;
  bool isFavourite;

  Song({
    required this.songName,
    required this.artistName,
    required this.albumArtImagePath,
    required this.audioPath,
    this.isFavourite = false,
});
}