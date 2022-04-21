import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

import '../../../core/api/app_urls.dart';
import '../../../core/constant/app_constant.dart';
import '../../../core/models/video_details_model.dart';
import '../../../core/view_models/actor_view_model.dart';
import '../../pages/tv_series_video_details/tv_series_video_details_page.dart';
import '../../pages/video_details/video_details_page.dart';
import '../../router/app_router.dart';

/// This widget contains the cast list of a video and used in [VideoDetailsPage]
/// and [TvSeriesVideoDetailsPage]
// ignore: must_be_immutable
class CastCard extends StatefulWidget {
  final List<Actors> actors;
  Function ontap;

  CastCard({this.actors, this.ontap});

  @override
  _CastCardState createState() => _CastCardState();
}

class _CastCardState extends State<CastCard> {
  @override
  void initState() {
    super.initState();
    Get.put(ActorViewModel());
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    return (widget?.actors?.length ?? 0) == 0
        ? Container()
        : Container(
            child: Column(
              children: [
                Container(
                  width: wp(100),
                  child: Text(
                    "Cast",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'poppins_bold',
                      color: Theme.of(context).textTheme.headline1.color,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GetBuilder<ActorViewModel>(
                  builder: (controller) => Container(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget?.actors?.length ?? 0,
                      itemBuilder: (_, i) => InkWell(
                        onTap: () {
                          widget.ontap?.call();
                          controller.getActorsMovies(
                              id: controller?.actorModel?.data[i]?.id);
                          AppRouter.navToActorsAllMoviesPage(
                            catImage: widget?.actors[i].img,
                            catName: widget?.actors[i].name,
                            fromVideoDetailsPage: true,
                          );
                        },
                        child: Container(
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: FadeInImage(
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  image: ExtendedNetworkImageProvider(
                                    AppUrls.imageBaseUrl +
                                            widget?.actors[i]?.img ??
                                        'https://picsum.photos/60',
                                    cache: true,
                                    cacheRawData: true,
                                    imageCacheName: AppUrls.imageBaseUrl +
                                            widget?.actors[i]?.img ??
                                        'https://picsum.photos/60',
                                  ),
                                  placeholder: AssetImage(
                                    ImageNames.thumbPlaceHolder,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Wrap(
                                children: [
                                  Text(
                                    widget.actors[i]?.name ?? "Actors name",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .color,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
