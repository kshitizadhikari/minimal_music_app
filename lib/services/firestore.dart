import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  //get the collection of favourites
  final CollectionReference favourites =
      FirebaseFirestore.instance.collection('favourites');

  Future<void> addToFavourites(int songId, String userId) {
    return favourites.add(
      {'song_id': songId, 'user_id': userId, 'timestamp': Timestamp.now()},
    );
  }

  Future<void> toggleFavourite(int songId, String userId) async {
    //check if the song already exists in favourite ..if it doesn't call addToFavourites else call deleteFromFavourites
    final fav = await checkIfFavourite(songId, userId);
    if(fav == true) {
      deleteFromFavourites(songId, userId);
    } else {
      addToFavourites(songId, userId);
    }
  }

  //delete favourite
  Future<void> deleteFromFavourites(int songId, String userId) {
    return favourites
        .where('song_id', isEqualTo: songId)
        .where('user_id', isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }
  //check favourite
  Future<bool> checkIfFavourite(int songId, String userId) async {
    // Query the favourites collection to check if the document exists
    QuerySnapshot snapshot = await favourites
        .where('song_id', isEqualTo: songId)
        .where('user_id', isEqualTo: userId)
        .get();

    // If any documents match the query, the song is favorited by the user
    return snapshot.docs.isNotEmpty;
  }
}
