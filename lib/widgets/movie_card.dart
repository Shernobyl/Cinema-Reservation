import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies_app_flutter/model/movie_preview.dart';
import 'package:movies_app_flutter/screens/details_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:movies_app_flutter/utils/constants.dart';
import 'custom_loading_spin_kit_ring.dart';
import 'package:movies_app_flutter/utils/navi.dart' as navi;

class MovieCard extends StatelessWidget {
  final MoviePreview moviePreview;
  final Color themeColor;
  final int? contentLoadedFromPage;

  MovieCard({
    required this.moviePreview,
    required this.themeColor,
    this.contentLoadedFromPage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await navi.newScreen(
            context: context,
            newScreen: () => DetailsScreen(
                  id: moviePreview.id,
                  name: moviePreview.title,
                  overview: moviePreview.overview,
                  startDate: moviePreview.startDate,
                  endDate: moviePreview.endDate,
                  imgurl: (moviePreview.imageUrl != null)
                      ? moviePreview.imageUrl
                      : "https://lumiere-a.akamaihd.net/v1/images/usa_spider-man_fgt_ironspider_n_2754fed6.jpeg?region=0%2C0%2C634%2C357",
                  seats: moviePreview.seats,
                  screeningRoom: moviePreview.screeningRoom,
                  themeColor: themeColor,
                ));
        if (contentLoadedFromPage != null)
          kHomeScreenKey.currentState!.pageSwitcher(contentLoadedFromPage!);
      },
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Stack(
          children: [
            Container(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.2.w),
                  child: CachedNetworkImage(
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Column(
                            children: [
                              Container(
                                height: 20.h,
                                child: CustomLoadingSpinKitRing(
                                    loadingColor: themeColor),
                              )
                            ],
                          ),
                      imageUrl: (moviePreview.imageUrl != null)
                          ? moviePreview.imageUrl!
                          : "https://lumiere-a.akamaihd.net/v1/images/usa_spider-man_fgt_ironspider_n_2754fed6.jpeg?region=0%2C0%2C634%2C357",
                      errorWidget: (context, url, error) => Column(
                            children: [
                              Container(
                                height: 20.h,
                                child: CustomLoadingSpinKitRing(
                                    loadingColor: themeColor),
                              )
                            ],
                          )),
                ),
              ),
              height: 30.h,
              width: 41.5.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.w),
                color: Colors.black,
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5.w),
                      bottomRight: Radius.circular(5.w),
                    ),
                    color: kAppBarColor,
                    boxShadow: kBoxShadow,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${moviePreview.title} ",
                                      style: kBoldTitleTextStyle),
                                  Text(
                                      (moviePreview.year == "")
                                          ? ""
                                          : "Year: ${moviePreview.year.substring(0, 10)}",
                                      style: kDateTextStyle),
                                  Text(
                                      (moviePreview.startDate == "")
                                          ? ""
                                          : "Start Time: ${moviePreview.startDate.substring(11, 19)}",
                                      style: kDateTextStyle),
                                  Text(
                                      (moviePreview.endDate == "")
                                          ? ""
                                          : "End Time: ${moviePreview.endDate.substring(11, 19)}",
                                      style: kDateTextStyle),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.0.w),
                        Text(
                          moviePreview.overview,
                          style: kSubTitleCardBoxTextStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
