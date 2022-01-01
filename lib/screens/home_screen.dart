import 'package:flutter/material.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  //for custom drawer opening
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //for scroll upping
  ScrollController? _scrollController;
  bool showBackToTopButton = false;
  Color? themeColor;
  int? activeInnerPageIndex;
  List<MovieCard>? _movieCards;
  bool showSlider = true;
  String title = kHomeScreenTitleText;
  int bottomBarIndex = 1;
  final MovieName = TextEditingController();
  final MovieImage = TextEditingController();
  final MovieDescription = TextEditingController();

  Future<void> loadData() async {
    MovieModel movieModel = MovieModel();
    _movieCards = (bottomBarIndex == 1)
        ? await movieModel.getMovies(
            moviesType: MoviePageType.values[activeInnerPageIndex!],
            themeColor: themeColor!)
        : await movieModel.getFavorites(
            themeColor: themeColor!, bottomBarIndex: bottomBarIndex);
    setState(() {
      scrollTop.scrollToTop(_scrollController!);
      showBackToTopButton = false;
    });
  }

  void pageSwitcher(int index) {
    setState(() {
      bottomBarIndex = (index == 2) ? 2 : 1;
      title = (index == 2) ? kFavoriteScreenTitleText : kHomeScreenTitleText;
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
    return (themeColor == null)
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
                    : Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 2.h,
                            ),
                            BeautyTextfield(
                              width: 180.0.w, //REQUIRED
                              height: 5.h, //REQUIRED
                              accentColor:
                                  kBackgroundShadowColor, // On Focus Color
                              textColor: Colors.white, //Text Color
                              backgroundColor: themeColor!, //Not Focused Color
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
                              controller: MovieName,
                              margin: EdgeInsets.all(10),
                              cornerRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              duration: Duration(milliseconds: 300),
                              inputType: TextInputType.text, //REQUIRED
                              placeholder: "Enter Movie Name",
                              isShadow: false,
                              obscureText: false,
                              prefixIcon: Icon(
                                  Icons.movie_creation_outlined), //REQUIRED
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
                              accentColor:
                                  kBackgroundShadowColor, // On Focus Color
                              textColor: Colors.white, //Text Color
                              backgroundColor: themeColor!, //Not Focused Color
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
                              controller: MovieImage,
                              margin: EdgeInsets.all(10),
                              cornerRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              duration: Duration(milliseconds: 300),
                              inputType: TextInputType.text, //REQUIRED
                              placeholder: "Enter Movie Image Link",
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
                              accentColor:
                                  kBackgroundShadowColor, // On Focus Color
                              textColor: Colors.white, //Text Color
                              backgroundColor: themeColor!, //Not Focused Color
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
                              controller: MovieDescription,
                              margin: EdgeInsets.all(10),
                              cornerRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              duration: Duration(milliseconds: 300),
                              inputType: TextInputType.text, //REQUIRED
                              placeholder: "Enter Movie Description",
                              isShadow: false,
                              obscureText: false,
                              prefixIcon: Icon(Icons.description), //REQUIRED
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
                            RedRoundedActionButton(
                              text: 'ADD MOVIE',
                              callback: () {
                                pageSwitcher(1);
                              },
                            ),
                          ],
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
                BottomNavigationItem(
                    icon: Icon(Icons.add),
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
