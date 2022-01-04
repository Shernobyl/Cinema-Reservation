import 'package:movies_app_flutter/model/movie_preview.dart';
import 'package:movies_app_flutter/model/user.dart';

class Reservation {
  final String id;
  final List<int> seats;
  MoviePreview? movieDetails;
  User? userDetails;

  Reservation({
    required this.id,
    required this.seats,
    this.movieDetails,
    this.userDetails,
  });

  Reservation.fromJson(Map<String, dynamic> json)
      : this(
            id: json["_id"],
            seats: json["seat"],
            movieDetails: json["movieId"],
            userDetails: json["userID"]);
}
