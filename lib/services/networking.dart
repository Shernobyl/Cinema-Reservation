import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper(this.url);
  final Uri url;

  Future<dynamic> getData() async {
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  Future<dynamic> postReserveSeat(
      List<int> seatsReserved, String movieID) async {
    http.Response response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYxY2UyYjZiYTYwNTc0NGU4ODdkNmI1YiIsImlhdCI6MTY0MDkwMTQ4NCwiZXhwIjoxNjQ4Njc3NDg0fQ.4yWnV7Y1lciSXs9hIBvYYFnV3KX0oq9bTrVtPNsQ5Mw',
        },
        body: jsonEncode(<String, dynamic>{
          "userId": "61c6f53f6268cc489cefb199",
          "movieId": movieID,
          "seat": seatsReserved,
        }));

    if (response.statusCode == 200) {
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
      int screeningRoom) async {
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
}
