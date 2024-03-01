import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_generator/models/hobby.dart';

String getCurrentUserEmail() {
  // Assuming you're using Firebase Authentication
  final user = FirebaseAuth.instance.currentUser;
  return user?.email ?? '';
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Hobby>>((ref) {
  // Assume getCurrentUserEmail() fetches the current user's email
  String userEmail = getCurrentUserEmail();
  return FavoritesNotifier(userEmail);
});

class FavoritesNotifier extends StateNotifier<List<Hobby>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _userEmail;

  FavoritesNotifier(this._userEmail) : super([]) {
    _fetchBookmarks();
  }

  Future<void> _fetchBookmarks() async {
    try {
      // Fetch the bookmarks from Firestore for the current user
      var snapshot = await _firestore
          .collection("users")
          .doc(_userEmail)
          .collection("bookmarks")
          .get();
      var bookmarks =
          snapshot.docs.map((doc) => Hobby.fromMap(doc.data())).toList();
      state = bookmarks;
    } catch (e) {
      // Handle errors or set state to an empty list
      state = [];
      log("Error fetching bookmarks: $e");
    }
  }

 void addFavorite(Hobby hobby) async {
  if (!state.contains(hobby)) {
    state = [...state, hobby];
    // Convert the hobby to a Map.
    var hobbyMap = hobby.toMap();
    // Add the hobby to the "bookmarks" subcollection of the current user document.
    await _firestore.collection("users").doc(_userEmail).collection("bookmarks").doc(hobby.name).set(hobbyMap);
  }
}

 void removeFavorite(Hobby hobby) async {
  if (state.contains(hobby)) {
    state = state.where((element) => element.name != hobby.name).toList();
    // Remove the hobby from the "bookmarks" subcollection of the current user document.
    await _firestore.collection("users").doc(_userEmail).collection("bookmarks").doc(hobby.name).delete();
  }
}


  bool isFavorite(Hobby hobby) {
    return state.any((element) => element.name == hobby.name);
  }
}
