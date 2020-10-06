import 'package:flutter/material.dart';
import 'package:movie_night/models/movie_list.dart';
import 'package:movie_night/providers/event_provider.dart';
import 'package:movie_night/providers/movie_provider.dart';
import 'package:movie_night/utils/commons.dart';
import 'package:movie_night/utils/error.dart';
import 'package:movie_night/view/list/movie_list.dart';
import 'package:provider/provider.dart';


class InitializeProviderDataScreen extends StatefulWidget {
  InitializeProvidersState createState() => InitializeProvidersState();
}

class InitializeProvidersState extends State<InitializeProviderDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _loadMovieList());
  }

  Widget _loadMovieList() {
    return FutureBuilder<MovieList>(
      future: Provider.of<MovieListProvider>(context, listen: false)
          .fetchMovies(),
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
            return Commons.mnLoading("Fetching movies...");
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Error(
                errorMessage: "Error retrieving movies.",
              );
            } else {
              return TopMovies();
            }
        }
        return Commons.mnLoading("Fetching movies...");
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}