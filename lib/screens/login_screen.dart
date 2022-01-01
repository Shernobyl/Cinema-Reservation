import 'package:flutter/material.dart';
import 'package:movies_app_flutter/widgets/beauty_textfield.dart';
import 'package:movies_app_flutter/utils/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:movies_app_flutter/utils/file_manager.dart' as file;
import 'signup_screen.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Color? themeColor;
  final email = TextEditingController();
  final password = TextEditingController();

  ScrollController? _scrollController;
  bool showBackToTopButton = false;
  int? activeInnerPageIndex;

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
            // firstName = valueFirstName;
          },
          decoration: InputDecoration(
            // errorText: (errorFirstName == EnumError.show) ? "Required" : null,
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
            // firstName = valueFirstName;
          },
          decoration: InputDecoration(
            // errorText: (errorFirstName == EnumError.show) ? "Required" : null,
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
            TextButton(onPressed: () {}, child: Text("Login")),
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
