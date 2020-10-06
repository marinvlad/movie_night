import 'package:cloud_firestore/cloud_firestore.dart';

class MovieModel{
  int id;
  double popularity;
  String title;
  String relaseDate;
  String image;
  String overview;

  MovieModel(
    {this.id,
    this.popularity,
    this.title,
    this.relaseDate,
    this.image,
    this.overview}
  );

  factory MovieModel.fromJson(Map<String, dynamic> json){
    return MovieModel(
      id : json["id"] ?? 1,
      popularity : json["popularity"] ?? 1.00,
      title : json["title"] ?? "",
      relaseDate : json["release_date"] ?? "",
      image: json["poster_path"] ?? "",
      overview: json["overview"] ?? ""
    );
  }

  factory MovieModel.fromFirestore(DocumentSnapshot doc){
    return MovieModel(
      id : int.parse(doc["id"])  ?? 1,
      popularity : doc["popularity"] ?? 1.00,
      title : doc["title"] ?? "",
      relaseDate : doc["releaseDate"] ?? "",
      image: doc["image"] ?? "",
      overview: ""
    );
  }

  
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
     data["popularity"] = this.popularity;
    data["title"] = this.title;
    data["release_date"] = this.relaseDate;
    data["poster_path"] = this.image;
    data["overview"] = this.overview;
    return data;
  }
}