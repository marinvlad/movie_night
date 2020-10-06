import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_night/models/movie_model.dart';
import 'package:movie_night/providers/archive_provider.dart';
import 'package:movie_night/providers/event_provider.dart';
import 'package:movie_night/providers/user_provider.dart';
import 'package:movie_night/utils/commons.dart';
import 'package:movie_night/view/screens/movie_details.dart';
import 'package:provider/provider.dart';

class MovieCard extends StatelessWidget {
  @required
  final MovieModel movie;
  MovieCard({this.movie, key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      height: 300,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> MovieDetails(movie: movie, key: UniqueKey,)));
                },
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Image.network(Commons.imageBaseURL + movie.image)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        _voteMovie(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 50),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Commons.backGroundColor,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text("Vote",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.bold,
                            fontSize: 25
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Text(
            movie.title,
            style: TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
  _voteMovie(BuildContext context){
    FirebaseFirestore.instance.collection('Movies').doc(movie.id.toString()).set({
      'id' : movie.id.toString(),
      'popularity' : movie.popularity, 
      'title' : movie.title,
      'releaseDate' : movie.relaseDate,
      'image' : movie.image,
      'noAttend' : 0,
      'votes' : []
    });
    var votes = [];
    votes.add(Provider.of<UserProvider>(context, listen: false).user.uid);
    FirebaseFirestore.instance.collection('Movies').doc(movie.id.toString()).update({
      'votes' : FieldValue.arrayUnion(votes)
    });

    Provider.of<FirestoreProvider>(context,listen: false).fetchMovies(Provider.of<UserProvider>(context, listen: false).user);
    Provider.of<MovieEventProvider>(context, listen: false).subscirbeToVoteList();
  }
}
