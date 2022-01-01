import 'package:flutter/cupertino.dart';
import 'User.dart';

class MyModel with ChangeNotifier {
  bool isAuth = false;
  String? _token;
  String? _rememberToken;
  String? _id;
  late User _person;

  void setID(String id) {
    _id = id;
  }

  void setPerson(User user)
  {
    _person=user;
  }

  User getPerson()
  {
    return _person;
  }

  String? getID() {
    return _id;
  }

  void setToken(String? token) {
    // print(token);
    _token = token;
  }

  void setRememberToken(String remember)
  {
    _rememberToken=remember;
  }

  String? getRememberToken()
  {
    return _rememberToken;
  }
  String? getToken() {
    return _token;
  }

}