import 'package:movies_app_flutter/model/movie_details.dart';
import 'package:movies_app_flutter/model/movie_preview.dart';
import 'package:movies_app_flutter/model/user.dart';
import 'package:movies_app_flutter/secret/themoviedb_api.dart' as secret;
import 'package:movies_app_flutter/utils/constants.dart';
import 'package:movies_app_flutter/utils/file_manager.dart';
import 'package:movies_app_flutter/widgets/movie_card.dart';
import 'package:movies_app_flutter/model/reservation_details.dart';

import 'package:flutter/material.dart';
import 'networking.dart';

class MovieModel {
  Future _getData({required String url, String? token}) async {
    NetworkHelper networkHelper = NetworkHelper(Uri.parse(url));
    var data = await networkHelper.getData(token);
    return data;
  }

  Future _postReserveSeat(
      {required String url,
      required List<int> seatsReserved,
      required String movieID,
      String? userID,
      String? token}) async {
    NetworkHelper networkHelper = NetworkHelper(Uri.parse(url));
    var data = await networkHelper.postReserveSeat(
        seatsReserved, movieID, userID, token);
    return data;
  }

  Future _deleteReservations(
      {required String url, String? movieID, String? token}) async {
    NetworkHelper networkHelper = NetworkHelper(Uri.parse(url));
    var data = await networkHelper.deleteReservation(movieID, token);
    return data;
  }

  Future<List<Reservation>> getUserReservations(String? token) async {
    List<Reservation> temp = [];

    var data = await _getData(
        url: 'https://immense-beyond-51451.herokuapp.com/ticket/',
        token: token);
    for (var item in data["data"]) {
      temp.add(
        Reservation(
          id: item["_id"],
          seats: item["seat"].cast<int>(),
          movieDetails: item["movieId"] != null
              ? MoviePreview.fromJson(item["movieId"])
              : null,
          userDetails:
              item["userId"] != null ? User.fromJson2(item["userId"]) : null,
        ),
      );
    }
    return Future.value(temp);
  }

  Future<dynamic> deleteReservation(
      String? movieID, String? ticketID, String? token) async {
    var data = await _deleteReservations(
        url: 'https://immense-beyond-51451.herokuapp.com/ticket/$ticketID',
        movieID: movieID,
        token: token);
    return data;
  }

  Future _postAddMovie(
      {required String url,
      required String movieTitle,
      required String movieDate,
      required String movieImgUrl,
      required String movieOverview,
      required String movieStartdate,
      required String movieEnddate,
      required String screeningRoom,
      required String token}) async {
    NetworkHelper networkHelper = NetworkHelper(Uri.parse(url));
    var data = await networkHelper.postAddMovie(
        movieTitle,
        movieDate,
        movieImgUrl,
        movieOverview,
        movieStartdate,
        movieEnddate,
        screeningRoom,
        token);
    return data;
  }

  Future _putUpdateMovie({
    required String url,
    required String movieID,
    required String movieTitle,
    required String movieDate,
    required String movieImgUrl,
    required String movieOverview,
    required String movieStartdate,
    required String movieEnddate,
    required String screeningRoom,
    required String token,
  }) async {
    NetworkHelper networkHelper = NetworkHelper(Uri.parse(url));
    var data = await networkHelper.putUpdateMovie(
        movieID,
        movieTitle,
        movieDate,
        movieImgUrl,
        movieOverview,
        movieStartdate,
        movieEnddate,
        screeningRoom,
        token);
    return data;
  }

  Future<List<MovieCard>> getMovies({
    required Color themeColor,
  }) async {
    List<MovieCard> temp = [];

    var data = await _getData(
      // url: '$kThemoviedbURL/$mTypString?api_key=${secret.themoviedbApi}',
      url: 'https://immense-beyond-51451.herokuapp.com/movie/',
    );

    for (var item in data["data"]) {
      print(item["title"]);
      print(item["posterImage"]);
      temp.add(
        MovieCard(
          moviePreview: MoviePreview(
            year: item["date"].toString(),
            imageUrl: item["posterImage"],
            title: item["title"],
            id: item["_id"],
            startDate: item["startTime"],
            endDate: item["endTime"],
            seats: item["seats"].cast<bool>(),
            screeningRoom: item["screeningRoom"],
            overview: item["overview"],
          ),
          themeColor: themeColor,
        ),
      );
    }
    return Future.value(temp);
  }

  Future<String> reserveSeats(List<int> seatsReserved, String movieID,
      String? userID, String? token) async {
    var data = await _postReserveSeat(
        // url: '$kThemoviedbURL/$mTypString?api_key=${secret.themoviedbApi}',
        url: 'https://immense-beyond-51451.herokuapp.com/ticket/',
        seatsReserved: seatsReserved,
        movieID: movieID,
        userID: userID,
        token: token);
    return data;
  }

  Future<String> addMovie(
      String movieTitle,
      String movieDate,
      String movieImgUrl,
      String movieOverview,
      String movieStartdate,
      String movieEnddate,
      String screeningRoom,
      String token) async {
    var data = await _postAddMovie(
        url: 'https://immense-beyond-51451.herokuapp.com/movie/',
        movieTitle: movieTitle,
        movieDate: movieDate,
        movieImgUrl: movieImgUrl,
        movieOverview: movieOverview,
        movieStartdate: movieStartdate,
        movieEnddate: movieEnddate,
        screeningRoom: screeningRoom,
        token: token);

    return data;
  }

  Future<String> editMovie(
      String movieID,
      String movieTitle,
      String movieDate,
      String movieImgUrl,
      String movieOverview,
      String movieStartdate,
      String movieEnddate,
      String screeningRoom,
      String token) async {
    var data = await _putUpdateMovie(
        url: 'https://immense-beyond-51451.herokuapp.com/movie/$movieID',
        movieID: movieID,
        movieTitle: movieTitle,
        movieDate: movieDate,
        movieImgUrl: movieImgUrl,
        movieOverview: movieOverview,
        movieStartdate: movieStartdate,
        movieEnddate: movieEnddate,
        screeningRoom: screeningRoom,
        token: token);

    return data;
  }

  Future<List<MovieCard>> searchMovies({
    required String movieName,
    required Color themeColor,
  }) async {
    List<MovieCard> temp = [];

    var data = await _getData(
      url:
          '$kThemoviedbSearchURL/?api_key=${secret.themoviedbApi}&language=en-US&page=1&include_adult=false&query=$movieName',
    );

    for (var item in data["results"]) {
      try {
        temp.add(
          MovieCard(
            moviePreview: MoviePreview(
              year: (item["release_date"].toString().length > 4)
                  ? item["release_date"].toString().substring(0, 4)
                  : "",
              imageUrl: "https://image.tmdb.org/t/p/w500${item["poster_path"]}",
              title: item["title"],
              id: item["id"].toString(),
              overview: item["overview"],
              startDate: "",
              endDate: "endTime",
              seats: item["seats"].cast<bool>(),
              screeningRoom: item["screeningRoom"],
            ),
            themeColor: themeColor,
          ),
        );
      } catch (e, s) {
        print(s);
        print(item["release_date"]);
      }
    }
    return Future.value(temp);
  }

  Future<MovieDetails> getMovieDetails({required String movieID}) async {
    var data = await _getData(
      url: 'https://immense-beyond-51451.herokuapp.com/movie/$movieID',
    );

    List<String> temp = [];
    for (var item in data["genres"]) {
      temp.add(item["name"]);
    }

    return Future.value(
      MovieDetails(
        backgroundURL:
            "https://image.tmdb.org/t/p/w500${data["backdrop_path"]}",
        title: data["title"],
        year: (data["release_date"].toString().length > 4)
            ? data["release_date"].toString().substring(0, 4)
            : "",
        isFavorite: await isMovieInFavorites(movieID: data["id"].toString()),
        rating: data["vote_average"].toDouble(),
        genres: temp,
        overview: data["overview"],
      ),
    );
  }
}
