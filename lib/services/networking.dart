import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper(this.url);
  final Uri url;

  Future<dynamic> getData(String? token) async {
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  Future<dynamic> deleteReservation(String? movieID, String? token) async {
    http.Response response = await http.delete(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "id": movieID,
        }));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  Future<dynamic> postReserveSeat(List<int> seatsReserved, String movieID,
      String? userID, String? token) async {
    http.Response response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "userId": userID,
          "movieId": movieID,
          "seat": seatsReserved,
        }));

    if (response.statusCode == 201) {
      print("yaaaaaaaaaaaaaaaaaaaay");
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  Future<dynamic> postAddMovie(
      String movieTitle,
      String movieDate,
      String movieImgUrl,
      String movieOverview,
      String movieStartdate,
      String movieEnddate,
      String screeningRoom) async {
    http.Response response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYxZDJmOTU3NzYzZGYwMTY3YzMxM2MyOSIsImlhdCI6MTY0MTIyMTkzMCwiZXhwIjoxNjQ4OTk3OTMwfQ.VqVnfbCoA6KKJLHc8CFoaj7bSQZvmhz4PTb6d7iYlCA',
        },
        body: jsonEncode(<String, dynamic>{
          "posterImage": movieImgUrl,
          "title": movieTitle,
          "date": movieDate,
          "startTime": movieStartdate,
          "endTime": movieEnddate,
          "screeningRoom": screeningRoom,
          "overview": movieOverview,
        }));

    if (response.statusCode == 200) {
      print("yaaaaaaaaaaaaaaaaaaaay");
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  Future<dynamic> putUpdateMovie(
      String movieID,
      String movieTitle,
      String movieDate,
      String movieImgUrl,
      String movieOverview,
      String movieStartdate,
      String movieEnddate,
      String screeningRoom) async {
    http.Response response = await http.patch(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYxZDJmOTU3NzYzZGYwMTY3YzMxM2MyOSIsImlhdCI6MTY0MTIyMTkzMCwiZXhwIjoxNjQ4OTk3OTMwfQ.VqVnfbCoA6KKJLHc8CFoaj7bSQZvmhz4PTb6d7iYlCA',
        },
        body: jsonEncode(<String, dynamic>{
          "id": movieID,
          "posterImage": movieImgUrl,
          "title": movieTitle,
          "date": movieDate,
          "startTime": movieStartdate,
          "endTime": movieEnddate,
          "screeningRoom": screeningRoom,
          "overview": movieOverview,
        }));

    if (response.statusCode == 200) {
      print("yaaaaaaaaaaaaaaaaaaaay");
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }
}
