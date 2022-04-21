import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

import '../../../core/api/app_urls.dart';
import '../../../core/constant/app_constant.dart';
import '../../../core/models/tv_series_seasons_model.dart';
import '../../router/app_router.dart';

class CastCardTvSeries extends StatefulWidget {
  final List<Actors> actors;

  CastCardTvSeries({this.actors});

  @override
  _CastCardTvSeriesState createState() => _CastCardTvSeriesState();
}

class _CastCardTvSeriesState extends State<CastCardTvSeries> {
  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    return Container(
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
          Container(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget?.actors?.length ?? 0,
              itemBuilder: (_, i) => InkWell(
                onTap: () {
                  AppRouter.navToActorPage();
                },
                child: Container(
                  width: 80,
                  height: 80,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: FadeInImage(
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          image: ExtendedNetworkImageProvider(
                            AppUrls.imageBaseUrl + widget?.actors[i]?.img ??
                                'https://picsum.photos/60',
                            cache: true,
                            cacheRawData: true,
                            imageCacheName:
                                AppUrls.imageBaseUrl + widget?.actors[i]?.img ??
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
                            widget?.actors[i]?.name ?? "Actors name",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1.color,
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
        ],
      ),
    );
  }
}
