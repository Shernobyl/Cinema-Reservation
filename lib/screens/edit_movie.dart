import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:movies_app_flutter/screens/home_screen.dart';
import 'package:movies_app_flutter/utils/constants.dart';
import 'package:movies_app_flutter/widgets/beauty_textfield.dart';
import 'package:movies_app_flutter/components/red_rounded_action_button.dart';
import 'package:movies_app_flutter/widgets/movie_card.dart';
import 'package:sizer/sizer.dart';
import 'package:movies_app_flutter/services/movie.dart';
import 'package:movies_app_flutter/utils/navi.dart' as navi;
import 'package:movies_app_flutter/utils/file_manager.dart' as file;

enum EnumError { show, hide }

class EditMovie extends StatefulWidget {
  final String id;
  final String name;
  final String overview;
  final String startDate;
  final String endDate;
  final String? imgurl;
  final int screeningRoom;
  final Color themeColor;
  final String token;

  const EditMovie(
      {required this.id,
      required this.themeColor,
      required this.name,
      required this.overview,
      required this.startDate,
      required this.endDate,
      required this.imgurl,
      required this.screeningRoom,
      required this.token});

  @override
  _EditMovieState createState() => _EditMovieState();
}

class _EditMovieState extends State<EditMovie> {
  //for custom drawer opening
  //for scroll upping
  EnumError errorMovieName = EnumError.hide;
  EnumError errorMovieImage = EnumError.hide;
  EnumError errorMovieDescription = EnumError.hide;
  List<MovieCard>? _movieCards;
  Color? themeColor;

  Future<void> loadData() async {
    MovieModel movieModel = MovieModel();
    _movieCards = await movieModel.getMovies(
      themeColor: themeColor!,
    );
    print(_movieCards);
    setState(() {
      showBackToTopButton = false;
    });
  }

  // String movieName = "";
  // String movieImage = "";
  // String movieDescription = "";

  // ignore: non_constant_identifier_names
  String err_movieName = "";
  // ignore: non_constant_identifier_names
  String err_movieImage = "";
  // ignore: non_constant_identifier_names
  String err_movieDescription = "";
  String err_movieDate = "";

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

  @override
  void initState() {
    super.initState();

    movieName.text = widget.name;
    movieImage.text = widget.imgurl.toString();
    movieDescription.text = widget.overview;
    movieDate = widget.startDate;
    startDate = widget.startDate;
    endDate = widget.endDate;
    dropdownValue = widget.screeningRoom;
    () async {
      themeColor = await file.currentTheme();
      print(themeColor);
      setState(() {
        loadData();
      });
    }();
  }

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
        dropdownValue.toString(),
        widget.token);
  }

  goBack() async {
    await navi.newScreen(context: context, newScreen: () => HomeScreen());
  }

  bool movieDateCheck() {
    for (MovieCard movie in _movieCards!) {
      print(movie);
      DateTime start_date = DateTime.parse(startDate);
      DateTime end_date = DateTime.parse(endDate);

      if (widget.id == movie.moviePreview.id) {
        if (end_date.isBefore(start_date) || //if E     S
            start_date.isBefore(DateTime.now())) {
          setState(() {
            err_movieDate =
                "Error: End time can't be before start time or Start time can't be in the past";
          });
          return false;
        }
      } else if (int.parse(movie.moviePreview.screeningRoom) == dropdownValue) {
        //if they are the same room
        if (end_date.isBefore(start_date) || //if E     S
            start_date.isBefore(DateTime.now()) || //if creating in the past
            (start_date.isAfter(DateTime.parse(
                    movie.moviePreview.startDate)) && //if S   New_S   E
                start_date.isBefore(DateTime.parse(
                    movie.moviePreview.endDate))) || //or if S   New_E    E
            (end_date.isAfter(DateTime.parse(movie.moviePreview.startDate)) &&
                end_date.isBefore(DateTime.parse(
                    movie.moviePreview.endDate))) || //or if S == New_S
            start_date.isAtSameMomentAs(DateTime.parse(
                movie.moviePreview.startDate)) || //or if E == New_E
            end_date
                .isAtSameMomentAs(DateTime.parse(movie.moviePreview.endDate))) {
          setState(() {
            err_movieDate =
                "Error in setting times, make sure movies don't overlap with other rooms or timing logics";
          });
          return false;
        }
      }
    }
    setState(() {
      err_movieDate = "";
    });
    return true;
  }

  void movienameChecking() {
    if (movieName.text?.isNotEmpty ?? false) {
      if (movieName.text.startsWith(" ")) {
        setState(
          () {
            errorMovieName = EnumError.show;
            err_movieName = "Movie name should not start with space";
          },
        );
      } else {
        setState(
          () {
            errorMovieName = EnumError.hide;
            err_movieName = "";
          },
        );
      }
    } else if (movieName.text?.isEmpty ?? true) {
      setState(
        () {
          errorMovieName = EnumError.show;
          err_movieName = "Required";
        },
      );
    }
  }

  void movieimageChecking() {
    if (movieImage.text?.isNotEmpty ?? false) {
      if (movieImage.text.contains(" ")) {
        setState(
          () {
            errorMovieImage = EnumError.show;
            err_movieImage = "Movie Image should not include space";
          },
        );
      } else {
        setState(
          () {
            errorMovieImage = EnumError.hide;
            err_movieImage = "";
          },
        );
      }
    } else if (movieImage.text?.isEmpty ?? true) {
      setState(
        () {
          errorMovieImage = EnumError.show;
          err_movieImage = "Required";
        },
      );
    }
  }

  void moviedescChecking() {
    if (movieDescription.text?.isNotEmpty ?? false) {
      if (movieDescription.text.startsWith(" ")) {
        setState(
          () {
            errorMovieDescription = EnumError.show;
            err_movieDescription = "Movie name should not start with space";
          },
        );
      } else {
        setState(
          () {
            errorMovieDescription = EnumError.hide;
            err_movieDescription = "";
          },
        );
      }
    } else if (movieDescription.text?.isEmpty ?? true) {
      setState(
        () {
          errorMovieDescription = EnumError.show;
          err_movieDescription = "Required";
        },
      );
    }
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
                decoration: InputDecoration(
                    errorText: (errorMovieName == EnumError.show)
                        ? err_movieName
                        : null),
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
                child: Text(err_movieName, style: TextStyle(color: Colors.red)),
              ),
              BeautyTextfield(
                decoration: InputDecoration(
                    errorText: (errorMovieImage == EnumError.show)
                        ? err_movieImage
                        : null),
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
                child:
                    Text(err_movieImage, style: TextStyle(color: Colors.red)),
              ),
              BeautyTextfield(
                decoration: InputDecoration(
                    errorText: (errorMovieDescription == EnumError.show)
                        ? err_movieDescription
                        : null),

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
                child: Text(err_movieDescription,
                    style: TextStyle(color: Colors.red)),
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
                    // // Disable weekend days to select from the calendar
                    // if (date.weekday == 6 ||
                    //     date.weekday == 7) {
                    //   return false;
                    // }

                    return true;
                  },
                  onChanged: (val) {
                    setState(() {
                      movieDate = val;
                    });
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
                  initialTime:
                      TimeOfDay.fromDateTime(DateTime.parse(movieDate)),
                  icon: Icon(Icons.timelapse),
                  timeLabelText: "Start Hour",
                  onChanged: (val) {
                    String date = movieDate.toString().substring(0, 10);
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
                  initialTime: TimeOfDay.fromDateTime(DateTime.parse(endDate)),
                  icon: Icon(Icons.timelapse),
                  timeLabelText: "End Hour",
                  onChanged: (val) {
                    String date = movieDate.toString().substring(0, 10);
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
                  child: Text(
                    err_movieDate,
                    style: TextStyle(color: Colors.red),
                  )),
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
                  movienameChecking();

                  movieimageChecking();

                  moviedescChecking();

                  if (errorMovieName == EnumError.hide &&
                      errorMovieImage == EnumError.hide &&
                      errorMovieDescription == EnumError.hide &&
                      movieDateCheck()) {
                    print(movieDescription.text);
                    editMovie();
                    goBack();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
