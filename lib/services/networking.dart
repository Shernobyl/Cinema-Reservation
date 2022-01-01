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

  Future<dynamic> postReserveSeat(List<int> seatsReserved) async {
    http.Response response = await http.post(url,
        body: jsonEncode(<String, dynamic>{
          "id": "61c6f53f6268cc489cefb18e",
          "userId": "61c6f53f6268cc489cefb199",
          "movieId": "61c6f53f626111489cefb18e",
          'seats': seatsReserved,
        }));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }
}
