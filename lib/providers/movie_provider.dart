import 'dart:io';
import 'package:movie_night/models/movie_list.dart';
import 'package:http/http.dart' as http;
import 'package:movie_night/utils/commons.dart';

class MovieListProvider{
  MovieList movieList;
  var source = 0;

  Future<MovieList> fetchMovies() async {
    try {
      final response = await http.get(
          ("https://api.themoviedb.org/3/movie/top_rated?api_key=2a78a002c1bde17e04c1688c127b5537&language=en-US&page=1"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          });
      if (response.statusCode == 200) {
        var responseJson = Commons.returnResponse(response);
        movieList = MovieList.fromJson(responseJson);
        return MovieList.fromJson(responseJson);
      } else {
        return null;
      }
    } on SocketException {
      return null;
    }
  }
}
