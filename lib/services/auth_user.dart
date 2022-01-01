import 'dart:convert';
import 'package:dio/dio.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;


userLogin(String email, String password, bool? rememberMe) async {
  final response = await Dio().post(kBaseUrl + '/user/login',
      options: Options(
          validateStatus: (_) {
            return true;
          },
          responseType: ResponseType.json),
      data: jsonEncode({
        "email": email,
        "password": password,
      }));
  print(response);
  return response;
}



signUp (String? userName,String? email,String? firstName, String password, String lastName, String role) async
{
  var response = await Dio().post(kBaseUrl + '/user/signup',
      options: Options(
          validateStatus: (_) {
            return true;
          },
          responseType: ResponseType.json),
      data: jsonEncode({
        "userName":userName,
        "email": email,
        "password": password,
        "firstName": firstName,
        "lastName": lastName,
        "role":role,
      }));
  // print(response);
  return response;
}