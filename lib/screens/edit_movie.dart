import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:movies_app_flutter/screens/home_screen.dart';
import 'package:movies_app_flutter/utils/constants.dart';
import 'package:movies_app_flutter/widgets/beauty_textfield.dart';
import 'package:movies_app_flutter/components/red_rounded_action_button.dart';
import 'package:sizer/sizer.dart';
import 'package:movies_app_flutter/services/movie.dart';
import 'package:movies_app_flutter/utils/navi.dart' as navi;

class EditMovie extends StatefulWidget {
  final String id;
  final String name;
  final String overview;
  final String startDate;
  final String endDate;
  final String? imgurl;
  final int screeningRoom;
  final Color themeColor;

  const EditMovie({
    required this.id,
    required this.themeColor,
    required this.name,
    required this.overview,
    required this.startDate,
    required this.endDate,
    required this.imgurl,
    required this.screeningRoom,
  });

  @override
  _EditMovieState createState() => _EditMovieState();
}

class _EditMovieState extends State<EditMovie> {
  //for custom drawer opening
  //for scroll upping
  bool isManager = false;
  bool checked = false;
  bool showBackToTopButton = false;
  int? activeInnerPageIndex;
  bool showSlider = true;
  String title = kHomeScreenTitleText;
  int bottomBarIndex = 1;
  final movieName = TextEditingController();
  final movieImage = TextEditingController();
  final movieDescription = TextEditingController();
  String movieDate = "2021-12-31T09:00:00.00Z";
  String startDate = "2021-12-31T09:00:00.00Z";
  String endDate = "2021-12-31T09:00:00.00Z";
  int dropdownValue = 1;

  Future<void> editMovie() async {
    MovieModel movieModel = MovieModel();
    await movieModel.editMovie(
        widget.id,
        movieName.text,
        movieDate,
        movieImage.text,
        movieDescription.text,
        startDate,
        endDate,
        dropdownValue.toString());
  }

  goBack() async {
    await navi.newScreen(context: context, newScreen: () => HomeScreen());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 24,
                    height: MediaQuery.of(context).size.width / 24,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              Text(
                "Edit Movie Data",
                style: kTitleTextStyle,
              ),
              SizedBox(
                height: 2.h,
              ),
              BeautyTextfield(
                width: 180.0.w, //REQUIRED
                height: 5.h, //REQUIRED
                accentColor: kBackgroundShadowColor, // On Focus Color
                textColor: Colors.white, //Text Color
                backgroundColor: widget.themeColor, //Not Focused Color
                textBaseline: TextBaseline.alphabetic,
                autocorrect: false,
                autofocus: false,
                enabled: true, // Textfield enabled
                focusNode: FocusNode(),
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w200,
                maxLength: 50,
                minLines: 1,
                maxLines: 2,
                wordSpacing: 2,
                controller: movieName,
                margin: EdgeInsets.all(10),
                cornerRadius: BorderRadius.all(Radius.circular(15)),
                duration: Duration(milliseconds: 300),
                inputType: TextInputType.text, //REQUIRED
                placeholder: widget.name,
                isShadow: false,
                obscureText: false,
                prefixIcon: Icon(Icons.movie_creation_outlined), //REQUIRED
                onTap: () {
                  print('Click');
                },
                onChanged: (text) {
                  print(text);
                },
                onSubmitted: (data) {
                  print(data.length);
                },
              ),
              SizedBox(
                height: 2.h,
              ),
              BeautyTextfield(
                width: 180.0.w, //REQUIRED
                height: 5.h, //REQUIRED
                accentColor: kBackgroundShadowColor, // On Focus Color
                textColor: Colors.white, //Text Color
                backgroundColor: widget.themeColor, //Not Focused Color
                textBaseline: TextBaseline.alphabetic,
                autocorrect: false,
                autofocus: false,
                enabled: true, // Textfield enabled
                focusNode: FocusNode(),
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w200,
                maxLength: 100,
                minLines: 1,
                maxLines: 2,
                wordSpacing: 2,
                controller: movieImage,
                margin: EdgeInsets.all(10),
                cornerRadius: BorderRadius.all(Radius.circular(15)),
                duration: Duration(milliseconds: 300),
                inputType: TextInputType.text, //REQUIRED
                placeholder: widget.imgurl.toString(),
                isShadow: false,
                obscureText: false,
                prefixIcon: Icon(Icons.image_outlined), //REQUIRED
                onTap: () {
                  print('Click');
                },
                onChanged: (text) {
                  print(text);
                },
                onSubmitted: (data) {
                  print(data.length);
                },
              ),
              SizedBox(
                height: 2.h,
              ),
              BeautyTextfield(
                width: 180.0.w, //REQUIRED
                height: 8.0.h, //REQUIRED
                accentColor: kBackgroundShadowColor, // On Focus Color
                textColor: Colors.white, //Text Color
                backgroundColor: widget.themeColor, //Not Focused Color
                textBaseline: TextBaseline.alphabetic,
                autocorrect: false,
                autofocus: false,
                enabled: true, // Textfield enabled
                focusNode: FocusNode(),
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w200,
                maxLength: 500,
                minLines: 1,
                maxLines: 8,
                wordSpacing: 2,
                controller: movieDescription,
                margin: EdgeInsets.all(10),
                cornerRadius: BorderRadius.all(Radius.circular(15)),
                duration: Duration(milliseconds: 300),
                inputType: TextInputType.text, //REQUIRED
                placeholder: widget.overview,
                isShadow: false,
                obscureText: false,
                prefixIcon: Icon(Icons.description), //REQUIRED
                onTap: () {
                  print('Click');
                },
                onChanged: (text) {
                  // print(text);
                },
                onSubmitted: (data) {
                  print(data.length);
                },
              ),
              SizedBox(
                height: 2.h,
              ),
              SizedBox(
                width: 20.h,
                child: DateTimePicker(
                  type: DateTimePickerType.date,
                  dateMask: 'd MMM, yyyy',
                  initialValue: widget.startDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  icon: Icon(Icons.event),
                  dateLabelText: 'Movie Date',
                  selectableDayPredicate: (date) {
                    // Disable weekend days to select from the calendar
                    if (date.weekday == 6 || date.weekday == 7) {
                      return false;
                    }

                    return true;
                  },
                  onChanged: (val) {
                    movieDate = val;
                    print(movieDate);
                  },
                  validator: (val) {
                    print(val);
                    return null;
                  },
                  onSaved: (val) {},
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              SizedBox(
                width: 20.h,
                child: DateTimePicker(
                  type: DateTimePickerType.time,
                  initialTime: TimeOfDay.now(),
                  icon: Icon(Icons.timelapse),
                  timeLabelText: "Start Hour",
                  onChanged: (val) {
                    DateTime dateToday = new DateTime.now();
                    String date = dateToday.toString().substring(0, 10);
                    startDate = date.toString() + "T" + val + ":00.00Z";
                    print(startDate);
                  },
                  validator: (val) {
                    //print(val);
                    return null;
                  },
                  onSaved: (val) {},
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              SizedBox(
                width: 20.h,
                child: DateTimePicker(
                  type: DateTimePickerType.time,
                  initialTime: TimeOfDay.now(),
                  icon: Icon(Icons.timelapse),
                  timeLabelText: "End Hour",
                  onChanged: (val) {
                    DateTime dateToday = new DateTime.now();
                    String date = dateToday.toString().substring(0, 10);
                    endDate = date.toString() + "T" + val + ":00.00Z";
                    print(endDate);
                  },
                  validator: (val) {
                    print(val);
                    return null;
                  },
                  onSaved: (val) {},
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text("Screening Room"),
              DropdownButton<int>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 16,
                style: const TextStyle(color: Colors.white),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (int? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <int>[1, 2].map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
              RedRoundedActionButton(
                text: 'EDIT MOVIE',
                callback: () {
                  print(movieDescription.text);
                  editMovie();
                  goBack();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
