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
  
  EnumError errorEmail = EnumError.hide;
  EnumError errorPassword = EnumError.hide;
  EnumError errorFirstName = EnumError.hide;
  EnumError errorLastName = EnumError.hide;
  EnumError errorUserName = EnumError.hide;
  EnumError errorConfirmationPassword = EnumError.hide;
  bool hiddenPassword = true;
  bool hiddenConfirmationPassword = true;

  String email = "";
  String password = "";
  String firstName = "";
  String lastName = "";
  String userName="";
  String confirmationPassword="";
  String role="customer";

  String emailErrorText = "";
  String userNameErrorText = "";
  String firstNameErrorText = "";
  String lastNameErrorText = "";
  String passwordErrorText = "";
  String confirmationPasswordErrorText = "";


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

  /// Preview the hidden password
  void toggleHiddenPassword() {
    setState(() {
      hiddenPassword = !hiddenPassword;
    });
  }

 /// Preview the hidden confirmation password
   void toggleHiddenConfirmationPassword() {
    setState(() {
      hiddenConfirmationPassword = !hiddenConfirmationPassword;
    });
  }

  /// Checks the String email, and performs the suitable action accordingly
  void emailChecking() {
    if (email?.isNotEmpty ?? false) {
      final bool isValid = EmailValidator.validate(email);
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
    } else if (email?.isEmpty ?? true) {
      setState(
        () {
          errorEmail = EnumError.show;
          emailErrorText = "Required";
        },
      );
    }
  }

  /// Checks if the first name text box is not empty and starts with a letter 
  void firstNameChecking() {
    if (firstName?.isNotEmpty ?? false) {
        String  patternSmall = r'[a-z]';
        String  patternCapital = r'[A-Z]';
        RegExp regExpSmall = new RegExp(patternSmall);
        RegExp regExpCapital = new RegExp(patternCapital);
        if (firstName.startsWith(regExpSmall))
        {
        setState(
          () {
            errorFirstName = EnumError.hide;
          },
        );
      } 
      else {
        
        if (firstName.startsWith(regExpCapital))
        {
         setState(() {
            errorFirstName = EnumError.hide;
          },
        );
        }
        else
        {
          setState(() {
          errorFirstName = EnumError.show;
          firstNameErrorText = "The first name should start with a small or a capital letter";
        });
        }
      }
    } else if (firstName?.isEmpty ?? true) {
      setState(
        () {
          errorFirstName = EnumError.show;
          firstNameErrorText = "Required";
        },
      );
    }
  }

/// Checks if the user name text box is not empty and starts with a letter and doesn't contain a space
   void userNameChecking() {
    if (userName?.isNotEmpty ?? false) {
      if (userName.contains(" ")) {
        setState(
          () {
            errorUserName = EnumError.show;
            userNameErrorText = "No spaces are allowed";
          },
        );
      } else {

        String  patternSmall = r'[a-z]';
        String  patternCapital = r'[A-Z]';
        RegExp regExpSmall = new RegExp(patternSmall);
        RegExp regExpCapital = new RegExp(patternCapital);

  if (userName.startsWith(regExpSmall))
        {
        setState(
          () {
            errorUserName = EnumError.hide;
          },
        );
      } 
      else {
        
        if (userName.startsWith(regExpCapital))
        {
         setState(() {
            errorUserName = EnumError.hide;
          },
        );
        }
        else
        {
          setState(() {
          errorUserName = EnumError.show;
          userNameErrorText = "The username should start with a small or a capital letter";
        });
        }
      }
      }
    } else if (userName?.isEmpty ?? true) {
      setState(
        () {
          errorUserName = EnumError.show;
          userNameErrorText = "Required";
        },
      );
    }
  }

 /// Checks if the last name text box is not empty and starts with a letter 
  void lastNameChecking() {
    if (lastName?.isNotEmpty ?? false) {
        String  patternSmall = r'[a-z]';
        String  patternCapital = r'[A-Z]';
        RegExp regExpSmall = new RegExp(patternSmall);
        RegExp regExpCapital = new RegExp(patternCapital);
        if (lastName.startsWith(regExpSmall))
        {
        setState(
          () {
            errorLastName = EnumError.hide;
          },
        );
      } else {
        
        if (lastName.startsWith(regExpCapital))
        {
         setState(() {
            errorLastName = EnumError.hide;
          },
        );
        }
        else
        {
          setState(() {
          errorLastName = EnumError.show;
          lastNameErrorText = "The last name should start with a small or a capital letter";
        });
        }
      }
    } else if (lastName?.isEmpty ?? true) {
      setState(
        () {
          errorLastName = EnumError.show;
          lastNameErrorText = "Required";
        },
      );
    }
  }

  
  /// This function checks if the input password is valid (the length > 8) and contains at least 1 digit and 1 letter
  bool isPassword(String password)
   {
        String  pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{9,}$'; //more than eight characters, at least one letter and one number
        RegExp regExp = new RegExp(pattern);
        if (regExp.hasMatch(password))
          return true;
        else
          return false;
  }


  /// This function checks if the two passwords are identical
  void comparePassword(String password, String confirmationPassword) {

    if (confirmationPassword?.isNotEmpty ?? false) 
    {
      if (password == confirmationPassword) {
          setState(() {
            errorConfirmationPassword = EnumError.hide;
          });
      }
      else
      {
        setState(() {
          errorConfirmationPassword = EnumError.show;
          confirmationPasswordErrorText = "Password mismatch";
        });
      }
    }
    else if(confirmationPassword?.isEmpty ?? true)
    {
        setState(
        () {
          errorConfirmationPassword = EnumError.show;
          confirmationPasswordErrorText = "Required";
        },
      );
    }
  }

  void passwordChecking() {
    if (password?.isNotEmpty ?? false) {
      setState(() {
        if (isPassword(password))
          errorPassword = EnumError.hide;
        else {
          errorPassword = EnumError.show;
          passwordErrorText = "Please use more than 8 characters including at least 1 digit and 1 letter";
        }
      });
    } else if (password?.isEmpty ?? true) {
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
          height: 2.h,
        ),
        Container(
          width: 550,
          child: TextField(
            onChanged: (valueFirstName) {
              firstName = valueFirstName;
            },
            decoration: InputDecoration(
              errorText: (errorFirstName == EnumError.show) ? firstNameErrorText : null,
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
        ),
        SizedBox(
          height: 1.h,
        ),
        Container(
          width: 550,
          child: TextField(
            onChanged: (valueLastName) {
              lastName = valueLastName;
            },
            decoration: InputDecoration(
              errorText: (errorLastName == EnumError.show) ? lastNameErrorText : null,
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
        ),
        SizedBox(
          height: 1.h,
        ),
        Container(
          width: 550,
          child: TextField(
            onChanged: (valueUserName) {
              userName = valueUserName;
            },
            decoration: InputDecoration(
              errorText: (errorUserName == EnumError.show) ? userNameErrorText : null,
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
        ),
        SizedBox(
          height: 1.h,
        ),
        Container(
          width: 550,
          child: TextField(
            onChanged: (valueEmail) {
              email = valueEmail;
            },
            decoration: InputDecoration(
              errorText: (errorEmail == EnumError.show) ? emailErrorText : null,
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
        ),
        SizedBox(
          height: 1.h,
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
              errorText: (errorPassword == EnumError.show) ? passwordErrorText : null,
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
          height: 1.h,
        ),
        Container(
          width: 550,
          child: TextField(
            obscureText: hiddenConfirmationPassword,
            onChanged: (valueConfirmationPassword) {
              confirmationPassword = valueConfirmationPassword;
            },
            decoration: InputDecoration(
              suffixIcon: IconButton(
                    onPressed: () {
                     toggleHiddenConfirmationPassword();
                    },
                    icon: (hiddenConfirmationPassword)
                        ? Icon(
                            Icons.remove_red_eye_outlined,
                          )
                        : Icon(Icons.visibility_off_outlined),
                  ),
              errorText: (errorConfirmationPassword == EnumError.show) ? confirmationPasswordErrorText : null,
              labelText: 'Confirm password',
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
                  userNameChecking();
                  comparePassword(password, confirmationPassword);
                  if (errorEmail == EnumError.hide &&
                      errorFirstName == EnumError.hide &&
                      errorLastName == EnumError.hide &&
                      errorPassword == EnumError.hide &&
                      errorUserName == EnumError.hide &&
                      errorConfirmationPassword == EnumError.hide
                      ) {

                        if (isChecked)
                        {
                          role="manager";
                        }

                        var res=await signUp(userName,email,firstName,password,lastName,role);

                        if (res.data["status"]=="success"){

                        Navigator.pop(context);

                        }
                        else
                        {
                          setState(() {
                            errorEmail = EnumError.show;
                            errorUserName=EnumError.show;
                            emailErrorText = "There is an account with the same email or username";
                            userNameErrorText = "There is an account with the same email or username";
                          });
                          
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
