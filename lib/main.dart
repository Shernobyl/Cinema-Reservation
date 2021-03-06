import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'utils/constants.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'package:provider/provider.dart';

import 'model/usermodel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyModel>(
      create: (context) => MyModel(),
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Sizer',
              theme: ThemeData.dark().copyWith(
                platform: TargetPlatform.iOS,
                primaryColor: kPrimaryColor,
                scaffoldBackgroundColor: kPrimaryColor,
              ),
              home: Login()
              //    HomeScreen(
              //  key: kHomeScreenKey,
              //),
              );
        },
      ),
    );
  }
}
