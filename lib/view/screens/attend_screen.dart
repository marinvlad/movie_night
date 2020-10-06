import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_night/models/movie_list.dart';
import 'package:movie_night/providers/archive_provider.dart';
import 'package:movie_night/providers/event_provider.dart';
import 'package:movie_night/providers/user_provider.dart';
import 'package:movie_night/utils/commons.dart';
import 'package:provider/provider.dart';

class AttendScreen extends StatefulWidget {
  @override
  _AttendScreenState createState() => _AttendScreenState();
}

class _AttendScreenState extends State<AttendScreen> {
  MovieList movieList;

  @override
  void initState() {
    movieList =
        Provider.of<FirestoreProvider>(context, listen: false).votedMovies;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: Text(movieList.movies[0].title),
          backgroundColor: Commons.backGroundColor,
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () {
                _attend();
                showDialog(context: context, builder: (contetx)=>AlertDialog(
                  title: Text("Alert"),
                  content: Text("Attendance confirmed"),
                ));
              },
              child: Text("Attend"),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
            FlatButton(
              textColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Back"),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ]),
      body: Column(
        children: [
          Image.network(Commons.imageBaseURL + movieList.movies[0].image),
          Text("Date to play: " + Provider.of<MovieEventProvider>(context, listen: false).targetDate.toString())
        ],
      ),
    );
  }
  _attend(){
    
    var votes = [];
    votes.add(Provider.of<UserProvider>(context, listen: false).user.uid);
    FirebaseFirestore.instance.collection('Movies').doc(movieList.movies[0].id.toString()).update({
      'attends' : FieldValue.arrayUnion(votes),
      'noAttend' : FieldValue.increment(1)
    });

    Provider.of<MovieEventProvider>(context, listen: false).subscirbeToAttendList();
  }
}
