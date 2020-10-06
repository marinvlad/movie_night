import 'package:movie_night/models/movie_model.dart';

class MovieList {
  List<MovieModel> movies;

  MovieList({this.movies});

  factory MovieList.fromJson(Map<String, dynamic> json) {
    var list = json["results"] as List;
    List<MovieModel> movieList =
        list.map((e) => MovieModel.fromJson(e)).toList();
    return MovieList(movies: movieList);
  }

  List<MovieModel> toJson() {
    List<MovieModel> data = new List<MovieModel>();
    if (this.movies != null) {
      data = this.movies;
    }
    return data;
  }

  bool containsMovie(int id) {
    bool exist = false;
    try {
      movies.forEach((movie) {
        if (movie.id == id)
          exist = true;
      });
    } on NoSuchMethodError catch (_) {
      print("Exception containsMovie");
    }
    return exist;
  }
}
