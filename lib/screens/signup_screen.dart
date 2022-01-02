import 'package:flutter/material.dart';
import 'package:movies_app_flutter/widgets/beauty_textfield.dart';
import 'package:movies_app_flutter/utils/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:movies_app_flutter/utils/file_manager.dart' as file;
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import '../services/auth_user.dart';

enum EnumEmail { valid, invalid }
enum EnumError { show, hide }

class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {
  Color? themeColor;
  ScrollController? _scrollController;
  bool showBackToTopButton = false;
  int? activeInnerPageIndex;

  bool isChecked = false;

  final email = TextEditingController();
  final password = TextEditingController();
  final fname = TextEditingController();
  final Lname = TextEditingController();
  final username = TextEditingController();

  EnumError errorEmail = EnumError.hide;
  EnumError errorPassword = EnumError.hide;
  EnumError errorFirstName = EnumError.hide;
  EnumError errorLastName = EnumError.hide;
  EnumError errorUserName = EnumError.hide;
  bool _hiddenText = true;

  String email_validation = "";
  String password_validation = "";
  String firstName = "";
  String lastName = "";
  String passwordErrorText = "";
  String emailErrorText = "";
  String userName = "";
  String role = "customer";

  bool checkBoxValue = false;
  bool checkBoxRed = false;

  @override
  void initState() {
    super.initState();
    () async {
      themeColor = Colors.black;
      print(themeColor);
      _scrollController = ScrollController()
        ..addListener(() {
          setState(() {
            showBackToTopButton = (_scrollController!.offset >= 200);
          });
        });
      activeInnerPageIndex = 0;
    }();
  }

  @override
  void dispose() {
    if (_scrollController != null) _scrollController!.dispose();
    super.dispose();
  }

  void checkBoxChecker() {
    if (checkBoxValue == false) {
      checkBoxRed = true;
    } else
      checkBoxRed = false;
  }

  /// Preview the hidden text
  void toggleHiddenText() {
    setState(() {
      _hiddenText = !_hiddenText;
    });
  }

  /// This function checks if the input password is valid (the length >= 12)
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

  /// Checks if the first name text box empty
  void firstNameChecking() {
    if (firstName?.isNotEmpty ?? false) {
      if (firstName.contains(" ")) {
        setState(
          () {
            errorFirstName = EnumError.show;
          },
        );
      } else {
        setState(() {
          errorFirstName = EnumError.hide;
        });
      }
    } else if (firstName?.isEmpty ?? true) {
      setState(
        () {
          errorFirstName = EnumError.show;
        },
      );
    }
  }

  void UserNameChecking() {
    if (userName?.isNotEmpty ?? false) {
      if (userName.contains(" ")) {
        setState(
          () {
            errorUserName = EnumError.show;
          },
        );
      } else {
        setState(() {
          errorUserName = EnumError.hide;
        });
      }
    } else if (userName?.isEmpty ?? true) {
      setState(
        () {
          errorUserName = EnumError.show;
        },
      );
    }
  }

  /// Checks if the last name text box empty
  void lastNameChecking() {
    if (lastName?.isNotEmpty ?? false) {
      if (lastName.contains(" ")) {
        setState(
          () {
            errorLastName = EnumError.show;
          },
        );
      } else {
        setState(() {
          errorLastName = EnumError.hide;
        });
      }
    } else if (lastName?.isEmpty ?? true) {
      setState(
        () {
          errorLastName = EnumError.show;
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

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

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
          height: 1.h,
        ),
        TextField(
          onChanged: (valueFirstName) {
            firstName = valueFirstName;
          },
          decoration: InputDecoration(
            errorText: (errorFirstName == EnumError.show) ? "Required" : null,
            labelText: 'First name',
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
          height: 1.h,
        ),
        TextField(
          onChanged: (valueFirstName) {
            lastName = valueFirstName;
          },
          decoration: InputDecoration(
            errorText: (errorLastName == EnumError.show) ? "Required" : null,
            labelText: 'Last name',
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
          height: 1.h,
        ),
        TextField(
          onChanged: (valueFirstName) {
            userName = valueFirstName;
          },
          decoration: InputDecoration(
            errorText: (errorUserName == EnumError.show) ? "Required" : null,
            labelText: 'User name',
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
          height: 1.h,
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
          height: 1.h,
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
          height: 1.h,
        ),
        TextField(
          onChanged: (valueFirstName) {
            password_validation = valueFirstName;
          },
          decoration: InputDecoration(
            errorText: (errorPassword == EnumError.show) ? "Required" : null,
            labelText: 'Confirm Password',
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
          height: 1.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Manager"),
            Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () async {
                  emailChecking();
                  firstNameChecking();
                  lastNameChecking();
                  passwordChecking();
                  UserNameChecking();
                  if (errorEmail == EnumError.hide &&
                      errorFirstName == EnumError.hide &&
                      errorLastName == EnumError.hide &&
                      errorPassword == EnumError.hide &&
                      errorUserName == EnumError.hide) {
                    if (isChecked) {
                      role = "manager";
                    }

                    var res = await signUp(userName, email_validation,
                        firstName, password_validation, lastName, role);

                    if (res.data["status"] == "success") {
                      Navigator.pop(context);
                    }

                    print(res.data["status"]);
                  }
                },
                child: Text("Sign Up")),
          ],
        ),
      ])),
    );
  }
}
