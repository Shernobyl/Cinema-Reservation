import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:movies_app_flutter/screens/edit_movie.dart';
import 'package:movies_app_flutter/utils/constants.dart';
import 'package:movies_app_flutter/widgets/custom_loading_spin_kit_ring.dart';
import 'package:sizer/sizer.dart';
import 'package:movies_app_flutter/components/red_rounded_action_button.dart';
import 'package:movies_app_flutter/screens/buy_ticket.dart';
import 'package:movies_app_flutter/utils/navi.dart' as navi;
import 'package:provider/provider.dart';
import '../services/auth_user.dart';
import '../model/usermodel.dart';

class DetailsScreen extends StatefulWidget {
  final String id;
  final String name;
  final String overview;
  final String startDate;
  final String endDate;
  final String? imgurl;
  final List<bool> seats;
  final String screeningRoom;
  final Color themeColor;
  DetailsScreen(
      {required this.id,
      required this.themeColor,
      required this.name,
      required this.overview,
      required this.startDate,
      required this.endDate,
      required this.imgurl,
      required this.screeningRoom,
      required this.seats});
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isManager = false;
  void getManager() {
    final user = Provider.of<MyModel>(context, listen: false);
    if (user.getToken() != null) {
      if (user.getPerson().role == "manager") {
        isManager = true;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getManager();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (widget.name == "")
          ? CustomLoadingSpinKitRing(loadingColor: widget.themeColor)
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  shadowColor: Colors.transparent,
                  leading: Padding(
                    padding: EdgeInsets.only(left: 3.w),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  automaticallyImplyLeading: false,
                  pinned: true,
                  snap: false,
                  floating: false,
                  expandedHeight: 22.0.h,
                  actions: [
                    (isManager)
                        ? Padding(
                            padding: EdgeInsets.only(right: 3.w),
                            child: IconButton(
                              onPressed: () async {
                                print('editing');
                                await navi.newScreen(
                                    context: context,
                                    newScreen: () => EditMovie(
                                          name: widget.name,
                                          screeningRoom:
                                              int.parse(widget.screeningRoom),
                                          id: widget.id,
                                          startDate: widget.startDate,
                                          endDate: widget.endDate,
                                          overview: widget.overview,
                                          imgurl: widget.imgurl,
                                          themeColor: widget.themeColor,
                                        ));
                              },
                              icon: Icon(Icons.edit),
                            ),
                          )
                        : Container(),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(kDetailsScreenTitleText),
                    background: SafeArea(
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SafeArea(
                          child: Container(
                            height: 22.h,
                            child: CustomLoadingSpinKitRing(
                                loadingColor: widget.themeColor),
                          ),
                        ),
                        imageUrl: widget.imgurl!,
                        errorWidget: (context, url, error) => SafeArea(
                          child: Container(
                            height: 22.h,
                            child: CustomLoadingSpinKitRing(
                                loadingColor: widget.themeColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 4.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.h),
                        child: Row(
                          children: [
                            Text(
                              "${widget.name} ",
                              style: kDetailScreenBoldTitle,
                            ),
                            Spacer(),
                            RedRoundedActionButton(
                              text: 'BUY TICKET',
                              callback: () async {
                                await navi.newScreen(
                                    context: context,
                                    newScreen: () => BuyTicket(
                                        widget.name,
                                        int.parse(widget.screeningRoom),
                                        widget.seats,
                                        widget.id));
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.h),
                        child: Container(
                          child: Text(kStoryLineTitleText,
                              style: kSmallTitleTextStyle),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.h),
                        child: Text(
                          widget.overview,
                          style: TextStyle(
                              fontSize: 16.sp, color: Color(0xFFC9C9C9)),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.h),
                        child: Text(
                          "Start Time: " + widget.startDate.toString(),
                          style: TextStyle(
                              fontSize: 16.sp, color: Color(0xFFC9C9C9)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.h),
                        child: Text(
                          "End Time: " + widget.endDate.toString(),
                          style: TextStyle(
                              fontSize: 16.sp, color: Color(0xFFC9C9C9)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
