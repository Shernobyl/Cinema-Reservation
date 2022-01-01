import 'package:flutter/material.dart';
import 'package:movies_app_flutter/widgets/beauty_textfield.dart';
import 'package:movies_app_flutter/utils/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:movies_app_flutter/utils/file_manager.dart' as file;
import 'signup_screen.dart';
import 'package:email_validator/email_validator.dart';
import '../screens/home_screen.dart';

import '../model/usermodel.dart';

import 'package:provider/provider.dart';

import '../services/auth_user.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Color? themeColor;

  EnumError errorEmail = EnumError.hide;
  EnumError errorPassword = EnumError.hide;

  final email = TextEditingController();
  final password = TextEditingController();

  // ScrollController? _scrollController;
  // bool showBackToTopButton = false;
  // int? activeInnerPageIndex;

  String email_validation = "";
  String password_validation = "";
  String passwordErrorText = "";
  String emailErrorText = "";

  bool isPassword(String password) {
    if (password.length >= 12) {
      var str = password.trim();
      if (identical(password, str))
        return true;
      else
        return false;
    } else
      return false;
  }

  /// Checks the String email, and performs the suitable action accordingly
  void emailChecking() {
    if (email_validation?.isNotEmpty ?? false) {
      final bool isValid = EmailValidator.validate(email_validation);
      if (isValid == true) {
        setState(() {
          errorEmail = EnumError.hide;
        });
      } else if (isValid == false) {
        setState(() {
          errorEmail = EnumError.show;
          emailErrorText = "Invalid email";
        });
      }
    } else if (email_validation?.isEmpty ?? true) {
      setState(
        () {
          errorEmail = EnumError.show;
          emailErrorText = "Required";
        },
      );
    }
  }

  void passwordChecking() {
    if (password_validation?.isNotEmpty ?? false) {
      setState(() {
        if (isPassword(password_validation))
          errorPassword = EnumError.hide;
        else {
          errorPassword = EnumError.show;
          passwordErrorText =
              "Please use at least: 12 characters and no leading spaces";
        }
      });
    } else if (password_validation?.isEmpty ?? true) {
      setState(
        () {
          errorPassword = EnumError.show;
          passwordErrorText = "Required";
        },
      );
    }
  }

  login(String token) {
   
    final user = Provider.of<MyModel>(context, listen: false);
    user.authUser();
    user.setToken(token);

    

     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return HomeScreen(
        key: kHomeScreenKey,
      );
    }));
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cinema Reservation",
          style: kAppBarTitleTextStyle,
        ),
      ),
      body: Center(
          child: Column(children: [
        SizedBox(
          height: 2.h,
        ),
        Center(
          child: Text(
            "Welcome",
            style: kSmallAppBarTitleTextStyle,
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        TextField(
          onChanged: (valueFirstName) {
            email_validation = valueFirstName;
          },
          decoration: InputDecoration(
            errorText: (errorEmail == EnumError.show) ? "Required" : null,
            labelText: 'Email',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 0.8,
                color: Color(0xFF212121),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        TextField(
          onChanged: (valueFirstName) {
            password_validation = valueFirstName;
          },
          decoration: InputDecoration(
            errorText: (errorPassword == EnumError.show) ? "Required" : null,
            labelText: 'Password',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 0.8,
                color: Color(0xFF212121),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () async {
                  emailChecking();
                  passwordChecking();
                  if (errorEmail == EnumError.hide &&
                      errorPassword == EnumError.hide) {
                    var res =
                        await userLogin(email_validation, password_validation);

                    if (res.data["status"] == "success") {
                      login(res.data['token']);
                    }
                  }
                },
                child: Text("Login")),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Not a member?'),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return signup();
                    },
                  ),
                );
              },
              child: Text(' Sign up here'),
            ),
          ],
        ),
      ])),
    );
  }
}
