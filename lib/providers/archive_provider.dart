import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_night/models/movie_list.dart';
import 'package:movie_night/models/movie_model.dart';


class FirestoreProvider extends ChangeNotifier {
  var _db = FirebaseFirestore.instance;
  MovieList movies = MovieList();
  MovieList votedMovies = MovieList();

  fetchMovies(User user) async {
    List<MovieModel> l = [];

    QuerySnapshot q = await _db
        .collection('Movies')
        .where('votes', arrayContains: user.uid)
        .get();
    q.docs.forEach((element) {
      l.add(MovieModel.fromFirestore(element));
    });
    movies = MovieList(movies: l);

    l.clear();
    q = await _db.collection('Movies').orderBy("noVotes", descending: true).get();
    q.docs.forEach((element) {
      l.add(MovieModel.fromFirestore(element));
      List<dynamic> _v = element['votes'];
      _db.collection('Movies').doc(element['id']).update({
        'noVotes' : _v.length
      });
    });
    
    votedMovies = MovieList(movies: l);
    notifyListeners();
  }
}
