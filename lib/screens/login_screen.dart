import 'package:flutter/material.dart';
import 'package:movies_app_flutter/utils/constants.dart';
import 'package:sizer/sizer.dart';
import 'signup_screen.dart';
import 'package:email_validator/email_validator.dart';
import '../screens/home_screen.dart';

import '../services/user_viewmodel.dart';

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

  String email = "";
  String password = "";
  String passwordErrorText = "";
  String emailErrorText = "";
  bool hiddenPassword = true;

  void toggleHiddenPassword() {
    setState(() {
      hiddenPassword = !hiddenPassword;
    });
  }

  /// Checks the String password is not empty
  void passwordChecking() {
    if (password?.isEmpty ?? true) {
      setState(
        () {
          errorPassword = EnumError.show;
          passwordErrorText = "Required";
        },
      );
    }
  }

  /// Checks the String email is not empty
  void emailChecking() {
    if (email?.isEmpty ?? true) {
      setState(
        () {
          errorEmail = EnumError.show;
          emailErrorText = "Required";
        },
      );
    }
  }

  login(String token) async {
    final user = Provider.of<MyModel>(context, listen: false);
    user.authUser();
    user.setToken(token);
    setState(() {
      userGetdata(context);
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        // Here you can write your code for open new view
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return HomeScreen(
            key: kHomeScreenKey,
          );
        }));
      });
    });
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
        Container(
          width: 550,
          child: TextField(
            onChanged: (valueEmail) {
              email = valueEmail;
            },
            decoration: InputDecoration(
              errorText: (errorEmail == EnumError.show) ? emailErrorText : null,
              labelText: 'Email or User name',
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
        ),
        SizedBox(
          height: 2.h,
        ),
        Container(
          width: 550,
          child: TextField(
            obscureText: hiddenPassword,
            onChanged: (valuePassword) {
              password = valuePassword;
            },
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  toggleHiddenPassword();
                },
                icon: (hiddenPassword)
                    ? Icon(
                        Icons.remove_red_eye_outlined,
                      )
                    : Icon(Icons.visibility_off_outlined),
              ),
              errorText:
                  (errorPassword == EnumError.show) ? passwordErrorText : null,
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
        ),
        SizedBox(
          height: 2.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () async {
                  var res = await userLogin(email, password);

                  if (res.data["status"] == "success") {
                    login(res.data['token']);
                  } else {
                    setState(() {
                      emailErrorText = "The email may be incorrect";
                      passwordErrorText = "The password may be incorrect";
                      errorEmail = EnumError.show;
                      errorPassword = EnumError.show;
                    });
                  }
                  emailChecking();
                  passwordChecking();
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
            Text(' or'),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return HomeScreen();
                    },
                  ),
                );
              },
              child: Text(' Sign in as a guest'),
            ),
          ],
        ),
      ])),
    );
  }
}
