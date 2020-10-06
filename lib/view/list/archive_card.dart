import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_night/models/movie_model.dart';
import 'package:movie_night/utils/commons.dart';
import 'package:movie_night/utils/error.dart';

class ArchiveCard extends StatelessWidget {
  @required
  final MovieModel movie;
  ArchiveCard({this.movie, key});

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
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Image.network(Commons.imageBaseURL + movie.image)),
              FutureBuilder<DocumentSnapshot>(
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
                      return Commons.mnLoading("Fetching data...");
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Error(
                          errorMessage: "Error retrieving movie.",
                        );
                      } else {
                        return Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("No. Attendees", style: TextStyle(fontWeight: FontWeight.bold),),
                                Text(snapshot.data['noVotes'].toString()),
                                Text("No. Votes",style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(snapshot.data['noAttend'].toString())
                              ],
                            ),
                          ),
                        );
                      }
                  }
                  return Text("0");
                },
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
}
