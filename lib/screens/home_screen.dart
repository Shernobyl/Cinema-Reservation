import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:movies_app_flutter/model/reservation_details.dart';
import 'package:movies_app_flutter/screens/drawer_screen.dart';
import 'package:movies_app_flutter/screens/finder_screen.dart';
import 'package:movies_app_flutter/utils/constants.dart';
import 'package:movies_app_flutter/utils/file_manager.dart' as file;
import 'package:movies_app_flutter/utils/navi.dart' as navi;
import 'package:movies_app_flutter/utils/scroll_top_with_controller.dart'
    as scrollTop;
import 'package:movies_app_flutter/utils/toast_alert.dart' as alert;
import 'package:movies_app_flutter/widgets/bottom_navigation.dart';
import 'package:movies_app_flutter/widgets/bottom_navigation_item.dart';
import 'package:movies_app_flutter/widgets/custom_loading_spin_kit_ring.dart';
import 'package:movies_app_flutter/widgets/custom_main_appbar_content.dart';
import 'package:movies_app_flutter/widgets/movie_card.dart';
import 'package:movies_app_flutter/widgets/movie_card_container.dart';
import 'package:movies_app_flutter/widgets/shadowless_floating_button.dart';
import 'package:movies_app_flutter/widgets/beauty_textfield.dart';
import 'package:movies_app_flutter/components/red_rounded_action_button.dart';
import 'package:sizer/sizer.dart';
import 'package:movies_app_flutter/services/movie.dart';
import 'package:provider/provider.dart';
import '../model/usermodel.dart';
import 'signup_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  //for custom drawer opening
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //for scroll upping
  bool isManager = false;
  bool isCustomer = false;
  String? token = "";
  bool checked = false;
  ScrollController? _scrollController;
  bool showBackToTopButton = false;
  Color borderColor = kBackgroundShadowColor;

  int? activeInnerPageIndex;
  Color? themeColor;
  List<MovieCard>? _movieCards;
  List<Reservation>? _userReservations;

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

  EnumError errorMovieName = EnumError.hide;
  EnumError errorMovieImage = EnumError.hide;
  EnumError errorMovieDescription = EnumError.hide;

  // ignore: non_constant_identifier_names
  String err_movieName = "";
  // ignore: non_constant_identifier_names
  String err_movieImage = "";
  // ignore: non_constant_identifier_names
  String err_movieDescription = "";
  String err_movieDate = "";

  bool loaded = false;

  void movienameChecking() {
    if (movieName.text?.isNotEmpty ?? false) {
      if (movieName.text.startsWith(" ")) {
        setState(
          () {
            errorMovieName = EnumError.show;
            err_movieName = "Movie name should not start with space";
            borderColor = Colors.red;
          },
        );
      } else {
        setState(
          () {
            errorMovieName = EnumError.hide;
            borderColor = kBackgroundShadowColor;
            err_movieName = "";
          },
        );
      }
    } else if (movieName.text?.isEmpty ?? true) {
      setState(
        () {
          errorMovieName = EnumError.show;
          err_movieName = "Required";
          borderColor = Colors.red;
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
            borderColor = Colors.red;
          },
        );
      } else {
        setState(
          () {
            errorMovieImage = EnumError.hide;
            borderColor = kBackgroundShadowColor;
            err_movieImage = "";
          },
        );
      }
    } else if (movieImage.text?.isEmpty ?? true) {
      setState(
        () {
          errorMovieImage = EnumError.show;
          err_movieImage = "Required";
          borderColor = Colors.red;
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
            borderColor = Colors.red;
          },
        );
      } else {
        setState(
          () {
            errorMovieDescription = EnumError.hide;
            borderColor = kBackgroundShadowColor;
            err_movieDescription = "";
          },
        );
      }
    } else if (movieDescription.text?.isEmpty ?? true) {
      setState(
        () {
          errorMovieDescription = EnumError.show;
          err_movieDescription = "Required";
          borderColor = Colors.red;
        },
      );
    }
  }

  bool movieDateCheck() {
    for (MovieCard movie in _movieCards!) {
      DateTime start_date = DateTime.parse(startDate);
      DateTime end_date = DateTime.parse(endDate);
      if (int.parse(movie.moviePreview.screeningRoom) == dropdownValue) {
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
                "Overlapping times in same room, please pick another date or another room";
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

  void getManager() {
    final user = Provider.of<MyModel>(context, listen: false);
    if (user.getToken() != null) {
      token = user.getToken();
      print("el token ahe " + token.toString());
      if (user.getPerson().role == "manager")
        isManager = true;
      else if (user.getPerson().role == "customer") isCustomer = true;
    }
    checked = true;
  }

  Future<void> deleteReservation(
      String movieID, String ticketID, String? token) async {
    MovieModel movieModel = MovieModel();
    await movieModel.deleteReservation(movieID, ticketID, token);
  }

  Future<void> loadData() async {
    MovieModel movieModel = MovieModel();
    if (isCustomer)
      _userReservations = await movieModel.getUserReservations(token);
    _movieCards = await movieModel.getMovies(
      themeColor: themeColor!,
    );
    print(_movieCards);
    setState(() {
      scrollTop.scrollToTop(_scrollController!);
      showBackToTopButton = false;
      loaded = true;
    });
  }

  Future<void> addMovie() async {
    MovieModel movieModel = MovieModel();
    await movieModel.addMovie(
        movieName.text,
        movieDate,
        movieImage.text,
        movieDescription.text,
        startDate,
        endDate,
        dropdownValue.toString(),
        token.toString());
  }

  void pageSwitcher(int index) {
    setState(() {
      loaded = false;
      bottomBarIndex = (index == 2) ? 2 : 1;
      title = (index == 2)
          ? (isCustomer)
              ? kFavoriteScreenTitleText2
              : kFavoriteScreenTitleText
          : kHomeScreenTitleText;
      showSlider = !(index == 2);
      _movieCards = null;
      loadData();
    });
  }

  void movieCategorySwitcher(int index) {
    setState(() {
      activeInnerPageIndex = index;
      _movieCards = null;
      loadData();
    });
  }

  @override
  void initState() {
    super.initState();
    getManager();
    () async {
      themeColor = await file.currentTheme();
      print(themeColor);
      _scrollController = ScrollController()
        ..addListener(() {
          setState(() {
            showBackToTopButton = (_scrollController!.offset >= 200);
          });
        });
      activeInnerPageIndex = 0;
      setState(() {
        loadData();
      });
    }();
  }

  @override
  void dispose() {
    if (_scrollController != null) _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (themeColor == null && checked == false && loaded == true)
        ? CustomLoadingSpinKitRing(loadingColor: themeColor)
        : Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: kAppBarColor,
              shadowColor: Colors.transparent,
              bottom: PreferredSize(
                child: CustomMainAppBarContent(
                  showSlider: showSlider,
                  title: title,
                  activeButtonIndex: activeInnerPageIndex!,
                  activeColor: themeColor!,
                  buttonFistOnPressed: (index) => movieCategorySwitcher(index),
                  buttonSecondOnPressed: (index) =>
                      movieCategorySwitcher(index),
                  buttonThirdOnPressed: (index) => movieCategorySwitcher(index),
                  searchOnPressed: () => navi.newScreen(
                    context: context,
                    newScreen: () => FinderScreen(
                      themeColor: themeColor!,
                    ),
                  ),
                ),
                preferredSize:
                    Size.fromHeight((bottomBarIndex == 1) ? 2.0.h : 2.0.h),
              ),
            ),
            body: (_movieCards == null)
                ? CustomLoadingSpinKitRing(loadingColor: themeColor)
                : (bottomBarIndex == 1)
                    ? (_movieCards!.length == 0)
                        ? Center(child: Text(k404Text))
                        : MovieCardContainer(
                            scrollController: _scrollController!,
                            themeColor: themeColor!,
                            movieCards: _movieCards!,
                          )
                    : (isCustomer)
                        ? (_userReservations!.length != 0)
                            ? Padding(
                                padding: const EdgeInsets.all(50.0),
                                child: SizedBox(
                                  height: 200.h,
                                  child: Center(
                                    child: ListView.builder(
                                      itemCount: _userReservations!.length,
                                      itemBuilder: (context, index) {
                                        return (_userReservations![index]
                                                    .movieDetails !=
                                                null)
                                            ? Card(
                                                //                           <-- Card widget
                                                child: ListTile(
                                                  leading: InkWell(
                                                    splashColor: Colors
                                                        .red, // Splash color
                                                    onTap: () {
                                                      deleteReservation(
                                                          _userReservations![
                                                                  index]
                                                              .movieDetails!
                                                              .id,
                                                          _userReservations![
                                                                  index]
                                                              .id,
                                                          token);
                                                      loadData();
                                                      print(_userReservations![
                                                              index]
                                                          .movieDetails!
                                                          .id);
                                                      print(_userReservations![
                                                              index]
                                                          .id);
                                                      print(token);
                                                      pageSwitcher(1);
                                                    },
                                                    child: SizedBox(
                                                      width: 56,
                                                      height: 56,
                                                      child: Icon(
                                                          Icons.delete_forever),
                                                    ),
                                                  ),
                                                  title: Text(
                                                      _userReservations![index]
                                                          .movieDetails!
                                                          .title),
                                                  subtitle: Text("Start Date:" +
                                                      _userReservations![index]
                                                          .movieDetails!
                                                          .startDate),
                                                ),
                                              )
                                            : Container();
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : Text("No Reservations")
                        : Center(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  BeautyTextfield(
                                    decoration: InputDecoration(
                                      errorText:
                                          (errorMovieName == EnumError.show)
                                              ? err_movieName
                                              : null,
                                    ),

                                    width: 180.0.w, //REQUIRED
                                    height: 5.h, //REQUIRED
                                    accentColor:
                                        kBackgroundShadowColor, // On Focus Color
                                    textColor: Colors.white, //Text Color
                                    backgroundColor:
                                        themeColor!, //Not Focused Color
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
                                    cornerRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    duration: Duration(milliseconds: 300),
                                    inputType: TextInputType.text, //REQUIRED
                                    placeholder: "Enter Movie Name",
                                    isShadow: false,
                                    obscureText: false,
                                    prefixIcon: Icon(Icons
                                        .movie_creation_outlined), //REQUIRED
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
                                    child: Text(
                                      err_movieName,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  BeautyTextfield(
                                    decoration: InputDecoration(
                                      errorText:
                                          (errorMovieImage == EnumError.show)
                                              ? err_movieImage
                                              : null,
                                    ),

                                    width: 180.0.w, //REQUIRED
                                    height: 5.h, //REQUIRED
                                    accentColor:
                                        kBackgroundShadowColor, // On Focus Color
                                    textColor: Colors.white, //Text Color
                                    backgroundColor:
                                        themeColor!, //Not Focused Color
                                    textBaseline: TextBaseline.alphabetic,
                                    autocorrect: false,
                                    autofocus: false,
                                    enabled: true, // Textfield enabled
                                    focusNode: FocusNode(),
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w200,
                                    maxLength: 500,
                                    minLines: 1,
                                    maxLines: 2,
                                    wordSpacing: 2,
                                    controller: movieImage,
                                    margin: EdgeInsets.all(10),
                                    cornerRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    duration: Duration(milliseconds: 300),
                                    inputType: TextInputType.text, //REQUIRED
                                    placeholder: "Enter Movie Image Link",
                                    isShadow: false,
                                    obscureText: false,
                                    prefixIcon:
                                        Icon(Icons.image_outlined), //REQUIRED
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
                                      child: Text(
                                        err_movieImage,
                                        style: TextStyle(color: Colors.red),
                                      )),
                                  BeautyTextfield(
                                    decoration: InputDecoration(
                                      errorText: (errorMovieDescription ==
                                              EnumError.show)
                                          ? err_movieDescription
                                          : null,
                                    ),

                                    width: 180.0.w, //REQUIRED
                                    height: 8.0.h, //REQUIRED
                                    accentColor:
                                        kBackgroundShadowColor, // On Focus Color
                                    textColor: Colors.white, //Text Color
                                    backgroundColor:
                                        themeColor!, //Not Focused Color
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
                                    cornerRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    duration: Duration(milliseconds: 300),
                                    inputType: TextInputType.text, //REQUIRED
                                    placeholder: "Enter Movie Description",
                                    isShadow: false,
                                    obscureText: false,
                                    prefixIcon:
                                        Icon(Icons.description), //REQUIRED
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
                                      child: Text(
                                        err_movieDescription,
                                        style: TextStyle(color: Colors.red),
                                      )),
                                  SizedBox(
                                    width: 20.h,
                                    child: DateTimePicker(
                                      type: DateTimePickerType.date,
                                      dateMask: 'd MMM, yyyy',
                                      initialValue: DateTime.now().toString(),
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
                                      initialTime: TimeOfDay.now(),
                                      icon: Icon(Icons.timelapse),
                                      timeLabelText: "Start Hour",
                                      onChanged: (val) {
                                        String date = movieDate
                                            .toString()
                                            .substring(0, 10);
                                        startDate = date.toString() +
                                            "T" +
                                            val +
                                            ":00.00Z";
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
                                        String date = movieDate
                                            .toString()
                                            .substring(0, 10);
                                        endDate = date.toString() +
                                            "T" +
                                            val +
                                            ":00.00Z";
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
                                        print(dropdownValue);
                                      });
                                    },
                                    items: <int>[
                                      1,
                                      2
                                    ].map<DropdownMenuItem<int>>((int value) {
                                      return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text(value.toString()),
                                      );
                                    }).toList(),
                                  ),
                                  RedRoundedActionButton(
                                    text: 'ADD MOVIE',
                                    callback: () {
                                      movienameChecking();

                                      movieimageChecking();

                                      moviedescChecking();

                                      if (errorMovieName == EnumError.hide &&
                                          errorMovieImage == EnumError.hide &&
                                          errorMovieDescription ==
                                              EnumError.hide &&
                                          movieDateCheck()) {
                                        print(movieDescription.text);
                                        addMovie();
                                        loadData();
                                        Future.delayed(
                                            const Duration(milliseconds: 1300),
                                            () {
                                          setState(() {
                                            // Here you can write your code for open new view
                                            pageSwitcher(1);
                                          });
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
            bottomNavigationBar: BottomNavigation(
              activeColor: themeColor!,
              index: bottomBarIndex,
              children: [
                BottomNavigationItem(
                  icon: Icon(Icons.more_horiz),
                  iconSize: 15.sp,
                  onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                ),
                BottomNavigationItem(
                  icon: Icon(Icons.videocam),
                  iconSize: 15.sp,
                  onPressed: () {
                    pageSwitcher(1);
                  },
                ),
                (isManager)
                    ? BottomNavigationItem(
                        icon: Icon(Icons.add),
                        iconSize: 15.sp,
                        onPressed: () {
                          pageSwitcher(2);
                        })
                    : BottomNavigationItem(
                        icon: Icon(Icons.reset_tv_rounded),
                        iconSize: 15.sp,
                        onPressed: () {
                          pageSwitcher(2);
                        }),
              ],
            ),
            drawerEnableOpenDragGesture: false,
            drawer: DrawerScreen(colorChanged: (color) {
              themeColor = color;
              setState(() {
                alert.toastAlert(
                    message: kAppliedTheme, themeColor: themeColor);
              });
            }),
            floatingActionButton: showBackToTopButton
                ? ShadowlessFloatingButton(
                    iconData: Icons.keyboard_arrow_up_outlined,
                    onPressed: () {
                      setState(() {
                        scrollTop.scrollToTop(_scrollController!);
                      });
                    },
                    backgroundColor: themeColor,
                  )
                : null,
          );
  }
}
