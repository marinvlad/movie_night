import 'package:flutter/material.dart';
import 'package:movie_night/models/movie_list.dart';
import 'package:movie_night/providers/archive_provider.dart';
import 'package:movie_night/providers/event_provider.dart';
import 'package:movie_night/providers/movie_provider.dart';
import 'package:movie_night/providers/source_provider.dart';
import 'package:movie_night/providers/user_provider.dart';
import 'package:movie_night/utils/commons.dart';
import 'package:movie_night/utils/error.dart';
import 'package:movie_night/view/list/archive_card.dart';
import 'package:movie_night/view/list/movie_card.dart';
import 'package:movie_night/view/screens/attend_screen.dart';
import 'package:provider/provider.dart';

class TopMovies extends StatefulWidget {
  @override
  _TopMoviesState createState() => _TopMoviesState();
}

class _TopMoviesState extends State<TopMovies> {
  MovieList movies;
  var source;
  @override
  void initState() {
    movies = Provider.of<MovieListProvider>(context, listen: false).movieList;
    Provider.of<FirestoreProvider>(context, listen: false)
        .fetchMovies(Provider.of<UserProvider>(context, listen: false).user);

    Provider.of<MovieEventProvider>(context, listen: false).getEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) {
            Provider.of<SourceProvider>(context, listen: false)
                .setSource(index);
          },
          currentIndex:
              Provider.of<SourceProvider>(context, listen: true).source,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.list,
                  color: Commons.backGroundColor,
                ),
                activeIcon: Icon(
                  Icons.circle,
                  color: Commons.backGroundColor,
                ),
                label: "New"),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.archive,
                color: Commons.backGroundColor,
              ),
              activeIcon: Icon(
                Icons.circle,
                color: Commons.backGroundColor,
              ),
              label: "Archive",
            )
          ],
        ),
        appBar: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            title: FutureBuilder<void>(
              future: Provider.of<MovieEventProvider>(context, listen: false)
                  .getEvent(),
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
                    return CircularProgressIndicator();
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Error(
                        errorMessage: "Error retrieving movies.",
                      );
                    } else {
                      var days = Provider.of<MovieEventProvider>(context, listen: false).getRemainingTime();
                      return days > 3 ?Text(days
                          .toString() + " days left"):
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>AttendScreen()));
                            },
                            child: Text("Voting session is over. Click to attend"),
                          )
                          ;
                    }
                }
                return CircularProgressIndicator();
              },
            ),
            backgroundColor: Commons.backGroundColor,
            actions: <Widget>[
              FlatButton(
                textColor: Colors.white,
                onPressed: () {
                  Commons.logout(context);
                },
                child: Text("Logout"),
                shape:
                    CircleBorder(side: BorderSide(color: Colors.transparent)),
              ),
            ]),
        backgroundColor: Color(0xFF333333),
        body: TopList(
            movieList:
                Provider.of<SourceProvider>(context, listen: true).source == 0
                    ? Provider.of<MovieListProvider>(context, listen: false)
                        .movieList
                    : Provider.of<FirestoreProvider>(context, listen: true)
                        .movies));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class TopList extends StatelessWidget {
  final MovieList movieList;
  const TopList({Key key, this.movieList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Commons.backGroundColor,
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.0,
                vertical: 0.5,
              ),
              child: InkWell(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) =>
                    //         ShowChuckyJoke(movieList.movies[index])));
                  },
                  child: Provider.of<SourceProvider>(context, listen: true)
                              .source ==
                          0
                      ? MovieCard(
                          key: UniqueKey,
                          movie: movieList.movies[index],
                        )
                      : ArchiveCard(
                          key: UniqueKey,
                          movie: movieList.movies[index],
                        )));
        },
        itemCount: movieList.movies.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
      ),
    );
  }
}
