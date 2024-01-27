import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteItems {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
static Future<void> addToFavoritesForUser(String userId, String title) async {
  try {
    CollectionReference favorites = _firestore.collection('users').doc(userId).collection('favorites');

    await favorites.doc(title).set({
      'title': title,
      'userId': userId,
    });
  } catch (e) {
    print('Error adding to favorites: $e');
  }
}

static Future<void> removeFromFavoritesForUser(String userId, String title) async {
  try {
    CollectionReference favorites = _firestore.collection('users').doc(userId).collection('favorites');

    await favorites.doc(title).delete();
  } catch (e) {
    print('Error removing from favorites: $e');
  }
}


  static Future<bool> isFavoriteForUser(String userId, String title) async {

    CollectionReference favorites = _firestore.collection('users').doc(userId).collection('favorites');

    DocumentSnapshot docSnapshot = await favorites.doc(title).get();
    
    return docSnapshot.exists;
  }
}
