import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../utils/constants.dart';
import 'package:provider/provider.dart';
import '../model/usermodel.dart';

import '../model/User.dart';

import 'package:provider/provider.dart';

userGetdata(BuildContext context) async {
  final user = Provider.of<MyModel>(context, listen: false);

  final response = await Dio().get(
    kBaseUrl + '/user/',
    options: Options(
        headers: {"authorization": "Bearer " + user.getToken().toString()},
        validateStatus: (_) {
          return true;
        },
        responseType: ResponseType.json),
  );

  User myUser = User.fromJson(response.data["data"]);

  user.setPerson(myUser);

  print(user.getPerson().email);
  print(user.getPerson().role);
  print(user.getToken().toString());

  return response;
}
