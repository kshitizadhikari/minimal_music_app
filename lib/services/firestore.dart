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

  //create favourite

  //read favourite
  Stream<QuerySnapshot> getFavouritesStream() {
    final favouriteStream = favourites.orderBy('timestamp', descending: true).snapshots();
    return favouriteStream;
  }
  //update favourite

  //delete favourite

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
