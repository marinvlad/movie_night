import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_night/models/movie_model.dart';
import 'package:movie_night/providers/archive_provider.dart';
import 'package:movie_night/utils/commons.dart';
import 'package:movie_night/utils/error.dart';
import 'package:provider/provider.dart';

class MovieDetails extends StatelessWidget {
  final MovieModel movie;
  MovieDetails({this.movie, key});

  final String imageBaseURL = "https://image.tmdb.org/t/p/w500/";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: Text('Top Movies',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          backgroundColor: Commons.backGroundColor,
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () {
                Commons.logout(context);
              },
              child: Text("Logout"),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(child: Image.network(imageBaseURL + movie.image)),
          ),
          Row(
            children: [Text("Title "), Text(movie.title)],
          ),
          Row(
            children: [Text("Release date "), Text(movie.relaseDate)],
          ),
          Row(
            children: [
              Text("Number of votes "),
               checkExist(context, movie.id)==true ? FutureBuilder<DocumentSnapshot>(
                 key: key,
                future: FirebaseFirestore.instance
                    .collection('Movies')
                    .doc(movie.id.toString())
                    .get(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text(
                        'Fetch opportunity data',
                        textAlign: TextAlign.center,
                      );
                    case ConnectionState.active:
                      return Text('');
                    case ConnectionState.waiting:
                      return Commons.mnLoading("Fetching votes...");
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Error(
                          errorMessage: "Error retrieving movie.",
                        );
                      } else {
                        List<dynamic> votes = snapshot.data['votes'];
                        return Text(votes.length.toString());
                      }
                  }
                  return Text("0");
                },
              ) : Text("0")
            ],
          ),
          Text(movie.overview)
        ],
      ),
    );
  }
bool checkExist(BuildContext context, int movieID){
  return Provider.of<FirestoreProvider>(context, listen: false).votedMovies.containsMovie(movieID);
  }
}
